/**
 * Re-fetch Google Place Details for existing accommodation listings and merge richer
 * lodging fields (tiered room plans if none, amenities, hours, price range).
 *
 * From apps/places-scraper:
 *   npx ts-node src/enrich-lodging-from-places.ts
 *   LIMIT=50 DRY_RUN=1 npx ts-node src/enrich-lodging-from-places.ts
 *
 * Env:
 *   CITY_SLUG=kigali          — only listings in this city (optional)
 *   LIMIT=200
 *   DELAY_MS=1500
 *   DRY_RUN=1
 *   SCRAPE_LODGING_CURRENCY   — default USD (same as ingest)
 */

import { PrismaClient } from '@prisma/client';
import * as fs from 'fs';
import * as path from 'path';
import {
  buildLodgingRoomPlans,
  fetchGooglePlaceDetails,
  lodgingCurrency,
  loadLodgingAmenitySlugMap,
  operatingHoursPayload,
  pickLodgingAmenityIds,
  preferredPhone,
} from './lodging-from-google';
import { shouldCreateHotelRooms, truncate } from './google-place-ingest';

const prisma = new PrismaClient();

const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';
const LIMIT = process.env.LIMIT ? Math.max(1, parseInt(process.env.LIMIT, 10)) : undefined;
const DELAY_MS = Math.max(0, Number(process.env.DELAY_MS ?? 1500));
const CITY_SLUG = (process.env.CITY_SLUG ?? '').trim();
const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

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

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

async function main(): Promise<void> {
  loadBackendEnv();
  if (!process.env.DATABASE_URL) {
    console.error('DATABASE_URL missing');
    process.exit(1);
  }
  if (!GOOGLE_API_KEY) {
    console.error('GOOGLE_PLACES_API_KEY required');
    process.exit(1);
  }

  const accRoot = await prisma.category.findFirst({
    where: { slug: 'accommodation', parentId: null, isActive: true },
    select: { id: true },
  });
  if (!accRoot) {
    console.error('accommodation root not found');
    process.exit(1);
  }

  let cityId: string | undefined;
  if (CITY_SLUG) {
    const c = await prisma.city.findFirst({
      where: { slug: CITY_SLUG, isActive: true },
      select: { id: true },
    });
    if (!c) {
      console.error(`City ${CITY_SLUG} not found`);
      process.exit(1);
    }
    cityId = c.id;
  }

  const catIds = await subtreeCategoryIds(accRoot.id);

  const rows = await prisma.listing.findMany({
    where: {
      deletedAt: null,
      sourcePlaceId: { not: null },
      categoryId: { in: catIds },
      ...(cityId ? { cityId } : {}),
    },
    select: { id: true, sourcePlaceId: true },
    orderBy: { updatedAt: 'asc' },
    take: LIMIT,
  });

  const slugMap = await loadLodgingAmenitySlugMap(prisma);
  console.log(`Enriching ${rows.length} listings (${slugMap.size} amenity slugs). ${DRY_RUN ? 'DRY_RUN' : ''}`);

  let ok = 0;
  let skip = 0;
  for (const row of rows) {
    const full = await prisma.listing.findUnique({
      where: { id: row.id },
      include: {
        category: { select: { slug: true } },
        amenities: { select: { amenityId: true } },
        roomTypes: { select: { id: true }, take: 1 },
      },
    });
    if (!full?.sourcePlaceId || !full.category) {
      skip++;
      continue;
    }
    const listingType = (full.type ?? 'hotel') as string;
    if (!shouldCreateHotelRooms(full.category.slug, listingType)) {
      skip++;
      continue;
    }

    try {
      const details = await fetchGooglePlaceDetails(GOOGLE_API_KEY, full.sourcePlaceId);
      if (!details) {
        console.warn(`No details for ${full.name} (${full.sourcePlaceId})`);
        skip++;
        continue;
      }

      const plans = buildLodgingRoomPlans(details.price_level);
      const cur = lodgingCurrency();
      const minP = Math.min(...plans.map((p) => p.basePrice));
      const maxP = Math.max(...plans.map((p) => p.basePrice));
      const oh = operatingHoursPayload(details);
      const phone = preferredPhone(details) ?? full.contactPhone;
      const acceptsBookings = details.reservable === true || full.acceptsBookings === true;

      const pickedAmenities = pickLodgingAmenityIds(details, slugMap);
      const haveAmenity = new Set(full.amenities.map((a) => a.amenityId));
      const newAmenityIds = pickedAmenities.filter((id) => !haveAmenity.has(id));

      if (DRY_RUN) {
        console.log(
          `[DRY_RUN] ${full.name}: min/max ${minP}-${maxP} ${cur}, +${newAmenityIds.length} amenities, rooms=${full.roomTypes.length === 0 ? `add ${plans.length}` : 'keep'}`,
        );
        ok++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      await prisma.listing.update({
        where: { id: full.id },
        data: {
          minPrice: minP,
          maxPrice: maxP,
          currency: cur,
          priceUnit: 'per_night',
          operatingHours: oh as any,
          contactPhone: phone ?? undefined,
          acceptsBookings,
        },
      });

      for (const aid of newAmenityIds) {
        await prisma.listingAmenity.create({
          data: { listingId: full.id, amenityId: aid },
        });
      }

      if (full.roomTypes.length === 0) {
        for (const rt of plans) {
          const roomType = await prisma.roomType.create({
            data: {
              listingId: full.id,
              name: truncate(rt.name, 100)!,
              description: truncate(rt.description, 500),
              maxOccupancy: rt.maxOccupancy,
              bedType: rt.bedType,
              bedCount: rt.bedCount,
              basePrice: rt.basePrice,
              currency: cur,
              totalRooms: 5,
              isActive: true,
              amenities: [],
              images: [],
            },
          });
          for (let r = 1; r <= 5; r++) {
            await prisma.room.create({
              data: {
                roomTypeId: roomType.id,
                roomNumber: `${Math.floor(Math.random() * 9 + 1)}0${r}`,
                floor: 1,
                status: 'available' as any,
              },
            });
          }
        }
      }

      ok++;
      console.log(`Updated ${full.name} (+${newAmenityIds.length} amenities)`);
    } catch (e: any) {
      console.error(full.name, e?.message ?? e);
    }

    if (DELAY_MS) await sleep(DELAY_MS);
  }

  console.log(`\nDone. Updated ${ok}, skipped ${skip}.`);
}

async function subtreeCategoryIds(rootId: string): Promise<string[]> {
  const sub = await prisma.$queryRaw<{ id: string }[]>`
    WITH RECURSIVE subtree AS (
      SELECT id FROM categories WHERE id = CAST(${rootId} AS uuid)
      UNION
      SELECT c.id FROM categories c
      INNER JOIN subtree s ON c.parent_id = s.id
      WHERE c.is_active = true
    )
    SELECT id::text AS id FROM subtree
  `;
  return sub.map((r) => r.id);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
