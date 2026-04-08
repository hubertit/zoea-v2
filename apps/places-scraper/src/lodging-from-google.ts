/**
 * Lodging helpers: Google Place Details → room tiers, amenities, operating hours.
 *
 * Google does not return real room types or live nightly rates. We use `price_level`
 * and property signals to build indicative tiers; merchants should verify in admin.
 */

import { PrismaClient } from '@prisma/client';
import axios from 'axios';

/** Legacy Place Details field list (comma-separated). */
export const GOOGLE_PLACE_DETAILS_FIELDS = [
  'name',
  'formatted_address',
  'geometry',
  'rating',
  'user_ratings_total',
  'photos',
  'reviews',
  'website',
  'formatted_phone_number',
  'international_phone_number',
  'opening_hours',
  'editorial_summary',
  'price_level',
  'types',
  'business_status',
  'url',
  'wheelchair_accessible_entrance',
  'reservable',
  'dine_in',
  'takeout',
  'delivery',
  'serves_breakfast',
  'serves_brunch',
  'serves_lunch',
  'serves_dinner',
  'serves_beer',
  'serves_wine',
  'serves_vegetarian_food',
].join(',');

export type GooglePlaceDetails = Record<string, any>;

export async function fetchGooglePlaceDetails(
  googleApiKey: string,
  placeId: string,
): Promise<GooglePlaceDetails | null> {
  const res = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
    params: {
      place_id: placeId,
      fields: GOOGLE_PLACE_DETAILS_FIELDS,
      key: googleApiKey,
    },
  });
  const st = res.data?.status;
  if (st !== 'OK') {
    if (st === 'NOT_FOUND' || st === 'ZERO_RESULTS') return null;
    throw new Error(`Place Details ${st}: ${res.data?.error_message || ''}`);
  }
  return res.data?.result ?? null;
}

const PRICE_TIER_ROOMS: { standard: number; deluxe: number; suite: number }[] = [
  { standard: 42, deluxe: 68, suite: 95 },
  { standard: 55, deluxe: 88, suite: 120 },
  { standard: 72, deluxe: 115, suite: 155 },
  { standard: 98, deluxe: 155, suite: 210 },
  { standard: 135, deluxe: 205, suite: 290 },
];

const ROOM_DISCLAIMER =
  'Nightly rates are indicative (from Google Maps price tier), not live OTA or hotel-direct pricing — verify with the property.';

export type LodgingRoomPlan = {
  name: string;
  description: string;
  maxOccupancy: number;
  bedType: string;
  bedCount: number;
  basePrice: number;
};

export function buildLodgingRoomPlans(priceLevel: number | null | undefined): LodgingRoomPlan[] {
  const tier = Math.min(4, Math.max(0, priceLevel == null || Number.isNaN(priceLevel) ? 2 : priceLevel));
  const p = PRICE_TIER_ROOMS[tier]!;
  const rooms: LodgingRoomPlan[] = [
    {
      name: 'Standard room',
      description: `${ROOM_DISCLAIMER} Comfortable standard guest room.`,
      maxOccupancy: 2,
      bedType: 'Double',
      bedCount: 1,
      basePrice: p.standard,
    },
    {
      name: 'Deluxe room',
      description: `${ROOM_DISCLAIMER} Larger deluxe room with upgraded amenities.`,
      maxOccupancy: 2,
      bedType: 'Queen',
      bedCount: 1,
      basePrice: p.deluxe,
    },
  ];
  if (tier >= 3) {
    rooms.push({
      name: 'Executive suite',
      description: `${ROOM_DISCLAIMER} Spacious suite suitable for extended stays or small groups.`,
      maxOccupancy: 3,
      bedType: 'King',
      bedCount: 1,
      basePrice: p.suite,
    });
  }
  return rooms;
}

export function lodgingCurrency(): string {
  return (process.env.SCRAPE_LODGING_CURRENCY ?? 'USD').trim().toUpperCase() || 'USD';
}

/** Slugs we try to resolve in DB; add rows via admin/seed if you want more coverage. */
const LODGING_AMENITY_SLUG_CANDIDATES = [
  'wifi',
  'free-wifi',
  'parking',
  'parking-free',
  'air-conditioning',
  'ac',
  'tv',
  'room-service',
  'pool',
  'gym',
  'fitness',
  'spa',
  'breakfast',
  'restaurant',
  'bar',
  'laundry',
  'airport-shuttle',
  'wheelchair-accessible',
  'accessible',
  'pet-friendly',
];

export async function loadLodgingAmenitySlugMap(prisma: PrismaClient): Promise<Map<string, string>> {
  const rows = await prisma.amenity.findMany({
    where: {
      OR: [
        { slug: { in: LODGING_AMENITY_SLUG_CANDIDATES } },
        { applicable_types: { has: 'hotel' } },
      ],
    },
    select: { id: true, slug: true },
  });
  const m = new Map<string, string>();
  for (const r of rows) {
    if (r.slug) m.set(r.slug.toLowerCase(), r.id);
  }
  return m;
}

function firstSlugId(map: Map<string, string>, slugs: string[]): string | undefined {
  for (const s of slugs) {
    const id = map.get(s.toLowerCase());
    if (id) return id;
  }
  return undefined;
}

/**
 * Deterministic amenity picks from Google booleans + price tier (no randomness).
 */
export function pickLodgingAmenityIds(
  details: GooglePlaceDetails,
  slugToId: Map<string, string>,
): string[] {
  const ids = new Set<string>();
  const add = (id?: string) => {
    if (id) ids.add(id);
  };

  add(firstSlugId(slugToId, ['wifi', 'free-wifi']));
  add(firstSlugId(slugToId, ['ac', 'air-conditioning']));
  add(firstSlugId(slugToId, ['tv']));

  const pl = details.price_level;
  const tier = pl == null || Number.isNaN(pl) ? 2 : Math.min(4, Math.max(0, pl));

  if (tier >= 1) {
    add(firstSlugId(slugToId, ['parking', 'parking-free']));
  }
  if (tier >= 2) {
    add(firstSlugId(slugToId, ['gym', 'fitness']));
  }
  if (tier >= 3) {
    add(firstSlugId(slugToId, ['pool', 'spa']));
    add(firstSlugId(slugToId, ['room-service']));
  }

  if (details.wheelchair_accessible_entrance === true) {
    add(firstSlugId(slugToId, ['wheelchair-accessible', 'accessible']));
  }

  if (details.serves_breakfast === true || details.serves_brunch === true) {
    add(firstSlugId(slugToId, ['breakfast', 'restaurant']));
  }
  if (
    details.serves_lunch === true ||
    details.serves_dinner === true ||
    details.dine_in === true
  ) {
    add(firstSlugId(slugToId, ['restaurant', 'bar']));
  }

  return [...ids];
}

export function operatingHoursPayload(details: GooglePlaceDetails): object | undefined {
  const oh = details.opening_hours;
  if (!oh || typeof oh !== 'object') return undefined;
  return oh;
}

export function preferredPhone(details: GooglePlaceDetails): string | null | undefined {
  return truncateStr(details.international_phone_number, 25) ?? truncateStr(details.formatted_phone_number, 25);
}

function truncateStr(s: unknown, max: number): string | null {
  if (s == null || typeof s !== 'string') return null;
  return s.length > max ? s.substring(0, max) : s;
}
