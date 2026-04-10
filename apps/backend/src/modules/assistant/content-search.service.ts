import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const DISCOVERY_STOPWORDS = new Set([
  'in',
  'at',
  'the',
  'a',
  'an',
  'for',
  'to',
  'and',
  'or',
  'near',
  'me',
  'my',
  'of',
  'on',
  'with',
  'is',
  'are',
  'was',
  'how',
  'what',
  'where',
  'when',
  'who',
  'any',
  'some',
  'get',
  'nearby',
]);

export interface ContentSearchParams {
  query: string;
  /**
   * Latest user message (chip or typed). Merged into `query` for token extraction and used to infer
   * dining/stay intent so we do not rank airport taxis for "restaurants in Kigali".
   */
  anchorMessage?: string;
  types?: ('listing' | 'tour' | 'product' | 'service')[];
  limit?: number;
  lat?: number;
  lng?: number;
  radius?: number; // km
}

/** Narrow listing rows for assistant search (food/venue, stay, or out). */
export type DiscoveryListingIntent = 'general' | 'dining' | 'stay' | 'nightlife';

export function inferListingIntent(text: string): DiscoveryListingIntent {
  const m = (text ?? '').toLowerCase();
  if (
    /(hotel|hotels|\bstay\b|\bstays\b|sleep|lodg|guesthouse|accommodation|\bbnb\b)/i.test(m)
  ) {
    return 'stay';
  }
  if (
    /(restaurant|restaurants|dining|\beat\b|eating|food|brunch|breakfast|lunch|dinner|vegetarian|vegan|halal|pizza|coffee|cafe|café|bistro|kitchen|cuisine|chef|\bmenu\b|brochettes)/i.test(
      m,
    )
  ) {
    return 'dining';
  }
  if (/(^|\b)(bar|bars|nightlife|club|clubs|lounge|pub)\b/i.test(m)) {
    return 'nightlife';
  }
  return 'general';
}

export interface SearchResult {
  type: 'listing' | 'tour' | 'product' | 'service';
  id: string;
  title: string;
  subtitle: string;
  imageUrl?: string;
  rating?: number;
  price?: number;
  currency?: string;
  distance?: number; // km
  route: string;
  params: Record<string, any>;
}

/**
 * Suggestion chips often use full English phrases ("Try restaurants in Kigali"). Prisma `contains`
 * matches the entire substring, so the leading word "Try" prevents almost all hits. Strip common
 * prefixes so chip taps behave like typed keywords.
 */
