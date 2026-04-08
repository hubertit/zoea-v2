/**
 * Recategorize miscategorized Kigali accommodation + import missing curated places (Google Text Search + ingest).
 *
 * From apps/places-scraper (reads ../backend/.env for DATABASE_URL if unset):
 *   npx ts-node src/fix-kigali-accommodation-gaps.ts
 *   DRY_RUN=1 npx ts-node src/fix-kigali-accommodation-gaps.ts
 *   SKIP_IMPORT=1 npx ts-node src/fix-kigali-accommodation-gaps.ts
 *
 * Requires GOOGLE_PLACES_API_KEY unless SKIP_IMPORT=1.
 */

import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { v2 as cloudinary } from 'cloudinary';
import * as fs from 'fs';
import * as path from 'path';
import {
  createSystemMerchant,
  ingestGooglePlaceForCategory,
  type IngestContext,
} from './google-place-ingest';
import { loadLodgingAmenitySlugMap } from './lodging-from-google';

const prisma = new PrismaClient();

const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';
const SKIP_IMPORT = process.env.SKIP_IMPORT === '1' || process.env.SKIP_IMPORT === 'true';
const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY;
const DELAY_MS = Math.max(0, Number(process.env.DELAY_MS ?? 2000));

let cloudinaryConfigured = false;

