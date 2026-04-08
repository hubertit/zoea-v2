import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { v2 as cloudinary } from 'cloudinary';
import { applyScrapeTaskIfSet, formatTasksHelp } from './scrape-task-presets';

const prisma = new PrismaClient();

const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

if ((process.env.SCRAPE_TASK ?? '').trim() === 'list-tasks') {
  console.log(formatTasksHelp());
  process.exit(0);
}

applyScrapeTaskIfSet();

let cloudinaryConfigured = false;

async function configureStorage() {
  if (process.env.CLOUDINARY_CLOUD_NAME) {
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
    cloudinaryConfigured = true;
    console.log('Using Cloudinary configured from ENV');
    return;
  }

  try {
    const integration: any = await prisma.$queryRaw`SELECT config FROM integrations WHERE name = 'cloudinary' LIMIT 1`;
    if (integration && integration.length > 0 && integration[0].config) {
      const config = integration[0].config;
      if (config.cloudName && config.apiKey && config.apiSecret) {
        cloudinary.config({
          cloud_name: config.cloudName,
          api_key: config.apiKey,
          api_secret: config.apiSecret,
        });
        cloudinaryConfigured = true;
        console.log('Using Cloudinary configured from DB integrations table');
      }
    }
  } catch (err) {
    console.warn('Could not load Cloudinary from DB:', err);
  }
}

const TARGET_CITY_NAME = (process.env.TARGET_CITY_NAME ?? 'Kigali').trim();
const COUNTRY_NAME = (process.env.COUNTRY_NAME ?? 'Rwanda').trim();
const TARGET_CITY_ALIASES = (process.env.TARGET_CITY_ALIASES ?? '')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);
const CURATED_POPULARITY_BOOST = process.env.SCRAPE_CURATED_BOOST === '1';
/** Prefer `SCRAPE_CATEGORY_SLUG`; `SCRAPE_ROOT_SLUG` kept for backward compatibility. Set at runtime in `scrape()`. */
let EFFECTIVE_CATEGORY_SLUG = '';
/** Resolved from DB in `scrape()` (drives Text Search locality). */
let RESOLVED_CITY_NAME = TARGET_CITY_NAME;
let RESOLVED_COUNTRY_NAME = COUNTRY_NAME;

function leafGoal(): number {
  return Number(process.env.LEAF_GOAL_LISTINGS ?? 8);
}

function legacyScrape(): boolean {
  return process.env.LEGACY_SCRAPE === '1';
}

function textSearchMaxPages(): number {
  return Math.max(1, Math.min(10, Number(process.env.TEXT_SEARCH_MAX_PAGES ?? 3)));
}

function sanitizeReviewText(text: string | undefined | null): string {
  if (!text) return '';
  return text.trim();
}

function truncate(input: string | null | undefined, max: number): string | null {
  if (!input) return null;
  return input.length > max ? input.substring(0, max) : input;
}

function anonymousReviewTitle(_rating: number): string | null {
  return null;
}

/** Parents with no active children: create sensible leaves for scraping. */
const STRUCTURAL_PARENTS: {
  slug: string;
  children: { name: string; slug: string; sortOrder: number }[];
}[] = [
  {
    slug: 'transport',
    children: [
      { name: 'Airport shuttles', slug: 'transport-airport-shuttles', sortOrder: 1 },
      { name: 'Car hire', slug: 'transport-car-hire', sortOrder: 2 },
      { name: 'Bus & coaches', slug: 'transport-bus-coaches', sortOrder: 3 },
      { name: 'Moto & taxi', slug: 'transport-moto-taxi', sortOrder: 4 },
    ],
  },
  {
    slug: 'events',
    children: [
      { name: 'Event & conference venues', slug: 'events-venues', sortOrder: 1 },
      { name: 'Wedding venues', slug: 'events-wedding-venues', sortOrder: 2 },
    ],
  },
  {
    slug: 'real-estate',
    children: [
      { name: 'Rentals', slug: 'real-estate-rentals', sortOrder: 1 },
      { name: 'Property sales', slug: 'real-estate-sales', sortOrder: 2 },
    ],
  },
];

