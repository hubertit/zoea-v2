/**
 * Backfill Google Places photos for listings with no images, then set status to active (one-by-one).
 *
 * Targets listings that are inactive (and optionally pending_review) with zero listing_images.
 * Prefer `sourcePlaceId`; optional Text Search fallback when TEXT_SEARCH_FALLBACK=1.
 *
 * Usage (from apps/places-scraper):
 *   npx ts-node src/backfill-inactive-listing-images.ts
 *   DRY_RUN=1 npx ts-node src/backfill-inactive-listing-images.ts
 *   LIMIT=20 DELAY_MS=2500 npx ts-node src/backfill-inactive-listing-images.ts
 *   INCLUDE_PENDING_REVIEW=1 TEXT_SEARCH_FALLBACK=1 npx ts-node src/backfill-inactive-listing-images.ts
 */

import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { v2 as cloudinary } from 'cloudinary';

const prisma = new PrismaClient();

const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY;
if (!GOOGLE_API_KEY) {
  console.error('Missing GOOGLE_PLACES_API_KEY');
  process.exit(1);
}

const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';
const LIMIT = process.env.LIMIT ? Math.max(1, parseInt(process.env.LIMIT, 10)) : undefined;
const DELAY_MS = Math.max(0, Number(process.env.DELAY_MS ?? 2000));
const MAX_PHOTOS = Math.max(1, Math.min(10, Number(process.env.MAX_PHOTOS ?? 5)));
const TEXT_SEARCH_FALLBACK = process.env.TEXT_SEARCH_FALLBACK === '1' || process.env.TEXT_SEARCH_FALLBACK === 'true';
const INCLUDE_PENDING_REVIEW =
  process.env.INCLUDE_PENDING_REVIEW === '1' || process.env.INCLUDE_PENDING_REVIEW === 'true';
type ListingStatusValue = 'draft' | 'pending_review' | 'active' | 'inactive' | 'suspended';
const TARGET_STATUS = (process.env.TARGET_STATUS || 'active') as ListingStatusValue;

let cloudinaryConfigured = false;

async function configureStorage() {
  if (process.env.CLOUDINARY_CLOUD_NAME) {
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
    cloudinaryConfigured = true;
    console.log('Cloudinary: from ENV');
    return;
  }
  try {
    const integration: any = await prisma.$queryRaw`SELECT config FROM integrations WHERE name = 'cloudinary' LIMIT 1`;
    if (integration?.length && integration[0].config) {
      const c = integration[0].config;
      if (c.cloudName && c.apiKey && c.apiSecret) {
        cloudinary.config({
          cloud_name: c.cloudName,
          api_key: c.apiKey,
          api_secret: c.apiSecret,
        });
        cloudinaryConfigured = true;
        console.log('Cloudinary: from DB integrations');
      }
    }
  } catch (e) {
    console.warn('Cloudinary from DB failed, using Google photo URLs only', e);
  }
}

