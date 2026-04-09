/**
 * Backfill `source_place_id` for existing listings that are missing it.
 *
 * Matching strategy:
 *  - Google Places Text Search with multiple queries per listing
 *  - pick best candidate by token overlap against listing name
 *  - skip low-confidence matches unless FORCE=1
 *
 * From apps/places-scraper:
 *   npx ts-node src/backfill-listing-source-place-id.ts
 *   DRY_RUN=1 LIMIT=50 npx ts-node src/backfill-listing-source-place-id.ts
 *
 * Env:
 *   DRY_RUN=1
 *   LIMIT=200
 *   DELAY_MS=1200
 *   CITY_SLUG=kigali    (optional)
 *   MIN_SCORE=0.6       (0..1, default 0.6)
 *   FORCE=1             (allow low-score updates)
 */

import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { loadPlacesScraperEnvFromFiles, resolveGooglePlacesApiKey } from './resolve-google-places-key';

const prisma = new PrismaClient();

const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';
const FORCE = process.env.FORCE === '1' || process.env.FORCE === 'true';
const LIMIT = process.env.LIMIT ? Math.max(1, parseInt(process.env.LIMIT, 10)) : 200;
const DELAY_MS = Math.max(0, Number(process.env.DELAY_MS ?? 1200));
const CITY_SLUG = (process.env.CITY_SLUG ?? '').trim();
const MIN_SCORE = Math.max(0, Math.min(1, Number(process.env.MIN_SCORE ?? 0.6)));

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

type CandidateListing = {
  id: string;
  name: string | null;
  address: string | null;
  cityName: string | null;
  countryName: string | null;
};

type SearchResult = {
  place_id: string;
  name: string;
  formatted_address?: string;
};

function normalize(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9\s]/g, ' ').replace(/\s+/g, ' ').trim();
}

function tokenSet(s: string): Set<string> {
  return new Set(
    normalize(s)
      .split(' ')
      .map((t) => t.trim())
      .filter((t) => t.length >= 2),
  );
}

function overlapScore(a: string, b: string): number {
  const aa = tokenSet(a);
  const bb = tokenSet(b);
  if (aa.size === 0 || bb.size === 0) return 0;
  let common = 0;
  for (const t of aa) {
    if (bb.has(t)) common++;
  }
  return common / aa.size;
}

function buildQueries(row: CandidateListing): string[] {
  const n = (row.name ?? '').trim();
  const c = (row.cityName ?? '').trim();
  const k = (row.countryName ?? '').trim();
  const a = (row.address ?? '').trim();
  const q = [
    `${n} ${c} ${k}`.trim(),
    `${n} ${c}`.trim(),
    `${n} ${a}`.trim(),
    n,
  ];
  return q.filter((x, i, all) => x.length > 0 && all.indexOf(x) === i);
}

async function textSearchTopCandidates(
  apiKey: string,
  query: string,
  cityName?: string | null,
): Promise<SearchResult[]> {
  const localizedQuery = cityName?.trim() ? `${query} near ${cityName}` : query;
  const res = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
    params: { query: localizedQuery, key: apiKey },
  });
  const status = res.data?.status;
  if (status !== 'OK' && status !== 'ZERO_RESULTS') {
    console.warn(`Text Search ${status}: ${res.data?.error_message || ''}`);
    return [];
  }
  const rows = (res.data?.results ?? []) as SearchResult[];
  return rows.slice(0, 5);
}

async function resolveCityId(slug: string): Promise<string | undefined> {
  if (!slug) return undefined;
  const city = await prisma.city.findFirst({
    where: { slug, isActive: true },
    select: { id: true },
  });
  if (!city) throw new Error(`City not found for slug "${slug}"`);
  return city.id;
}