/** Extra Google Text Search seeds (Kigali, well-known). Fallback: category name + Kigali. */
const SLUG_QUERY_OVERRIDES: Record<string, string[]> = {
  italian: [
    'Sole Luna Kigali',
    'Filini Restaurant Kigali',
    'Brachetto Kigali',
    'La Dolce Vita Kigali',
    'Italian restaurant Kigali',
  ],
  chinese: [
    'Great Wall Chinese Restaurant Kigali',
    'Nihao Restaurant Kigali',
    'Chinese restaurant Kimihurura',
    'Chinese restaurant Kigali',
  ],
  indian: [
    'Zaaffran Restaurant Kigali',
    'Khana Khazana Kigali',
    'Blue Spice Kigali',
    'Indian restaurant Kigali',
  ],
  continental: [
    'Poivre Noir Kigali',
    'The Hut Restaurant Kigali',
    'Continental restaurant Kigali',
    'Fine dining Kigali',
  ],
  'fine-dining': [
    'Heaven Restaurant Kigali',
    'Fusion Bar and Grill Kigali',
    'Radisson Blu Kigali restaurant',
    'Marriott Kigali restaurant',
    'Hotel des Mille Collines restaurant',
    'fine dining Kigali',
  ],
  'casual-dining': [
    'Cultiva Farm Kigali',
    'Meze Fresh Kigali',
    'Kisimenti restaurants Kigali',
    'Brochettes Kigali',
    'local restaurant Kigali Kimihurura',
    'Nyamirambo food Kigali',
  ],
  'vegan-vegetarian': [
    'Meze Fresh Kigali',
    'Plant vegan Kigali',
    'vegan restaurant Kigali',
    'vegetarian food Kigali',
  ],
  halal: ['halal restaurant Kigali', 'Habesha Restaurant Kigali', 'halal food Nyamirambo'],
  'kids-friendly': [
    'Kisimenti family restaurant Kigali',
    'pizza Kigali',
    'burger Kigali',
    'family restaurant Kigali',
  ],
  'outdoor-seating': [
    'Pili Pili Kigali',
    'rooftop restaurant Kigali',
    'terrace dining Kigali',
    'garden restaurant Kigali',
  ],
  'take-a-coffee': [
    'Question Coffee Kigali',
    'Bourbon Coffee Kigali',
    'Brioche Kigali',
    'Shokola Kigali',
    'Inzora Rooftop Cafe',
    'cafe Kigali',
  ],
  african: ['Afrika Bite Kigali', 'Rwandan restaurant Kigali', 'African cuisine Kigali'],
  'local-cuisine': ['Brochettes Kigali', 'Rwandan food Kigali', 'Ugali buffet Kigali'],
  ethiopian: ['Addis Ethiopian Kigali', 'Ethiopian restaurant Kigali'],
  lebanese: ['Lebanese restaurant Kigali', 'shawarma Kigali'],
  japanese: ['Sakura Restaurant Kigali', 'Soy Asian Table Kigali', 'Japanese restaurant Kigali'],
  thai: ['Thai restaurant Kigali', 'Asian fusion Kigali'],
  french: ['French restaurant Kigali', 'bistro Kigali'],
  mexican: ['Mexican restaurant Kigali', 'taco Kigali'],
  seafood: ['fish restaurant Kigali', 'seafood Kigali'],
  steakhouse: ['Inka Steakhouse Kigali', 'steak restaurant Kigali'],
  pizza: ['Mr Chips Kigali', 'pizzeria Kigali', 'pizza Kigali'],
  bakery: ['boulangerie Kigali', 'bakery Kigali'],
  brunch: ['brunch Kigali', 'breakfast Kigali'],
  'fast-food': ['fried chicken Kigali', 'burger Kigali', 'fast food Kigali'],
  'street-food': ['street food Nyamirambo', 'food stall Kigali'],
  bbq: ['barbecue Kigali', 'grill restaurant Kigali'],
  dessert: ['ice cream Kigali', 'dessert cafe Kigali'],
  monuments: ['Kigali monuments', 'ND\'Ese Ruganwa II monument Kigali'],
  'statues-memorials': ['statues Kigali', 'memorial Kigali'],
  museums: ['Kigali Genocide Memorial', 'Rwanda Art Museum Kigali', 'Kandt House Museum Kigali'],
  'historical-sites': ['historical sites Kigali', 'Nyamata memorial'],
  viewpoints: ['Mount Kigali viewpoint', 'Kigali viewpoint'],
  'architectural-sites': ['modern architecture Kigali', 'Convention Centre Kigali'],
  '0': ['architecture Kigali', 'Kigali Convention Centre'],
  'natural-landmarks': ['Nyandungu Eco-Park', 'Mount Kigali'],
  'golf-courses': ['Kigali Golf Resort', 'golf course Kigali'],
  'wine-bars': ['wine bar Kigali'],
  'sports-bars': ['sports bar Kigali'],
  'cocktail-bars': ['cocktail bar Kigali'],
  'rooftop-bars': ['rooftop bar Kigali', 'Pili Pili Kigali'],
  banks: ['Bank of Kigali', 'Equity Bank Kigali', 'I&M Bank Rwanda Kigali'],
  atms: ['ATM Kigali', 'Bank of Kigali ATM'],
  'insurance-companies': ['insurance company Kigali', 'SONARWA Kigali'],
  helplines: ['ambulance Rwanda', 'police emergency Kigali'],
  'fire-stations': ['fire station Kigali'],
  'police-stations': ['police station Kigali'],
  'medical-services': ['King Faisal Hospital Kigali', 'CHUK Kigali'],
  telecoms: ['MTN Centre Kigali', 'Airtel shop Kigali'],
  'public-offices': ['Kigali City Hall', 'Rwanda Development Board Kigali'],
  'judicial-institutions': ['Supreme Court Rwanda Kigali', 'court Kigali'],
  mosques: ['mosque Kigali', 'Nyamirambo mosque'],
  temples: ['Hindu temple Kigali'],
  synagogues: ['synagogue East Africa'],
  'towing-truck': ['car towing Kigali', 'roadside assistance Kigali'],
  'tire-services': ['tyre shop Kigali', 'tire repair Kigali'],
  'jump-start': ['battery jump start Kigali'],
  lockout: ['car locksmith Kigali'],
  'minor-repairs': ['car repair Kigali'],
  'emergency-roadside': ['24 hour roadside assistance Kigali'],
  'fuel-delivery': ['fuel delivery Kigali'],
  'carfree-zone': ['car free zone Kigali'],
  pharmacies: ['pharmacy Kigali', 'Uber Pharmacy Kigali'],
  'beauty-salon': ['beauty salon Kigali', 'spa Kigali'],
  'government-institutions': ['government office Kigali'],
  ministries: ['ministry Kigali Rwanda'],
  'embassies-and-consulates': ['embassy Kigali'],
  'cultural-landmarks': ['cultural landmark Kigali', 'Inema Arts Center'],
  hiking: ['Mount Kigali hike', 'Fazenda Sengha'],
  'tour-and-travel': ['Kigali city tour operator', 'gorilla trekking office Kigali'],
  cinema: ['Century Cinema Kigali', 'Canal Olympia Kigali'],
  clubs: ['Voltage Club Kigali', 'Cadillac Club Kigali'],
  bars: ['Pili Pili Bar Kigali', 'Choma\'d Kigali'],
  lounges: ['Repub Lounge Kigali'],
  'transport-airport-shuttles': ['Kigali airport shuttle', 'airport transfer Kigali'],
  'transport-car-hire': ['car rental Kigali', 'self drive Kigali'],
  'transport-bus-coaches': ['bus station Kigali Nyabugogo', 'RITCO bus Kigali'],
  'transport-moto-taxi': ['moto taxi Kigali', 'Yego Moto Kigali'],
  'events-venues': ['conference venue Kigali', 'Radisson Blu Kigali events'],
  'events-wedding-venues': ['wedding venue Kigali'],
  'real-estate-rentals': ['apartment rent Kigali', 'house rent Kigali'],
  'real-estate-sales': ['real estate agent Kigali', 'property sales Kigali'],
};