async function uploadImage(
  photoReference: string,
  placeName: string,
): Promise<{ url: string; provider: string }> {
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photoReference}&key=${GOOGLE_API_KEY}`;
  if (cloudinaryConfigured) {
    try {
      const result = await cloudinary.uploader.upload(photoUrl, {
        folder: 'zoea_listings_scraped',
        public_id: `${placeName.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}_${Date.now()}`,
      });
      return { url: result.secure_url, provider: 'cloudinary' };
    } catch {
      console.warn('Cloudinary upload failed, keeping Google URL');
      return { url: photoUrl, provider: 'google_places' };
    }
  }
  return { url: photoUrl, provider: 'google_places' };
}

async function fetchPlaceDetails(placeId: string): Promise<{ photos: { photo_reference: string }[] } | null> {
  const detailsRes = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
    params: {
      place_id: placeId,
      fields: 'photos,name',
      key: GOOGLE_API_KEY,
    },
  });
  const details = detailsRes.data?.result;
  if (!details) return null;
  return { photos: details.photos || [] };
}

async function resolvePlaceId(listing: {
  id: string;
  name: string;
  sourcePlaceId: string | null;
  address: string | null;
  city: { name: string } | null;
  country: { name: string } | null;
}): Promise<string | null> {
  if (listing.sourcePlaceId) return listing.sourcePlaceId;
  if (!TEXT_SEARCH_FALLBACK) return null;

  const parts = [listing.name, listing.address, listing.city?.name, listing.country?.name].filter(Boolean);
  const query = parts.join(' ');
  if (!query.trim()) return null;

  const searchRes = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
    params: { query, key: GOOGLE_API_KEY },
  });
  if (searchRes.data.status !== 'OK' || !searchRes.data.results?.length) return null;

  // Guardrail: only accept a text-search hit if it reasonably matches the listing name.
  // This avoids many different "Venue 7xx" rows mapping to the same top Google result.
  const top = searchRes.data.results[0];
  const topName = String(top?.name || '').trim();
  const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9]+/g, '');
  const a = norm(listing.name);
  const b = norm(topName);
  const looksLikeMatch = a.length >= 4 && b.length >= 4 && (a.includes(b) || b.includes(a));
  if (!looksLikeMatch) return null;

  return top.place_id as string;
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

async function main() {
  console.log(
    `backfill-inactive-listing-images DRY_RUN=${DRY_RUN} LIMIT=${LIMIT ?? '∞'} DELAY_MS=${DELAY_MS} MAX_PHOTOS=${MAX_PHOTOS} TEXT_SEARCH_FALLBACK=${TEXT_SEARCH_FALLBACK} INCLUDE_PENDING_REVIEW=${INCLUDE_PENDING_REVIEW} TARGET_STATUS=${TARGET_STATUS}`,
  );

  await configureStorage();

  const statusFilter: ListingStatusValue[] = INCLUDE_PENDING_REVIEW
    ? ['inactive', 'pending_review']
    : ['inactive'];

  const listings = await prisma.listing.findMany({
    where: {
      status: { in: statusFilter },
      deletedAt: null,
      images: { none: {} },
    },
    select: {
      id: true,
      name: true,
      slug: true,
      sourcePlaceId: true,
      address: true,
      status: true,
      city: { select: { name: true } },
      country: { select: { name: true } },
    },
    orderBy: { updatedAt: 'asc' },
    ...(LIMIT ? { take: LIMIT } : {}),
  });

  console.log(`\nFound ${listings.length} listing(s) with no images (status in ${statusFilter.join(', ')}).\n`);

  let ok = 0;
  let skipped = 0;
  let failed = 0;

  for (const listing of listings) {
    const label = `"${listing.name}" (${listing.id})`;
    try {
      const placeId = await resolvePlaceId(listing);
      if (!placeId) {
        console.log(`SKIP ${label} — no sourcePlaceId${TEXT_SEARCH_FALLBACK ? ' and text search found nothing' : ' (set TEXT_SEARCH_FALLBACK=1 to try Google Text Search)'}`);
        skipped++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      if (DRY_RUN) {
        const details = await fetchPlaceDetails(placeId);
        const n = details?.photos?.length ?? 0;
        console.log(`DRY_RUN ${label} placeId=${placeId} photos=${n} would set status=${TARGET_STATUS}`);
        if (n === 0) skipped++;
        else ok++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      const details = await fetchPlaceDetails(placeId);
      const photos = details?.photos ?? [];
      if (photos.length === 0) {
        console.log(`SKIP ${label} — Place Details has no photos`);
        skipped++;
        if (DELAY_MS) await sleep(DELAY_MS);
        continue;
      }

      const slugSafe = (listing.slug || listing.name).toLowerCase().replace(/[^a-z0-9]+/g, '-').slice(0, 80);
      const toProcess = photos.slice(0, MAX_PHOTOS);

      for (let i = 0; i < toProcess.length; i++) {
        const photoInfo = await uploadImage(toProcess[i].photo_reference, `${listing.name}_${i}`);
        const media = await prisma.media.create({
          data: {
            url: photoInfo.url.slice(0, 500),
            storageProvider: photoInfo.provider,
            mediaType: 'image',
            fileName: `${slugSafe}-photo-${i}`,
            mimeType: 'image/jpeg',
          },
        });
        await prisma.listingImage.create({
          data: {
            listingId: listing.id,
            mediaId: media.id,
            isPrimary: i === 0,
            sortOrder: i + 1,
          },
        });
      }

      await prisma.listing.update({
        where: { id: listing.id },
        data: {
          status: TARGET_STATUS,
        },
      });

      console.log(`OK ${label} — ${toProcess.length} image(s), status → ${TARGET_STATUS}`);
      ok++;
    } catch (e: any) {
      console.error(`FAIL ${label}`, e?.message || e);
      failed++;
    }

    if (DELAY_MS) await sleep(DELAY_MS);
  }

  console.log(`\nDone. ok=${ok} skipped=${skipped} failed=${failed}`);
  process.exit(failed > 0 ? 1 : 0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