export function normalizeDiscoveryQuery(raw: string): string {
  const original = (raw ?? '').trim().replace(/\s+/g, ' ');
  if (!original) return original;

  let s = original;
  const prefixes = [
    /^try\s+/i,
    /^find\s+/i,
    /^show\s+me\s+/i,
    /^discover\s+/i,
    /^looking\s+for\s+/i,
    /^i(?:'m|\s+am)\s+looking\s+for\s+/i,
    /^can\s+you\s+(?:help\s+me\s+)?(?:find|suggest|show)\s+/i,
    /^please\s+(?:find|show|suggest)\s+/i,
    /^give\s+me\s+(?:some\s+)?/i,
    /^tell\s+me\s+about\s+/i,
    /^what(?:'s|\s+is)\s+good\s+(?:for\s+)?/i,
  ];

  for (const re of prefixes) {
    s = s.replace(re, '').trim().replace(/\s+/g, ' ');
  }

  // App suggestion chip — expand to searchable terms
  if (/^tours?\s+and\s+experiences?$/i.test(s)) {
    s = 'tour safari experience day trip';
  }

  return s.length >= 2 ? s : original;
}

/**
 * `contains` is substring match. Natural language like "restaurants in Kigali" often appears in
 * data only as "Kigali" + "restaurant". Collect the full phrase plus significant tokens (OR).
 */
export function discoverySearchTerms(normalizedQuery: string): string[] {
  const q = normalizedQuery.trim().replace(/\s+/g, ' ');
  if (!q) return [];

  const tokens = q
    .split(/\s+/)
    .map((t) => t.replace(/^[,.;:]+|[,.;:]+$/g, ''))
    .filter((t) => t.length > 0);

  const keywords = tokens.filter((t) => {
    const low = t.toLowerCase();
    if (DISCOVERY_STOPWORDS.has(low)) return false;
    return t.length >= 3 || /^[A-Za-z]{2,3}$/.test(t);
  });

  const out: string[] = [];
  if (q.length >= 2) out.push(q);
  for (const k of keywords) {
    if (!out.some((x) => x.toLowerCase() === k.toLowerCase())) out.push(k);
  }
  return [...new Set(out)].slice(0, 10);
}

@Injectable()
export class ContentSearchService {
  constructor(private prisma: PrismaService) {}

  /**
   * Global content search across all types (excluding events)
   * This is the main "tool" the AI assistant uses
   */
  async searchContent(params: ContentSearchParams): Promise<SearchResult[]> {
    const {
      query,
      anchorMessage,
      types = ['listing', 'tour', 'product', 'service'],
      limit = 10,
      lat,
      lng,
      radius = 50,
    } = params;

    const anchor = (anchorMessage ?? '').trim();
    const tool = (query ?? '').trim();
    const mergedForTerms = [anchor, tool].filter(Boolean).join(' ').trim() || tool || anchor;
    const effectiveQuery = normalizeDiscoveryQuery(mergedForTerms);
    const terms = discoverySearchTerms(effectiveQuery);
    const intent = inferListingIntent(
      normalizeDiscoveryQuery(anchor) || normalizeDiscoveryQuery(tool) || effectiveQuery,
    );
    const results: SearchResult[] = [];

    // Search listings
    if (types.includes('listing')) {
      const listings = await this.searchListings(terms, limit, intent, lat, lng, radius);
      results.push(...listings);
    }

    // Search tours
    if (types.includes('tour')) {
      const tours = await this.searchTours(terms, limit, lat, lng, radius);
      results.push(...tours);
    }

    // Search products
    if (types.includes('product')) {
      const products = await this.searchProducts(terms, limit);
      results.push(...products);
    }

    // Search services
    if (types.includes('service')) {
      const services = await this.searchServices(terms, limit);
      results.push(...services);
    }

    // Sort by relevance/rating and limit
    return results
      .sort((a, b) => (b.rating || 0) - (a.rating || 0))
      .slice(0, limit);
  }

  private listingOrConditions(terms: string[]): Prisma.ListingWhereInput[] {
    const or: Prisma.ListingWhereInput[] = [];
    for (const term of terms) {
      if (term.length < 2) continue;
      or.push({ name: { contains: term, mode: 'insensitive' } });
      or.push({ description: { contains: term, mode: 'insensitive' } });
      or.push({ tags: { some: { tag: { name: { contains: term, mode: 'insensitive' } } } } });
    }
    return or;
  }

  private mapListingRows(
    listings: Array<{
      id: string;
      name: string | null;
      rating: Prisma.Decimal | null;
      city: { name: string | null } | null;
      category: { name: string | null } | null;
      images: Array<{ media: { url: string } | null }>;
    }>,
  ): SearchResult[] {
    return listings.map((listing) => ({
      type: 'listing' as const,
      id: listing.id,
      title: listing.name ?? 'Listing',
      subtitle: `${listing.city?.name || ''} • ${listing.category?.name || ''}`,
      imageUrl: listing.images[0]?.media?.url,
      rating: listing.rating ? parseFloat(listing.rating.toString()) : undefined,
      route: '/listing/:id',
      params: { id: listing.id },
    }));
  }

  private async searchListings(
    terms: string[],
    limit: number,
    intent: DiscoveryListingIntent,
    lat?: number,
    lng?: number,
    radius?: number,
  ): Promise<SearchResult[]> {
    const or = this.listingOrConditions(terms);
    if (or.length === 0) return [];

    const take = Math.ceil(limit / 4);
    const include = {
      city: { select: { name: true } },
      category: { select: { name: true } },
      images: { include: { media: true }, take: 1, where: { isPrimary: true } },
    };
    const orderBy = [{ isFeatured: 'desc' as const }, { rating: 'desc' as const }];

    const run = (where: Prisma.ListingWhereInput) =>
      this.prisma.listing.findMany({
        where,
        take,
        include,
        orderBy,
      });

    if (intent === 'dining') {
      const narrowed = await run({
        deletedAt: null,
        status: 'active',
        type: { in: ['restaurant', 'cafe', 'fast_food', 'bar', 'club', 'lounge'] },
        OR: or,
      });
      if (narrowed.length > 0) return this.mapListingRows(narrowed);
    }

    if (intent === 'stay') {
      const narrowed = await run({
        deletedAt: null,
        status: 'active',
        type: 'hotel',
        OR: or,
      });
      if (narrowed.length > 0) return this.mapListingRows(narrowed);
    }

    if (intent === 'nightlife') {
      const narrowed = await run({
        deletedAt: null,
        status: 'active',
        type: { in: ['bar', 'club', 'lounge'] },
        OR: or,
      });
      if (narrowed.length > 0) return this.mapListingRows(narrowed);
    }

    const transportNoise: Prisma.ListingWhereInput = {
      OR: [
        { name: { contains: 'taxi', mode: 'insensitive' } },
        { name: { contains: 'shuttle', mode: 'insensitive' } },
        { description: { contains: 'airport shuttle', mode: 'insensitive' } },
      ],
    };

    const broad = await run({
      deletedAt: null,
      status: 'active',
      AND: [{ OR: or }, { NOT: transportNoise }],
    });
    if (broad.length > 0) return this.mapListingRows(broad);

    const fallback = await run({
      deletedAt: null,
      status: 'active',
      OR: or,
    });
    return this.mapListingRows(fallback);
  }

  private async searchTours(
    terms: string[],
    limit: number,
    lat?: number,
    lng?: number,
    radius?: number,
  ): Promise<SearchResult[]> {
    const or: Prisma.TourWhereInput[] = [];
    for (const term of terms) {
      if (term.length < 2) continue;
      or.push({ name: { contains: term, mode: 'insensitive' } });
      or.push({ description: { contains: term, mode: 'insensitive' } });
    }
    if (or.length === 0) return [];

    const tours = await this.prisma.tour.findMany({
      where: {
        deletedAt: null,
        status: 'active',
        OR: or,
      },
      take: Math.ceil(limit / 4),
      include: {
        city: { select: { name: true } },
      },
      orderBy: [{ isFeatured: 'desc' }, { rating: 'desc' }],
    });

    return tours.map(tour => {
      const durationText = tour.durationDays 
        ? `${tour.durationDays} day${tour.durationDays > 1 ? 's' : ''}`
        : tour.durationHours 
        ? `${tour.durationHours}h`
        : 'Tour';

      return {
        type: 'tour' as const,
        id: tour.id,
        title: tour.name || 'Tour',
        subtitle: `${tour.city?.name || ''} • ${durationText}`,
        imageUrl: undefined, // Tours have complex image relations, will handle separately
        rating: tour.rating ? parseFloat(tour.rating.toString()) : undefined,
        price: tour.pricePerPerson ? parseFloat(tour.pricePerPerson.toString()) : undefined,
        currency: tour.currency || 'RWF',
        route: '/tour/:id',
        params: { id: tour.id },
      };
    });
  }

  private async searchProducts(terms: string[], limit: number): Promise<SearchResult[]> {
    const or: Prisma.ProductWhereInput[] = [];
    for (const term of terms) {
      if (term.length < 2) continue;
      or.push({ name: { contains: term, mode: 'insensitive' } });
      or.push({ description: { contains: term, mode: 'insensitive' } });
    }
    if (or.length === 0) return [];

    const products = await this.prisma.product.findMany({
      where: {
        deletedAt: null,
        status: 'active',
        OR: or,
      },
      take: Math.ceil(limit / 4),
      include: {
        listing: { select: { name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    return products.map(product => ({
      type: 'product' as const,
      id: product.id,
      title: product.name,
      subtitle: product.listing?.name || 'Product',
      imageUrl: undefined, // Products have array of image IDs, will handle separately
      price: product.basePrice ? parseFloat(product.basePrice.toString()) : undefined,
      currency: product.currency || 'RWF',
      route: '/product/:id',
      params: { id: product.id },
    }));
  }

  private async searchServices(terms: string[], limit: number): Promise<SearchResult[]> {
    const or: Prisma.ServiceWhereInput[] = [];
    for (const term of terms) {
      if (term.length < 2) continue;
      or.push({ name: { contains: term, mode: 'insensitive' } });
      or.push({ description: { contains: term, mode: 'insensitive' } });
    }
    if (or.length === 0) return [];

    const services = await this.prisma.service.findMany({
      where: {
        deletedAt: null,
        status: 'active',
        OR: or,
      },
      take: Math.ceil(limit / 4),
      include: {
        listing: { select: { name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    return services.map(service => ({
      type: 'service' as const,
      id: service.id,
      title: service.name,
      subtitle: service.listing?.name || 'Service',
      imageUrl: undefined, // Services have array of image IDs, will handle separately
      price: service.basePrice ? parseFloat(service.basePrice.toString()) : undefined,
      currency: service.currency || 'RWF',
      route: '/service/:id',
      params: { id: service.id },
    }));
  }

  /**
   * Get all categories (for AI to understand taxonomy)
   */
  async getCategories() {
    return this.prisma.category.findMany({
      select: { id: true, name: true, slug: true, description: true },
      orderBy: { name: 'asc' },
    });
  }
}

