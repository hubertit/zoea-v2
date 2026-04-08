import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { v2 as cloudinary } from 'cloudinary';
import {
  buildLodgingRoomPlans,
  fetchGooglePlaceDetails,
  lodgingCurrency,
  operatingHoursPayload,
  pickLodgingAmenityIds,
  preferredPhone,
} from './lodging-from-google';

export function truncate(input: string | null | undefined, max: number): string | null {
  if (!input) return null;
  return input.length > max ? input.substring(0, max) : input;
}

export function sanitizeReviewText(text: string | undefined | null): string {
  if (!text) return '';
  return text.trim();
}

function anonymousReviewTitle(_rating: number): string | null {
  return null;
}

export function shouldCreateHotelRooms(categorySlug: string, listingType: string): boolean {
  if (listingType === 'hotel') return true;
  return /(hotel|apartment|villa|bnb|motel|resort|accommodation|lodg)/i.test(categorySlug);
}

export type IngestContext = {
  prisma: PrismaClient;
  googleApiKey: string;
  curatedPopularityBoost: boolean;
  cloudinaryConfigured: boolean;
};

export async function uploadImage(
  ctx: IngestContext,
  photoReference: string,
  placeName: string,
): Promise<{ url: string; provider: string }> {
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photoReference}&key=${ctx.googleApiKey}`;

  if (ctx.cloudinaryConfigured) {
    try {
      const result = await cloudinary.uploader.upload(photoUrl, {
        folder: 'zoea_listings_scraped',
        public_id: `${placeName.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}_${Date.now()}`,
      });
      return { url: result.secure_url, provider: 'cloudinary' };
    } catch (e) {
      console.error(`Failed to upload ${placeName} photo to Cloudinary, using Google URL fallback.`);
      return { url: photoUrl, provider: 'google_places' };
    }
  }
  return { url: photoUrl, provider: 'google_places' };
}

export async function createSystemMerchant(prisma: PrismaClient) {
  const email = 'scraper@zoea.com';
  let user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    user = await prisma.user.create({
      data: {
        email,
        firstName: 'System',
        lastName: 'Scraper',
        username: 'system_scraper',
        roles: ['merchant'],
        accountType: 'business',
        isVerified: true,
        isActive: true,
        passwordHash: 'dummy_hash',
      },
    });
  }

  let merchant = await prisma.merchantProfile.findFirst({ where: { userId: user.id } });
  if (!merchant) {
    merchant = await prisma.merchantProfile.create({
      data: {
        userId: user.id,
        businessName: 'System Scraper',
        registrationStatus: 'approved',
        isVerified: true,
        verifiedAt: new Date(),
      },
    });
  }
  return merchant;
}

export async function ingestGooglePlaceForCategory(
  ctx: IngestContext,
  place: { place_id: string; name: string; rating?: number },
  categoryId: string,
  categorySlug: string,
  listingType: string,
  merchant: { id: string },
  city: { id: string },
  country: { id: string },
  standardAmenities: { id: string }[],
  /** When non-empty, lodging listings use Google signals + DB slugs (no random amenities). */
  lodgingAmenitySlugToId: Map<string, string>,
  seenPlaces: Set<string>,
): Promise<boolean> {
  if (seenPlaces.has(place.place_id)) return false;
  seenPlaces.add(place.place_id);

  try {
    const existingByPlace = await ctx.prisma.listing.findFirst({
      where: { sourcePlaceId: place.place_id, deletedAt: null },
    });
    if (existingByPlace) return false;

    const existingByName = await ctx.prisma.listing.findFirst({
      where: {
        cityId: city.id,
        deletedAt: null,
        name: { equals: place.name, mode: 'insensitive' },
      },
    });
    if (existingByName) return false;

    console.log(`  - Fetching details for ${place.name}...`);

    const details = await fetchGooglePlaceDetails(ctx.googleApiKey, place.place_id);
    if (!details) return false;

    const lat = details.geometry?.location?.lat;
    const lng = details.geometry?.location?.lng;
    let shortDesc = '';
    if (details.opening_hours && details.opening_hours.weekday_text) {
      shortDesc += `Open: ${details.opening_hours.weekday_text[0]}`;
    }

    const overview = details.editorial_summary?.overview || null;
    const slugBase = (details.name || place.name)
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
    const slug = truncate(`${slugBase}-${Date.now().toString(36).substring(4)}`, 120)!;

    const cur = lodgingCurrency();
    const roomPlans = shouldCreateHotelRooms(categorySlug, listingType)
      ? buildLodgingRoomPlans(details.price_level)
      : [];
    const minP = roomPlans.length ? Math.min(...roomPlans.map((r) => r.basePrice)) : null;
    const maxP = roomPlans.length ? Math.max(...roomPlans.map((r) => r.basePrice)) : null;

    const rawRating = details.rating ?? place.rating ?? 4;
    const rawTotal = details.user_ratings_total ?? 0;
    const rating = ctx.curatedPopularityBoost
      ? 5.0
      : Math.min(5, Math.max(1, Number(rawRating)));
    const reviewCount = ctx.curatedPopularityBoost
      ? rawTotal
        ? Math.max(rawTotal, 500)
        : 500
      : rawTotal;

    const oh = operatingHoursPayload(details);
    const phone = preferredPhone(details) ?? truncate(details.formatted_phone_number, 20);
    const acceptsBookings = details.reservable === true ? true : listingType === 'hotel';

    const listing = await ctx.prisma.listing.create({
      data: {
        merchantId: merchant.id,
        categoryId,
        cityId: city.id,
        countryId: country.id,
        name: truncate(details.name || place.name, 255)!,
        slug,
        sourcePlaceId: place.place_id,
        address: truncate(details.formatted_address, 500),
        contactPhone: phone,
        website: truncate(details.website, 255),
        rating,
        reviewCount,
        shortDescription: truncate(shortDesc, 255),
        description: truncate(overview, 5000),
        operatingHours: oh as any,
        minPrice: minP != null ? minP : undefined,
        maxPrice: maxP != null ? maxP : undefined,
        currency: roomPlans.length ? cur : undefined,
        priceUnit: roomPlans.length ? 'per_night' : undefined,
        acceptsBookings,
        status: 'active',
        type: listingType as any,
        isVerified: true,
      },
    });

    if (lat && lng) {
      await ctx.prisma.$executeRaw`UPDATE listings SET location = ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326) WHERE id = ${listing.id}::uuid`;
    }

    if (details.photos && details.photos.length > 0) {
      const photosToProcess = details.photos.slice(0, 5);
      for (let i = 0; i < photosToProcess.length; i++) {
        const photoInfo = await uploadImage(ctx, photosToProcess[i].photo_reference, `${place.name}_${i}`);

        const media = await ctx.prisma.media.create({
          data: {
            url: photoInfo.url,
            storageProvider: photoInfo.provider,
            mediaType: 'image',
            fileName: truncate(`${slug}-photo-${i}`, 255),
            mimeType: 'image/jpeg',
          },
        });

        await ctx.prisma.listingImage.create({
          data: {
            listingId: listing.id,
            mediaId: media.id,
            isPrimary: i === 0,
            sortOrder: i + 1,
          },
        });
      }
    }

    const attachAmenityIds = new Set<string>();
    if (shouldCreateHotelRooms(categorySlug, listingType) && lodgingAmenitySlugToId.size > 0) {
      for (const id of pickLodgingAmenityIds(details, lodgingAmenitySlugToId)) {
        attachAmenityIds.add(id);
      }
    }
    if (attachAmenityIds.size === 0 && standardAmenities.length > 0) {
      const pAttach = shouldCreateHotelRooms(categorySlug, listingType) ? 0.8 : 0.25;
      for (const amenity of standardAmenities) {
        if (Math.random() < pAttach) attachAmenityIds.add(amenity.id);
      }
    }
    for (const amenityId of attachAmenityIds) {
      await ctx.prisma.listingAmenity.create({
        data: { listingId: listing.id, amenityId },
      });
    }

    if (shouldCreateHotelRooms(categorySlug, listingType)) {
      const curRc = lodgingCurrency();
      for (const rt of roomPlans) {
        const roomType = await ctx.prisma.roomType.create({
          data: {
            listingId: listing.id,
            name: truncate(rt.name, 100)!,
            description: truncate(rt.description, 500),
            maxOccupancy: rt.maxOccupancy,
            bedType: rt.bedType,
            bedCount: rt.bedCount,
            basePrice: rt.basePrice,
            currency: curRc,
            totalRooms: 5,
            isActive: true,
            amenities: [],
            images: [],
          },
        });

        for (let r = 1; r <= 5; r++) {
          await ctx.prisma.room.create({
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

    if (details.reviews && details.reviews.length > 0) {
      const want = Math.floor(Math.random() * 6) + 5;
      const shuffled = [...details.reviews].sort(() => Math.random() - 0.5);
      const picks = shuffled.filter((r) => sanitizeReviewText(r.text)).slice(0, want);

      for (const rev of picks) {
        const content = sanitizeReviewText(rev.text);
        const randomDate = new Date();
        randomDate.setDate(randomDate.getDate() - Math.floor(Math.random() * 180));

        await ctx.prisma.review.create({
          data: {
            listingId: listing.id,
            rating: rev.rating,
            content,
            title: anonymousReviewTitle(rev.rating),
            status: 'approved' as any,
            isVerified: false,
            userId: null,
            createdAt: randomDate,
            updatedAt: randomDate,
          },
        });
      }
    }

    console.log(`    => Added ${place.name} → category ${categorySlug}`);
    return true;
  } catch (placeErr: any) {
    console.error(`    => Error processing ${place.name}:`, placeErr?.message);
    return false;
  }
}
