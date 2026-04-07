import { PrismaClient } from '@prisma/client';
import axios from 'axios';
import { v2 as cloudinary } from 'cloudinary';
import { randomUUID } from 'crypto';

const prisma = new PrismaClient();

const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

if (!GOOGLE_API_KEY) {
  console.error('Missing GOOGLE_PLACES_API_KEY in environment variables.');
  process.exit(1);
}

// Will be configured from DB
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

  // Fallback to database integration if not in ENV
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

const TARGET_CITY_NAME = 'Kigali';
const COUNTRY_NAME = 'Rwanda';

// We map a slug to multiple queries to fetch up to ~180-200 places per category via pagination
const CATEGORIES_TO_SCRAPE = [
  { slug: 'clubs', queries: [
      'Cadillac Night Club Kigali', 'Voltage Club Kigali', 'Envy Club Kigali', 
      'Cocobean Kigali', 'Papyrus Kigali', 'Shooters Lounge Kigali', 'Blackout Club Kigali'
    ], type: 'club' },
  { slug: 'bars', queries: [
      'Pillar Bar Kigali', 'Choma\'d Kigali', 'Tropicana Lounge Kigali', 
      'Le Must Kigali', 'New Cadillac Club Kigali'
    ], type: 'bar' },
  { slug: 'lounges', queries: [
      'Repub Lounge Kigali', 'Chillax Lounge Kigali', 'La Noche Kigali', 
      'Bicu Lounge Kigali', 'Rosty Club Kigali', 'Riders Lounge Kigali'
    ], type: 'lounge' },
  { slug: 'cultural', queries: [
      'Kigali Genocide Memorial', 'Inema Arts Center Kigali', 'Niyo Art Gallery Kigali', 
      'Nyamirambo Women\'s Center', 'Rwanda Art Museum'
    ], type: 'tour' },
  { slug: 'hiking', queries: [
      'Mount Kigali', 'Fazenda Sengha Kigali', 'Nyandungu Eco-Park Kigali'
    ], type: 'tour' },
  { slug: 'tour-and-travel', queries: [
      'Kigali City Tour', 'Gorilla Trekking Rwanda', 'Akagera National Park', 'Nyungwe Forest Canopy Walk'
    ], type: 'tour' },
  { slug: 'cinema', queries: [
      'Century Cinema Kigali', 'Canal Olympia Kigali'
    ], type: 'attraction' }
];

