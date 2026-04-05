import { listing_type } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';

const SLUG_TO_TYPE: Record<string, listing_type> = {
  hotel: 'hotel',
  hotels: 'hotel',
  restaurant: 'restaurant',
  restaurants: 'restaurant',
  'fast-food': 'fast_food',
  fast_food: 'fast_food',
  cafe: 'cafe',
  cafes: 'cafe',
  bar: 'bar',
  bars: 'bar',
  club: 'club',
  clubs: 'club',
  'night-clubs': 'club',
  lounge: 'lounge',
  lounges: 'lounge',
  boutique: 'boutique',
  boutiques: 'boutique',
  mall: 'mall',
  malls: 'mall',
  market: 'market',
  markets: 'market',
  tour: 'tour',
  tours: 'tour',
  event: 'event',
  events: 'event',
  attraction: 'attraction',
  attractions: 'attraction',
};

const PARENT_DEFAULT: Record<string, listing_type> = {
  dining: 'restaurant',
  accommodation: 'hotel',
  nightlife: 'bar',
  shopping: 'boutique',
  experiences: 'tour',
  'tour-and-travel': 'tour',
};

/**
 * Derives listing_type from category tree so clients can omit `type` when categoryId is set.
 */
export async function inferListingTypeFromCategoryId(
  prisma: PrismaService,
  categoryId: string,
): Promise<listing_type> {
  const cat = await prisma.category.findUnique({
    where: { id: categoryId },
    select: { slug: true, parent: { select: { slug: true } } },
  });
  if (!cat) {
    return 'attraction';
  }
  const s = (cat.slug || '').toLowerCase();
  if (SLUG_TO_TYPE[s]) {
    return SLUG_TO_TYPE[s];
  }
  const p = (cat.parent?.slug || '').toLowerCase();
  if (p && PARENT_DEFAULT[p]) {
    return PARENT_DEFAULT[p];
  }
  if (s.includes('tour') || s.includes('experience')) {
    return 'tour';
  }
  if (s.includes('event')) {
    return 'event';
  }
  return 'attraction';
}