function inferListingType(slug: string, name: string): string {
  const s = `${slug} ${name}`.toLowerCase();
  if (/\b(fast\s*food|burger|fried chicken)\b|fast-food/.test(s)) return 'fast_food';
  if (/\b(cafe|coffee|espresso)\b/.test(s)) return 'cafe';
  if (/\b(bar|pub|wine bar|cocktail|rooftop bar|sports bar)\b/.test(s)) return 'bar';
  if (/\b(club|nightclub|disco)\b/.test(s)) return 'club';
  if (/\b(lounge)\b/.test(s)) return 'lounge';
  if (/\b(mall|shopping centre|shopping center)\b/.test(s)) return 'mall';
  if (/\b(market)\b/.test(s)) return 'market';
  if (/\b(boutique)\b/.test(s)) return 'boutique';
  if (/\b(hotel|resort|motel|hostel|lodg)\b/.test(s)) return 'hotel';
  if (/\b(tour operator|safari|trekking|city tour company|travel agency)\b/.test(s)) return 'tour';
  if (/\brestaurant|cuisine|dining|grill|kitchen|food hall|bistro\b/.test(s)) return 'restaurant';
  return 'attraction';
}

function localizeSeedQuery(query: string): string {
  // Reuse curated seeds by swapping Kigali references with target city.
  return query.replace(/\bKigali\b/gi, RESOLVED_CITY_NAME);
}

function buildQueriesForLeaf(slug: string, name: string): string[] {
  const extra = (SLUG_QUERY_OVERRIDES[slug] ?? []).map(localizeSeedQuery);
  const human = name.replace(/\s*&\s*/g, ' ').trim();
  const cityTerms = [RESOLVED_CITY_NAME, ...TARGET_CITY_ALIASES];
  const base = [
    ...cityTerms.flatMap((city) => [
      `${human} ${city} ${RESOLVED_COUNTRY_NAME}`,
      `${human} ${city}`,
      `${slug.replace(/-/g, ' ')} ${city} ${RESOLVED_COUNTRY_NAME}`,
    ]),
    `${human} ${RESOLVED_COUNTRY_NAME}`,
    `${slug.replace(/-/g, ' ')} ${RESOLVED_COUNTRY_NAME}`,
  ];
  return [...extra, ...base].filter((q, i, a) => a.indexOf(q) === i);
}

