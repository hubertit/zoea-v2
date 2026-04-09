/**
 * Backfill listing `address` and PostGIS `location` from Google Place Details
 * for existing rows that have `source_place_id` but are missing one or both.
 *
 * From apps/places-scraper:
 *   npx ts-node src/backfill-listing-location-address.ts
 *   DRY_RUN=1 LIMIT=50 npx ts-node src/backfill-listing-location-address.ts
 *
 * Env:
 *   DRY_RUN=1
 *   LIMIT=200
 *   DELAY_MS=1200
 *   CITY_SLUG=kigali         (optional)
 */

import { PrismaClient } from '@prisma/client';
import { fetchGooglePlaceDetails } from './lodging-from-google';
import { loadPlacesScraperEnvFromFiles, resolveGooglePlacesApiKey } from './resolve-google-places-key';

const prisma = new PrismaClient();

const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';
const LIMIT = process.env.LIMIT ? Math.max(1, parseInt(process.env.LIMIT, 10)) : 200;
const DELAY_MS = Math.max(0, Number(process.env.DELAY_MS ?? 1200));
const CITY_SLUG = (process.env.CITY_SLUG ?? '').trim();

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

type MissingRow = {
  id: string;
  name: string | null;
  sourcePlaceId: string;
  address: string | null;
  hasLocation: boolean;
};

async function resolveCityId(slug: string): Promise<string | undefined> {
  if (!slug) return undefined;
  const city = await prisma.city.findFirst({
    where: { slug, isActive: true },
    select: { id: true },
  });
  if (!city) {
    throw new Error(`City not found for slug "${slug}"`);
  }
  return city.id;
}

async function loadCandidates(cityId?: string): Promise<MissingRow[]> {
  if (cityId) {
    return prisma.$queryRaw<MissingRow[]>`
      SELECT
        l.id::text AS id,
        l.name,
        l.source_place_id AS "sourcePlaceId",
        l.address,
        (l.location IS NOT NULL) AS "hasLocation"
      FROM listings l
      WHERE l.deleted_at IS NULL
        AND l.source_place_id IS NOT NULL
        AND l.city_id = CAST(${cityId} AS uuid)
        AND (
          l.address IS NULL
          OR btrim(l.address) = ''
          OR l.location IS NULL
        )
      ORDER BY l.updated_at ASC
      LIMIT ${LIMIT}
    `;
  }

  return prisma.$queryRaw<MissingRow[]>`
    SELECT
      l.id::text AS id,
      l.name,
      l.source_place_id AS "sourcePlaceId",
      l.address,
      (l.location IS NOT NULL) AS "hasLocation"
    FROM listings l
    WHERE l.deleted_at IS NULL
      AND l.source_place_id IS NOT NULL
      AND (
        l.address IS NULL
        OR btrim(l.address) = ''
        OR l.location IS NULL
      )
    ORDER BY l.updated_at ASC
    LIMIT ${LIMIT}
  `;
}

async function main(): Promise<void> {
  loadPlacesScraperEnvFromFiles();
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL missing');
  }

  const googleApiKey = await resolveGooglePlacesApiKey(prisma);
  if (!googleApiKey) {
    throw new Error(
      'Google Places API key missing (GOOGLE_PLACES_API_KEY / GOOGLE_MAPS_API_KEY, apps/backend/.env, or integrations.google_places)',
    );
  }

  const cityId = await resolveCityId(CITY_SLUG);
  const rows = await loadCandidates(cityId);
  console.log(
    `Candidates: ${rows.length} listing(s) missing address and/or coordinates. ${DRY_RUN ? 'DRY_RUN' : ''}`,
  );

  let updated = 0;
  let skipped = 0;
  let failed = 0;

  for (const row of rows) {
    const missingAddress = !row.address || row.address.trim().length === 0;
    const missingLocation = !row.hasLocation;
    if (!missingAddress && !missingLocation) {
      skipped++;
      continue;
    }

    try {
      const details = await fetchGooglePlaceDetails(googleApiKey, row.sourcePlaceId);
      if (!details) {
        console.warn(`No Place Details: ${row.name ?? row.id}`);
        skipped++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      const formattedAddress = typeof details.formatted_address === 'string' ? details.formatted_address.trim() : '';
      const lat = details.geometry?.location?.lat;
      const lng = details.geometry?.location?.lng;
      const canSetAddress = missingAddress && formattedAddress.length > 0;
      const canSetLocation = missingLocation && typeof lat === 'number' && typeof lng === 'number';

      if (!canSetAddress && !canSetLocation) {
        skipped++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      if (DRY_RUN) {
        console.log(
          `[DRY_RUN] ${row.name ?? row.id}: address=${canSetAddress ? 'set' : 'skip'}, location=${canSetLocation ? 'set' : 'skip'}`,
        );
        updated++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      if (canSetAddress) {
        await prisma.listing.update({
          where: { id: row.id },
          data: { address: formattedAddress.slice(0, 500) },
        });
      }
      if (canSetLocation) {
        await prisma.$executeRaw`
          UPDATE listings
          SET location = ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)
          WHERE id = CAST(${row.id} AS uuid)
        `;
      }

      updated++;
      console.log(
        `Updated ${row.name ?? row.id}: address=${canSetAddress ? 'yes' : 'no'}, location=${canSetLocation ? 'yes' : 'no'}`,
      );
    } catch (e: any) {
      failed++;
      console.error(`Failed ${row.name ?? row.id}: ${e?.message ?? e}`);
    }

    if (DELAY_MS) await sleep(DELAY_MS);
  }

  console.log(`\nDone. updated=${updated}, skipped=${skipped}, failed=${failed}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