async function uploadImage(photoReference: string, placeName: string): Promise<{ url: string; provider: string }> {
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photoReference}&key=${GOOGLE_API_KEY}`;
  
  if (cloudinaryConfigured) {
    try {
      const result = await cloudinary.uploader.upload(photoUrl, {
        folder: 'zoea_listings_scraped',
        public_id: `${placeName.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}_${Date.now()}`
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
        passwordHash: 'dummy_hash', // Can't login directly
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

async function scrape() {
  console.log('Starting Google Places Scraper for Kigali Nightlife...');
  
  await configureStorage();

  const merchant = await createSystemMerchant();
  console.log(`Using System Merchant ID: ${merchant.id}`);

  const city = await prisma.city.findFirst({ where: { name: { equals: TARGET_CITY_NAME, mode: 'insensitive' } } });
  const country = await prisma.country.findFirst({ where: { name: { equals: COUNTRY_NAME, mode: 'insensitive' } } });
  
  const standardAmenities = await prisma.amenity.findMany({
    where: { slug: { in: ['wifi', 'parking', 'ac', 'tv', 'room-service', 'pool'] } }
  });

  if (!city || !country) {
    console.error('City or Country not found in DB.');
    process.exit(1);
  }

  for (const cat of CATEGORIES_TO_SCRAPE) {
    const categoryDb = await prisma.category.findUnique({ where: { slug: cat.slug } });
    if (!categoryDb) {
      console.warn(`Category ${cat.slug} not found in DB. Skipping...`);
      continue;
    }

    console.log(`\n=== Processing Category: ${categoryDb.name} ===`);
    let totalAddedForCategory = 0;
    const seenPlaces = new Set(); // Prevent duplicates across multiple queries

    for (const query of cat.queries) {
      console.log(`\nSearching for: ${query}`);
      let pageToken: string | undefined = undefined;
      let pagesFetched = 0;

      while (pagesFetched < 3) { // Max 3 pages per query (60 results max via textsearch)
        try {
          const params: any = { key: GOOGLE_API_KEY };
          if (pageToken) {
            params.pagetoken = pageToken;
            await sleep(2000); // Google requires a short delay before next_page_token is valid
          } else {
            params.query = query;
          }

          const searchRes = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', { params });
          
          if (searchRes.data.status !== 'OK' && searchRes.data.status !== 'ZERO_RESULTS') {
             console.warn(`Google API returned status: ${searchRes.data.status}`);
             if (searchRes.data.error_message) console.warn(`Error: ${searchRes.data.error_message}`);
             break; // Stop paginating if error
          }

          const places = searchRes.data.results || [];
          console.log(`Found ${places.length} places on page ${pagesFetched + 1}.`);
          
          for (const place of places) {
            if (totalAddedForCategory >= 200) {
              console.log(`Reached 200 limit for category ${cat.slug}. Stopping.`);
              break; // Skip inner loop
            }

            if (seenPlaces.has(place.place_id)) {
              continue;
            }
            seenPlaces.add(place.place_id);

            try {
              const existing = await prisma.listing.findFirst({
                where: { name: place.name, cityId: city.id, deletedAt: null }
              });

              if (existing) {
                console.log(`  - Skipping ${place.name}: already exists.`);
                continue;
              }

              console.log(`  - Fetching details for ${place.name}...`);
              
              const detailsRes = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
                params: {
                  place_id: place.place_id,
                  fields: 'name,formatted_address,geometry,rating,user_ratings_total,photos,reviews,website,formatted_phone_number,opening_hours,editorial_summary',
                  key: GOOGLE_API_KEY
                }
              });
              
              const details = detailsRes.data.result;
              if (!details) continue;
              
              // Prepare data
              const lat = details.geometry?.location?.lat;
              const lng = details.geometry?.location?.lng;
              let shortDesc = '';
              if (details.opening_hours && details.opening_hours.weekday_text) {
                 shortDesc += `Open: ${details.opening_hours.weekday_text[0]}`;
              }
              
              const overview = details.editorial_summary?.overview || null;
              
              // 1. Create Listing
              const slug = `${place.name.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${Date.now().toString(36).substring(4)}`;
              
              const listing = await prisma.listing.create({
                data: {
                  merchantId: merchant.id,
                  categoryId: categoryDb.id,
                  cityId: city.id,
                  countryId: country.id,
                  name: details.name || place.name,
                  slug,
                  address: details.formatted_address,
                  contactPhone: details.formatted_phone_number,
                  website: details.website,
                  rating: 5.0, // Forced to 5.0 so they organically sort at the very top, right beneath the featured items
                  reviewCount: details.user_ratings_total ? Math.max(details.user_ratings_total, 500) : 500, // At least 500 reviews to establish popularity
                  shortDescription: shortDesc.substring(0, 255),
                  description: overview,
                  status: 'active',
                  type: cat.type as any,
                  isVerified: true,
                }
              });

              // 2. Set Geography Location via Raw Query
              if (lat && lng) {
                await prisma.$executeRaw`UPDATE listings SET location = ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326) WHERE id = ${listing.id}::uuid`;
              }

              // 3. Process Photos (up to 5)
              if (details.photos && details.photos.length > 0) {
                const photosToProcess = details.photos.slice(0, 5);
                console.log(`    -> Uploading ${photosToProcess.length} photos for ${place.name}...`);
                
                for (let i = 0; i < photosToProcess.length; i++) {
                  const photoInfo = await uploadImage(photosToProcess[i].photo_reference, `${place.name}_${i}`);
                  
                  const media = await prisma.media.create({
                    data: {
                      url: photoInfo.url,
                      storageProvider: photoInfo.provider,
                      mediaType: 'image',
                      fileName: `${slug}-photo-${i}`,
                      mimeType: 'image/jpeg'
                    }
                  });

                  await prisma.listingImage.create({
                    data: {
                      listingId: listing.id,
                      mediaId: media.id,
                      isPrimary: i === 0,
                      sortOrder: i + 1
                    }
                  });
                }
              }

              // 5. Add standard amenities
              if (standardAmenities.length > 0) {
                console.log(`    -> Adding standard amenities...`);
                for (const amenity of standardAmenities) {
                  // Give an 80% chance for a hotel to have standard amenities like WiFi, etc.
                  if (Math.random() < 0.8) {
                    await prisma.listingAmenity.create({
                      data: {
                        listingId: listing.id,
                        amenityId: amenity.id
                      }
                    });
                  }
                }
              }

              // 6. Create mock Room Types and Rooms for accommodations
              if (['hotel', 'resort', 'motel', 'bnb'].some(t => cat.slug.includes(t)) || cat.type === 'hotel') {
                console.log(`    -> Creating mock rooms for ${place.name}...`);
                const roomTypes = [
                  { name: 'Standard Double Room', price: 80 },
                  { name: 'Deluxe Suite', price: 150 }
                ];

                for (const rt of roomTypes) {
                  const roomType = await prisma.roomType.create({
                    data: {
                      listingId: listing.id,
                      name: rt.name,
                      description: `A comfortable ${rt.name.toLowerCase()} with beautiful city views, perfect for a relaxing stay.`,
                      maxOccupancy: 2,
                      bedType: 'Double',
                      bedCount: 1,
                      basePrice: rt.price,
                      currency: 'USD',
                      totalRooms: 5,
                      isActive: true,
                    }
                  });

                  for (let r = 1; r <= 5; r++) {
                    await prisma.room.create({
                      data: {
                        roomTypeId: roomType.id,
                        roomNumber: `${Math.floor(Math.random() * 9 + 1)}0${r}`,
                        floor: 1,
                        status: 'available' as any
                      }
                    });
                  }
                }
              }

              // 4. Process Reviews
              if (details.reviews && details.reviews.length > 0) {
                const targetReviewsCount = Math.floor(Math.random() * 11) + 5; // Random between 5 and 15
                console.log(`    -> Saving ${targetReviewsCount} reviews for ${place.name}...`);
                
                for (let i = 0; i < targetReviewsCount; i++) {
                  // Pick a random review from the ones Google returned
                  const rev = details.reviews[Math.floor(Math.random() * details.reviews.length)];
                  
                  // Create a realistic random date within the last 180 days
                  const randomDate = new Date();
                  randomDate.setDate(randomDate.getDate() - Math.floor(Math.random() * 180));
                  
                  await prisma.review.create({
                    data: {
                      listingId: listing.id,
                      rating: rev.rating,
                      content: rev.text,
                      title: `${rev.author_name}'s Review`,
                      status: 'approved' as any,
                      isVerified: false,
                      createdAt: randomDate,
                      updatedAt: randomDate,
                    }
                  });
                }
              }
              
              console.log(`    => Successfully added ${place.name} (ID: ${listing.id})`);
              totalAddedForCategory++;
            } catch (placeErr: any) {
              console.error(`    => Error processing ${place.name}:`, placeErr?.message);
            }
          }

          if (totalAddedForCategory >= 200) {
            break; // Stop pagination for this query
          }

          pageToken = searchRes.data.next_page_token;
          pagesFetched++;
          if (!pageToken) break; // No more pages

        } catch (error: any) {
          console.error(`Error querying ${query}:`, error?.response?.data || error.message);
          break;
        }
      }
      
      if (totalAddedForCategory >= 200) {
        break; // Stop executing queries for this category
      }
    }
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
  console.log('Cleanup complete!');

  console.log('\nScraping complete!');
  process.exit(0);
}

scrape().catch(e => {
  console.error(e);
  process.exit(1);
});