function shouldCreateHotelRooms(categorySlug: string, listingType: string): boolean {
  if (listingType === 'hotel') return true;
  return /(hotel|apartment|villa|bnb|motel|resort|accommodation|lodg)/i.test(categorySlug);
}

async function ensureStructuralChildCategories(): Promise<void> {
  for (const block of STRUCTURAL_PARENTS) {
    const parent = await prisma.category.findUnique({ where: { slug: block.slug } });
    if (!parent?.id) {
      console.warn(`Structural parent not found: ${block.slug}`);
      continue;
    }
    const n = await prisma.category.count({ where: { parentId: parent.id, isActive: true } });
    if (n > 0) continue;

    console.log(`Adding default children under "${parent.name}" (${block.slug})...`);
    for (const ch of block.children) {
      const exists = await prisma.category.findUnique({ where: { slug: ch.slug } });
      if (exists) continue;
      await prisma.category.create({
        data: {
          name: ch.name,
          slug: ch.slug,
          parentId: parent.id,
          sortOrder: ch.sortOrder,
          isActive: true,
        },
      });
      console.log(`  + ${ch.name} (${ch.slug})`);
    }
  }
}

const CATEGORIES_TO_SCRAPE = [
  {
    slug: 'clubs',
    queries: [
      'Cadillac Night Club Kigali', 'Voltage Club Kigali', 'Envy Club Kigali',
      'Cocobean Kigali', 'Papyrus Kigali', 'Shooters Lounge Kigali',
      'Blackout Club Kigali',
    ],
    type: 'club',
  },
  {
    slug: 'bars',
    queries: [
      'Pillar Bar Kigali', "Choma'd Kigali", 'Tropicana Lounge Kigali',
      'Le Must Kigali', 'New Cadillac Club Kigali',
    ],
    type: 'bar',
  },
  {
    slug: 'lounges',
    queries: [
      'Repub Lounge Kigali', 'Chillax Lounge Kigali', 'La Noche Kigali',
      'Bicu Lounge Kigali', 'Rosty Club Kigali', 'Riders Lounge Kigali',
    ],
    type: 'lounge',
  },
  {
    slug: 'cultural',
    queries: [
      'Kigali Genocide Memorial', 'Inema Arts Center Kigali', 'Niyo Art Gallery Kigali',
      "Nyamirambo Women's Center", 'Rwanda Art Museum',
    ],
    type: 'tour',
  },
  {
    slug: 'hiking',
    queries: ['Mount Kigali', 'Fazenda Sengha Kigali', 'Nyandungu Eco-Park Kigali'],
    type: 'tour',
  },
  {
    slug: 'tour-and-travel',
    queries: [
      'Kigali City Tour', 'Gorilla Trekking Rwanda', 'Akagera National Park',
      'Nyungwe Forest Canopy Walk',
    ],
    type: 'tour',
  },
  {
    slug: 'cinema',
    queries: ['Century Cinema Kigali', 'Canal Olympia Kigali'],
    type: 'attraction',
  },
];