async function loadTargets(cityId?: string): Promise<CandidateListing[]> {
  if (cityId) {
    return prisma.$queryRaw<CandidateListing[]>`
      SELECT
        l.id::text AS id,
        l.name,
        l.address,
        ci.name AS "cityName",
        co.name AS "countryName"
      FROM listings l
      LEFT JOIN cities ci ON ci.id = l.city_id
      LEFT JOIN countries co ON co.id = l.country_id
      WHERE l.deleted_at IS NULL
        AND l.source_place_id IS NULL
        AND l.city_id = CAST(${cityId} AS uuid)
      ORDER BY l.updated_at ASC
      LIMIT ${LIMIT}
    `;
  }
  return prisma.$queryRaw<CandidateListing[]>`
    SELECT
      l.id::text AS id,
      l.name,
      l.address,
      ci.name AS "cityName",
      co.name AS "countryName"
    FROM listings l
    LEFT JOIN cities ci ON ci.id = l.city_id
    LEFT JOIN countries co ON co.id = l.country_id
    WHERE l.deleted_at IS NULL
      AND l.source_place_id IS NULL
    ORDER BY l.updated_at ASC
    LIMIT ${LIMIT}
  `;
}

async function main(): Promise<void> {
  loadPlacesScraperEnvFromFiles();
  if (!process.env.DATABASE_URL) throw new Error('DATABASE_URL missing');

  const googleApiKey = await resolveGooglePlacesApiKey(prisma);
  if (!googleApiKey) {
    throw new Error(
      'Google Places API key missing (GOOGLE_PLACES_API_KEY / GOOGLE_MAPS_API_KEY, apps/backend/.env, or integrations.google_places)',
    );
  }

  const cityId = await resolveCityId(CITY_SLUG);
  const rows = await loadTargets(cityId);
  console.log(
    `Candidates: ${rows.length} listing(s) missing source_place_id. ${DRY_RUN ? 'DRY_RUN' : ''} MIN_SCORE=${MIN_SCORE}${FORCE ? ' FORCE' : ''}`,
  );

  let updated = 0;
  let skipped = 0;
  let lowConfidence = 0;
  let conflicts = 0;
  let failed = 0;

  for (const row of rows) {
    const listingName = (row.name ?? '').trim();
    if (!listingName) {
      skipped++;
      continue;
    }

    try {
      const queries = buildQueries(row);
      let best: { placeId: string; placeName: string; score: number; via: string } | null = null;

      for (const q of queries) {
        const candidates = await textSearchTopCandidates(googleApiKey, q, row.cityName);
        for (const c of candidates) {
          if (!c.place_id || !c.name) continue;
          const score = overlapScore(listingName, c.name);
          if (!best || score > best.score) {
            best = {
              placeId: c.place_id,
              placeName: c.name,
              score,
              via: q,
            };
          }
        }
        if (best && best.score >= 0.95) break;
      }

      if (!best) {
        skipped++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      if (best.score < MIN_SCORE && !FORCE) {
        lowConfidence++;
        console.log(
          `LOW_CONFIDENCE ${listingName}: best="${best.placeName}" score=${best.score.toFixed(2)} via="${best.via}"`,
        );
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      const existing = await prisma.listing.findFirst({
        where: { sourcePlaceId: best.placeId, deletedAt: null },
        select: { id: true, name: true },
      });
      if (existing && existing.id !== row.id) {
        conflicts++;
        console.warn(
          `CONFLICT ${listingName}: place_id already used by "${existing.name ?? existing.id}" (${best.placeId})`,
        );
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      if (DRY_RUN) {
        console.log(
          `[DRY_RUN] ${listingName}: sourcePlaceId=${best.placeId} (match="${best.placeName}", score=${best.score.toFixed(2)})`,
        );
        updated++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      await prisma.listing.update({
        where: { id: row.id },
        data: { sourcePlaceId: best.placeId },
      });
      updated++;
      console.log(
        `Updated ${listingName}: sourcePlaceId=${best.placeId} (match="${best.placeName}", score=${best.score.toFixed(2)})`,
      );
    } catch (e: any) {
      failed++;
      console.error(`Failed ${listingName || row.id}: ${e?.message ?? e}`);
    }

    if (DELAY_MS) await sleep(DELAY_MS);
  }

  console.log(
    `\nDone. updated=${updated}, skipped=${skipped}, low_confidence=${lowConfidence}, conflicts=${conflicts}, failed=${failed}`,
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