function loadBackendEnv(): void {
  if (process.env.DATABASE_URL) return;
  const envPath = path.join(__dirname, '../../backend/.env');
  if (!fs.existsSync(envPath)) return;
  for (const line of fs.readFileSync(envPath, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^DATABASE_URL=(.*)$/);
    if (m) {
      process.env.DATABASE_URL = m[1].trim().replace(/^["']|["']$/g, '');
      break;
    }
  }
}

async function configureStorage(): Promise<void> {
  if (process.env.CLOUDINARY_CLOUD_NAME) {
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
    cloudinaryConfigured = true;
    return;
  }
  try {
    const integration: any = await prisma.$queryRaw`SELECT config FROM integrations WHERE name = 'cloudinary' LIMIT 1`;
    if (integration?.[0]?.config?.cloudName) {
      const c = integration[0].config;
      cloudinary.config({
        cloud_name: c.cloudName,
        api_key: c.apiKey,
        api_secret: c.apiSecret,
      });
      cloudinaryConfigured = true;
    }
  } catch {
    /* optional */
  }
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

function inferListingTypeForSlug(categorySlug: string): string {
  const s = categorySlug.toLowerCase();
  if (/\b(fast-food)\b/.test(s)) return 'fast_food';
  if (/\b(cafe|coffee)\b/.test(s)) return 'cafe';
  if (/\b(bar|pub)\b/.test(s)) return 'bar';
  if (/\b(club)\b/.test(s)) return 'club';
  if (/\b(lounge)\b/.test(s)) return 'lounge';
  if (/\b(mall)\b/.test(s)) return 'mall';
  if (/\b(market)\b/.test(s)) return 'market';
  if (/\b(boutique)\b/.test(s)) return 'boutique';
  if (/\b(hotel|resort|motel|hostel|bnb|apartment|villa|lodg)\b/.test(s)) return 'hotel';
  return 'hotel';
}

type ImportTarget = { query: string; categorySlug: string };

const IMPORT_TARGETS: ImportTarget[] = [
  { query: 'Discover Rwanda Youth Hostel Kigali', categorySlug: 'hostels' },
  { query: 'Phoenix Apartment Kigali Rwanda', categorySlug: 'apartments' },
  { query: 'Simba Apartments Kigali', categorySlug: 'apartments' },
  { query: 'Mamba Club Hostel Kigali', categorySlug: 'hostels' },
  { query: 'Rebero Hills Villas Kigali', categorySlug: 'villas' },
  { query: 'Nyarutarama Luxury Villas Kigali', categorySlug: 'villas' },
  { query: 'Vision Hill Villas Kigali', categorySlug: 'villas' },
  { query: 'The Retreat by Heaven Kigali', categorySlug: 'hotels' },
  { query: "Traveller's Rest Motel Kigali", categorySlug: 'motels' },
  { query: 'Stipp Hotel Gisozi Kigali', categorySlug: 'hotels' },
  { query: 'Dereva Hotel Kigali', categorySlug: 'hotels' },
];

async function textSearchFirst(query: string): Promise<{ place_id: string; name: string } | null> {
  if (!GOOGLE_API_KEY) return null;
  const res = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
    params: { query: `${query}`, key: GOOGLE_API_KEY },
  });
  if (res.data.status !== 'OK' && res.data.status !== 'ZERO_RESULTS') {
    console.warn(`Text search status ${res.data.status}: ${res.data.error_message || ''}`);
  }
  const results = res.data.results || [];
  if (results.length === 0) return null;
  const p = results[0];
  return p.place_id ? { place_id: p.place_id, name: p.name } : null;
}

async function mergeOrRecategorizeOnomo(cityId: string, hotelsCatId: string): Promise<void> {
  const rows = await prisma.listing.findMany({
    where: {
      cityId,
      deletedAt: null,
      name: { contains: 'Onomo', mode: 'insensitive' },
    },
    select: {
      id: true,
      name: true,
      sourcePlaceId: true,
      categoryId: true,
      _count: { select: { images: true } },
    },
  });
  if (rows.length <= 1) return;

  const rank = (r: (typeof rows)[0]) =>
    (r.sourcePlaceId ? 1000 : 0) + r._count.images * 10 + (r.categoryId === hotelsCatId ? 100 : 0);

  const sorted = [...rows].sort((a, b) => rank(b) - rank(a));
  const keep = sorted[0]!;
  const drop = sorted.slice(1);
  if (DRY_RUN) {
    console.log(
      `[DRY_RUN] Onomo: would keep "${keep.name}", soft-delete ${drop.length} duplicate(s): ${drop.map((d) => d.name).join('; ')}`,
    );
    return;
  }
  console.log(`Onomo: keeping "${keep.name}" (${keep.id}), soft-deleting ${drop.length} duplicate(s)`);
  await prisma.listing.updateMany({
    where: { id: { in: drop.map((d) => d.id) } },
    data: { deletedAt: new Date() },
  });
}

async function phaseDbFixes(): Promise<{
  city: { id: string };
  countryId: string;
}> {
  const kigali = await prisma.city.findFirst({
    where: { slug: 'kigali', isActive: true },
    select: { id: true, countryId: true },
  });
  if (!kigali?.countryId) throw new Error('Kigali city not found or has no country');

  const cat = async (slug: string) => {
    const c = await prisma.category.findFirst({ where: { slug, isActive: true }, select: { id: true } });
    if (!c) throw new Error(`Category not found: ${slug}`);
    return c.id;
  };

  const hotelsId = await cat('hotels');
  const apartmentsId = await cat('apartments');
  const bnbsId = await cat('bnbs');

  const patch = async (
    label: string,
    where: object,
    data: { categoryId?: string; type?: 'hotel'; shortDescription?: string },
  ) => {
    if (DRY_RUN) {
      const n = await prisma.listing.count({ where: { ...where, deletedAt: null, cityId: kigali.id } as any });
      console.log(`[DRY_RUN] ${label}: would affect ${n} listing(s)`, data);
      return;
    }
    const res = await prisma.listing.updateMany({
      where: { ...where, deletedAt: null, cityId: kigali.id } as any,
      data,
    });
    console.log(`${label}: updated ${res.count} row(s)`);
  };

  await patch(
    'Marriott → hotels',
    { name: { contains: 'Marriott', mode: 'insensitive' } },
    { categoryId: hotelsId, type: 'hotel' },
  );

  await patch(
    'Onomo → hotels',
    { name: { contains: 'Onomo', mode: 'insensitive' } },
    { categoryId: hotelsId, type: 'hotel' },
  );
  await mergeOrRecategorizeOnomo(kigali.id, hotelsId);

  await patch(
    'Urban by CityBlue → apartments',
    { name: { contains: 'CityBlue', mode: 'insensitive' } },
    { categoryId: apartmentsId, type: 'hotel' },
  );

  await patch(
    'Kigali ViewDeck alias',
    { name: { contains: 'ViewDeck', mode: 'insensitive' } },
    {
      shortDescription: 'Also known as Kigali View Apartments (ViewDeck).',
    },
  );

  await patch(
    '2000 Hotel alias',
    { name: { equals: '2000 Hotel', mode: 'insensitive' } },
    { shortDescription: '2000 Hotel Downtown Kigali.' },
  );

  await patch(
    'Home Inn alias',
    { name: { contains: 'KAZE CONSOLIDATE HOME INN', mode: 'insensitive' } },
    { shortDescription: 'Home Inn Kigali.', categoryId: bnbsId, type: 'hotel' },
  );

  await patch(
    "Traveller's Stay alias",
    {
      AND: [
        { name: { contains: 'Traveller', mode: 'insensitive' } },
        { name: { contains: 'Stay', mode: 'insensitive' } },
      ],
    },
    {
      shortDescription:
        'Often listed as Traveller’s Rest / Traveller’s Stay in Kigali — verify on Google Maps if name differs.',
    },
  );

  return { city: { id: kigali.id }, countryId: kigali.countryId };
}

async function importTargets(
  ingestCtx: IngestContext,
  merchant: { id: string },
  city: { id: string },
  countryId: string,
  standardAmenities: { id: string }[],
  lodgingAmenitySlugToId: Map<string, string>,
): Promise<void> {
  const seen = new Set<string>();
  for (const t of IMPORT_TARGETS) {
    const category = await prisma.category.findFirst({
      where: { slug: t.categorySlug, isActive: true },
      select: { id: true, slug: true },
    });
    if (!category) {
      console.warn(`Skip import: category ${t.categorySlug} missing`);
      continue;
    }
    const listingType = inferListingTypeForSlug(category.slug);
    console.log(`\nImport: "${t.query}" → ${category.slug}`);

    const place = await textSearchFirst(`${t.query}`);
    if (!place) {
      console.warn('  No Text Search results');
      continue;
    }
    console.log(`  Top result: ${place.name} (${place.place_id})`);

    const existing = await prisma.listing.findFirst({
      where: { sourcePlaceId: place.place_id, deletedAt: null },
      select: { id: true, name: true, categoryId: true, cityId: true, type: true },
    });

    if (existing) {
      const needs =
        existing.categoryId !== category.id ||
        existing.cityId !== city.id ||
        existing.type !== listingType;
      if (!needs) {
        console.log('  Already in DB with correct category/city');
        continue;
      }
      if (DRY_RUN) {
        console.log(`  [DRY_RUN] Would recategorize ${existing.name}`);
      } else {
        await prisma.listing.update({
          where: { id: existing.id },
          data: {
            categoryId: category.id,
            cityId: city.id,
            countryId,
            type: listingType as any,
          },
        });
        console.log(`  Recategorized existing listing → ${category.slug}`);
      }
      continue;
    }

    if (DRY_RUN) {
      console.log('  [DRY_RUN] Would ingest new listing from Places');
    } else {
      const ok = await ingestGooglePlaceForCategory(
        ingestCtx,
        place,
        category.id,
        category.slug,
        listingType,
        merchant,
        city,
        { id: countryId },
        standardAmenities,
        lodgingAmenitySlugToId,
        seen,
      );
      console.log(ok ? '  Ingested.' : '  Not ingested (duplicate name/city or error).');
    }

    if (DELAY_MS) await sleep(DELAY_MS);
  }
}

async function main(): Promise<void> {
  loadBackendEnv();
  if (!process.env.DATABASE_URL) {
    console.error('DATABASE_URL missing (set env or apps/backend/.env)');
    process.exit(1);
  }

  console.log(DRY_RUN ? 'DRY_RUN mode (no writes)' : 'Applying fixes');
  await configureStorage();

  const { city, countryId } = await phaseDbFixes();

  if (SKIP_IMPORT) {
    console.log('\nSKIP_IMPORT=1 — done.');
    return;
  }
  if (!GOOGLE_API_KEY) {
    console.error('GOOGLE_PLACES_API_KEY required for import phase (or set SKIP_IMPORT=1)');
    process.exit(1);
  }

  const merchant = await createSystemMerchant(prisma);
  const ingestCtx: IngestContext = {
    prisma,
    googleApiKey: GOOGLE_API_KEY,
    curatedPopularityBoost: process.env.SCRAPE_CURATED_BOOST === '1',
    cloudinaryConfigured,
  };

  const standardAmenities = await prisma.amenity.findMany({
    where: { slug: { in: ['wifi', 'parking', 'ac', 'tv', 'room-service', 'pool'] } },
  });
  const lodgingAmenitySlugToId = await loadLodgingAmenitySlugMap(prisma);

  await importTargets(ingestCtx, merchant, city, countryId, standardAmenities, lodgingAmenitySlugToId);
  console.log('\nDone.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