async function uploadImage(
  photoReference: string,
  placeName: string
): Promise<{ url: string; provider: string }> {
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photoReference}&key=${GOOGLE_API_KEY}`;

  if (cloudinaryConfigured) {
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

async function createSystemMerchant() {
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

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function ingestGooglePlaceForCategory(
  place: { place_id: string; name: string; rating?: number },
  categoryId: string,
  categorySlug: string,
  listingType: string,
  merchant: { id: string },
  city: { id: string },
  country: { id: string },
  standardAmenities: { id: string }[],
  seenPlaces: Set<string>
): Promise<boolean> {
  if (seenPlaces.has(place.place_id)) return false;
  seenPlaces.add(place.place_id);

  try {
    const existingByPlace = await prisma.listing.findFirst({
      where: { sourcePlaceId: place.place_id, deletedAt: null },
    });
    if (existingByPlace) return false;

    const existingByName = await prisma.listing.findFirst({
      where: {
        cityId: city.id,
        deletedAt: null,
        name: { equals: place.name, mode: 'insensitive' },
      },
    });
    if (existingByName) return false;

    console.log(`  - Fetching details for ${place.name}...`);

    const detailsRes = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
      params: {
        place_id: place.place_id,
        fields:
          'name,formatted_address,geometry,rating,user_ratings_total,photos,reviews,website,formatted_phone_number,opening_hours,editorial_summary',
        key: GOOGLE_API_KEY,
      },
    });

    const details = detailsRes.data.result;
    if (!details) return false;

    const lat = details.geometry?.location?.lat;
    const lng = details.geometry?.location?.lng;
    let shortDesc = '';
    if (details.opening_hours && details.opening_hours.weekday_text) {
      shortDesc += `Open: ${details.opening_hours.weekday_text[0]}`;
    }

    const overview = details.editorial_summary?.overview || null;
    const slugBase = (details.name || place.name).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
    const slug = truncate(`${slugBase}-${Date.now().toString(36).substring(4)}`, 120)!;

    const rawRating = details.rating ?? place.rating ?? 4;
    const rawTotal = details.user_ratings_total ?? 0;
    const rating = CURATED_POPULARITY_BOOST
      ? 5.0
      : Math.min(5, Math.max(1, Number(rawRating)));
    const reviewCount = CURATED_POPULARITY_BOOST
      ? rawTotal
        ? Math.max(rawTotal, 500)
        : 500
      : rawTotal;

    const listing = await prisma.listing.create({
      data: {
        merchantId: merchant.id,
        categoryId,
        cityId: city.id,
        countryId: country.id,
        name: truncate(details.name || place.name, 255)!,
        slug,
        sourcePlaceId: place.place_id,
        address: truncate(details.formatted_address, 500),
        contactPhone: truncate(details.formatted_phone_number, 20),
        website: truncate(details.website, 255),
        rating,
        reviewCount,
        shortDescription: truncate(shortDesc, 255),
        description: truncate(overview, 5000),
        status: 'active',
        type: listingType as any,
        isVerified: true,
      },
    });

    if (lat && lng) {
      await prisma.$executeRaw`UPDATE listings SET location = ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326) WHERE id = ${listing.id}::uuid`;
    }

    if (details.photos && details.photos.length > 0) {
      const photosToProcess = details.photos.slice(0, 5);
      for (let i = 0; i < photosToProcess.length; i++) {
        const photoInfo = await uploadImage(photosToProcess[i].photo_reference, `${place.name}_${i}`);

        const media = await prisma.media.create({
          data: {
            url: photoInfo.url,
            storageProvider: photoInfo.provider,
            mediaType: 'image',
            fileName: truncate(`${slug}-photo-${i}`, 255),
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
    }

    if (standardAmenities.length > 0) {
      const pAttach = shouldCreateHotelRooms(categorySlug, listingType) ? 0.8 : 0.25;
      for (const amenity of standardAmenities) {
        if (Math.random() < pAttach) {
          await prisma.listingAmenity.create({
            data: { listingId: listing.id, amenityId: amenity.id },
          });
        }
      }
    }

    if (shouldCreateHotelRooms(categorySlug, listingType)) {
      const roomTypes = [
        { name: 'Standard Double Room', price: 80 },
        { name: 'Deluxe Suite', price: 150 },
      ];

      for (const rt of roomTypes) {
        const roomType = await prisma.roomType.create({
          data: {
            listingId: listing.id,
            name: rt.name,
            description: `A comfortable ${rt.name.toLowerCase()}.`,
            maxOccupancy: 2,
            bedType: 'Double',
            bedCount: 1,
            basePrice: rt.price,
            currency: 'USD',
            totalRooms: 5,
            isActive: true,
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

    if (details.reviews && details.reviews.length > 0) {
      const want = Math.floor(Math.random() * 6) + 5;
      const shuffled = [...details.reviews].sort(() => Math.random() - 0.5);
      const picks = shuffled.filter((r) => sanitizeReviewText(r.text)).slice(0, want);

      for (const rev of picks) {
        const content = sanitizeReviewText(rev.text);
        const randomDate = new Date();
        randomDate.setDate(randomDate.getDate() - Math.floor(Math.random() * 180));

        await prisma.review.create({
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

async function countActiveListingsForCategory(categoryId: string): Promise<number> {
  return prisma.listing.count({
    where: { categoryId, status: 'active', deletedAt: null },
  });
}

type LeafRow = { id: string; slug: string; name: string; cnt: bigint };

async function fetchLeavesBelowGoal(): Promise<LeafRow[]> {
  if (!EFFECTIVE_CATEGORY_SLUG) {
    return prisma.$queryRaw<LeafRow[]>`
      SELECT c.id, c.slug, c.name,
        COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL)::bigint AS cnt
      FROM categories c
      LEFT JOIN listings l ON l.category_id = c.id
      WHERE c.is_active = true
        AND NOT EXISTS (
          SELECT 1 FROM categories ch
          WHERE ch.parent_id = c.id AND ch.is_active = true
        )
      GROUP BY c.id, c.slug, c.name
      HAVING COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL) < ${leafGoal()}
      ORDER BY cnt ASC, c.name ASC
    `;
  }

  const cat = await prisma.category.findFirst({
    where: { slug: EFFECTIVE_CATEGORY_SLUG, isActive: true },
  });
  if (!cat) {
    console.error(`SCRAPE_CATEGORY_SLUG / SCRAPE_ROOT_SLUG="${EFFECTIVE_CATEGORY_SLUG}": category not found.`);
    return [];
  }

  const childCount = await prisma.category.count({
    where: { parentId: cat.id, isActive: true },
  });

  if (childCount === 0) {
    return prisma.$queryRaw<LeafRow[]>`
      SELECT c.id, c.slug, c.name,
        COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL)::bigint AS cnt
      FROM categories c
      LEFT JOIN listings l ON l.category_id = c.id
      WHERE c.is_active = true AND c.id = CAST(${cat.id} AS uuid)
      GROUP BY c.id, c.slug, c.name
      HAVING COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL) < ${leafGoal()}
    `;
  }

  return prisma.$queryRaw<LeafRow[]>`
    WITH RECURSIVE subtree AS (
      SELECT id FROM categories WHERE id = CAST(${cat.id} AS uuid)
      UNION
      SELECT c.id FROM categories c
      INNER JOIN subtree s ON c.parent_id = s.id
      WHERE c.is_active = true
    )
    SELECT c.id, c.slug, c.name,
      COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL)::bigint AS cnt
    FROM categories c
    LEFT JOIN listings l ON l.category_id = c.id
    WHERE c.is_active = true
      AND c.id IN (SELECT id FROM subtree)
      AND NOT EXISTS (
        SELECT 1 FROM categories ch
        WHERE ch.parent_id = c.id AND ch.is_active = true
      )
    GROUP BY c.id, c.slug, c.name
    HAVING COUNT(l.id) FILTER (WHERE l.status = 'active' AND l.deleted_at IS NULL) < ${leafGoal()}
    ORDER BY cnt ASC, c.name ASC
  `;
}

async function fillLeafCategoryGaps(
  merchant: { id: string },
  city: { id: string },
  country: { id: string },
  standardAmenities: { id: string }[]
): Promise<void> {
  const globalSeen = new Set<string>();
  const maxRounds = Number(process.env.LEAF_FILL_MAX_ROUNDS ?? 25);
  let noProgressStreak = 0;

  for (let round = 0; round < maxRounds; round++) {
    const leaves = await fetchLeavesBelowGoal();
    if (leaves.length === 0) {
      console.log(`\n✅ All leaf categories have at least ${leafGoal()} active listings.`);
      break;
    }

    console.log(`\n📍 Round ${round + 1}: ${leaves.length} leaf categories below ${leafGoal()}`);
    let roundAdded = 0;

    for (const row of leaves) {
      let added = 0;
      const current = Number(row.cnt);
      if (current >= leafGoal()) continue;

      const listingType = inferListingType(row.slug, row.name);
      const queries = buildQueriesForLeaf(row.slug, row.name);

      console.log(`\n=== Leaf "${row.name}" (${row.slug}) — have ${current}, goal ${leafGoal()} ===`);

      for (const q of queries) {
        if (current + added >= leafGoal()) break;

        let pageToken: string | undefined;
        let pageTokenInvalidRetries = 0;
        for (let page = 0; page < textSearchMaxPages(); page++) {
          if (current + added >= leafGoal()) break;

          try {
            const params: Record<string, string> = { key: GOOGLE_API_KEY! };
            let usedPageToken = false;
            if (pageToken) {
              usedPageToken = true;
              params.pagetoken = pageToken;
              await sleep(2000);
            } else {
              params.query = q;
            }

            const searchRes = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
              params,
            });

            if (searchRes.data.status === 'INVALID_REQUEST' && usedPageToken) {
              // Google next_page_token can take a few seconds before it becomes valid.
              // Retry this same page once with a longer delay instead of spamming warnings.
              if (pageTokenInvalidRetries < 1) {
                pageTokenInvalidRetries++;
                await sleep(2500);
                page--;
                continue;
              }
              break;
            }
            pageTokenInvalidRetries = 0;

            if (searchRes.data.status !== 'OK' && searchRes.data.status !== 'ZERO_RESULTS') {
              console.warn(`Google status: ${searchRes.data.status}`, searchRes.data.error_message || '');
              break;
            }

            const places = searchRes.data.results || [];
            for (const place of places) {
              if (current + added >= leafGoal()) break;
              const ok = await ingestGooglePlaceForCategory(
                place,
                row.id,
                row.slug,
                listingType,
                merchant,
                city,
                country,
                standardAmenities,
                globalSeen
              );
              if (ok) {
                added++;
                roundAdded++;
              }
            }

            pageToken = searchRes.data.next_page_token;
            if (!pageToken) break;
          } catch (e: any) {
            console.error(`Query error (${q}):`, e?.message);
            break;
          }
        }
      }

      const after = await countActiveListingsForCategory(row.id);
      console.log(`Done "${row.slug}": ${after} active listings.`);
    }

    if (roundAdded === 0) {
      noProgressStreak++;
      if (noProgressStreak >= 2) {
        console.warn('\n⚠️ No new listings in 2 rounds (API empty, quota, or DB constraints). Stopping leaf fill.');
        break;
      }
    } else {
      noProgressStreak = 0;
    }
  }
}

async function runLegacyCategoryScrape(
  merchant: { id: string },
  city: { id: string },
  country: { id: string },
  standardAmenities: { id: string }[]
): Promise<void> {
  for (const cat of CATEGORIES_TO_SCRAPE) {
    const categoryDb = await prisma.category.findUnique({ where: { slug: cat.slug } });
    if (!categoryDb) {
      console.warn(`Category ${cat.slug} not found. Skipping...`);
      continue;
    }

    console.log(`\n=== Legacy: ${categoryDb.name} ===`);
    let totalAddedForCategory = 0;
    const seenPlaces = new Set<string>();

    for (const seedQuery of cat.queries) {
      if (totalAddedForCategory >= 200) break;
      const query = localizeSeedQuery(seedQuery);

      let pageToken: string | undefined;
      let pagesFetched = 0;
      let pageTokenInvalidRetries = 0;

      while (pagesFetched < textSearchMaxPages()) {
        try {
          const params: Record<string, string> = { key: GOOGLE_API_KEY! };
          let usedPageToken = false;
          if (pageToken) {
            usedPageToken = true;
            params.pagetoken = pageToken;
            await sleep(2000);
          } else {
            params.query = query;
          }

          const searchRes = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
            params,
          });

          if (searchRes.data.status === 'INVALID_REQUEST' && usedPageToken) {
            if (pageTokenInvalidRetries < 1) {
              pageTokenInvalidRetries++;
              await sleep(2500);
              continue;
            }
            break;
          }
          pageTokenInvalidRetries = 0;

          if (searchRes.data.status !== 'OK' && searchRes.data.status !== 'ZERO_RESULTS') break;

          const places = searchRes.data.results || [];
          for (const place of places) {
            if (totalAddedForCategory >= 200) break;
            const ok = await ingestGooglePlaceForCategory(
              place,
              categoryDb.id,
              categoryDb.slug,
              cat.type,
              merchant,
              city,
              country,
              standardAmenities,
              seenPlaces
            );
            if (ok) totalAddedForCategory++;
          }

          pageToken = searchRes.data.next_page_token;
          pagesFetched++;
          if (!pageToken) break;
        } catch {
          break;
        }
      }
    }
  }
}

async function printAccommodationLeafCategories(): Promise<void> {
  const root = await prisma.category.findFirst({
    where: { slug: 'accommodation', isActive: true },
    select: { id: true },
  });
  if (!root) {
    console.error('Root category "accommodation" not found in DB.');
    return;
  }

  const rows = await prisma.$queryRaw<{ slug: string; name: string }[]>`
    WITH RECURSIVE subtree AS (
      SELECT id FROM categories WHERE id = CAST(${root.id} AS uuid)
      UNION
      SELECT c.id FROM categories c
      INNER JOIN subtree s ON c.parent_id = s.id
      WHERE c.is_active = true
    )
    SELECT c.slug, c.name
    FROM categories c
    WHERE c.is_active = true
      AND c.id IN (SELECT id FROM subtree)
      AND NOT EXISTS (
        SELECT 1 FROM categories ch
        WHERE ch.parent_id = c.id AND ch.is_active = true
      )
    ORDER BY c.name ASC
  `;

  console.log('Accommodation — leaf categories (slug used in SCRAPE_CATEGORY_SLUG for a single leaf):\n');
  for (const r of rows) {
    console.log(`  ${r.slug}\t${r.name}`);
  }
  console.log(`\nTotal: ${rows.length} leaves under "accommodation".`);
}

async function resolveScrapeTarget(): Promise<{
  city: { id: string; name: string; slug: string };
  country: { id: string; name: string };
}> {
  const countryCode = (process.env.SCRAPE_COUNTRY_CODE ?? '').trim().toUpperCase();
  const citySlug = (process.env.SCRAPE_CITY_SLUG ?? '').trim();
  const cityNameEnv = (process.env.SCRAPE_CITY ?? TARGET_CITY_NAME).trim();
  const nameCandidates = [cityNameEnv, ...TARGET_CITY_ALIASES];
  const strictCityInCountry = Boolean(
    countryCode || (process.env.SCRAPE_CITY ?? '').trim() || citySlug,
  );

  let country =
    countryCode.length > 0
      ? await prisma.country.findFirst({
          where: { OR: [{ code2: countryCode }, { code: countryCode }] },
        })
      : null;

  if (!country) {
    country = await prisma.country.findFirst({
      where: { name: { equals: COUNTRY_NAME, mode: 'insensitive' } },
    });
  }

  if (!country) {
    throw new Error(
      `Country not found. Set SCRAPE_COUNTRY_CODE (ISO alpha-2 e.g. RW, or alpha-3) or COUNTRY_NAME=${COUNTRY_NAME}.`,
    );
  }

  let city: { id: string; name: string; slug: string; countryId: string } | null = null;

  if (citySlug) {
    city = await prisma.city.findFirst({
      where: { countryId: country.id, slug: citySlug, isActive: true },
      select: { id: true, name: true, slug: true, countryId: true },
    });
    if (!city) {
      throw new Error(`No active city with slug "${citySlug}" in ${country.name} (${countryCode || COUNTRY_NAME}).`);
    }
  } else {
    city = await prisma.city.findFirst({
      where: {
        countryId: country.id,
        isActive: true,
        OR: nameCandidates.map((n) => ({ name: { equals: n, mode: 'insensitive' as const } })),
      },
      select: { id: true, name: true, slug: true, countryId: true },
    });
  }

  if (!city && !strictCityInCountry) {
    city = await prisma.city.findFirst({
      where: {
        OR: nameCandidates.map((n) => ({ name: { equals: n, mode: 'insensitive' as const } })),
      },
      select: { id: true, name: true, slug: true, countryId: true },
    });
    if (city) {
      const ctry = await prisma.country.findUnique({ where: { id: city.countryId } });
      if (ctry) country = ctry;
    }
  }

  if (!city) {
    throw new Error(
      `City not found. SCRAPE_CITY=${cityNameEnv}, SCRAPE_CITY_SLUG=${citySlug || '(not set)'}, SCRAPE_COUNTRY_CODE=${countryCode || '(not set)'}, country=${country.name}, aliases=${TARGET_CITY_ALIASES.join('|') || '(none)'}`,
    );
  }

  if (city.countryId !== country.id) {
    throw new Error(
      `City "${city.name}" is not in ${country.name}. Check SCRAPE_COUNTRY_CODE and city fields.`,
    );
  }

  return { city, country };
}

async function scrape() {
  console.log('Starting Google Places scraper (structural children + leaf fill + optional legacy)...');

  await configureStorage();

  const taskEarly = (process.env.SCRAPE_TASK ?? '').trim();
  if (taskEarly === 'list-accommodation-leaves') {
    await printAccommodationLeafCategories();
    process.exit(0);
  }

  if (!GOOGLE_API_KEY) {
    console.error('Missing GOOGLE_PLACES_API_KEY in environment variables.');
    process.exit(1);
  }

  let resolved: { city: { id: string; name: string; slug: string }; country: { id: string; name: string } };
  try {
    resolved = await resolveScrapeTarget();
  } catch (e: any) {
    console.error(e?.message ?? e);
    process.exit(1);
  }

  const { city, country } = resolved;
  RESOLVED_CITY_NAME = city.name;
  RESOLVED_COUNTRY_NAME = country.name;
  EFFECTIVE_CATEGORY_SLUG = (process.env.SCRAPE_CATEGORY_SLUG ?? process.env.SCRAPE_ROOT_SLUG ?? '').trim();

  console.log(
    `task=${(process.env.SCRAPE_TASK ?? '').trim() || '(none)'}, city=${city.name} (${city.slug}), country=${country.name}, SCRAPE_COUNTRY_CODE=${(process.env.SCRAPE_COUNTRY_CODE ?? '').trim() || '(not set)'}, category=${EFFECTIVE_CATEGORY_SLUG || '(all leaves)'}, LEAF_GOAL=${leafGoal()}, LEGACY_SCRAPE=${legacyScrape()}, TEXT_SEARCH_MAX_PAGES=${textSearchMaxPages()}`
  );

  const merchant = await createSystemMerchant();
  console.log(`Merchant: ${merchant.id}`);

  const standardAmenities = await prisma.amenity.findMany({
    where: { slug: { in: ['wifi', 'parking', 'ac', 'tv', 'room-service', 'pool'] } },
  });

  if (!EFFECTIVE_CATEGORY_SLUG) {
    await ensureStructuralChildCategories();
  } else {
    console.log(`Skipping structural parent bootstrap (category scope=${EFFECTIVE_CATEGORY_SLUG}).`);
  }
  await fillLeafCategoryGaps(merchant, city, country, standardAmenities);

  if (legacyScrape()) {
    await runLegacyCategoryScrape(merchant, city, country, standardAmenities);
  }

  console.log('\nCleaning up listings without images...');
  await prisma.$executeRaw`
    UPDATE listings
    SET status = 'pending_review'
    WHERE status = 'active'
      AND NOT EXISTS (
        SELECT 1
        FROM listing_images li
        WHERE li.listing_id = listings.id
      );
  `;
  console.log('Cleanup complete. Done.');
  process.exit(0);
}

scrape().catch((e) => {
  console.error(e);
  process.exit(1);
});
