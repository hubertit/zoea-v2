/**
 * Backfill Category.nameFr from English slug/name using curated FR labels
 * aligned with app FR copy (explore home tiles, tourism/services context).
 *
 * Usage (loads DATABASE_URL from apps/backend/.env):
 *   cd apps/backend && npx ts-node scripts/backfill-category-name-fr.ts
 *
 * Optional: merge labels from public API for drift detection:
 *   FETCH_CATEGORY_LABELS=1 npx ts-node scripts/backfill-category-name-fr.ts
 *
 * Only updates rows where name_fr is null or blank (set FORCE_REFILL=1 to overwrite).
 */
import { PrismaClient } from '@prisma/client';
import * as https from 'https';

const prisma = new PrismaClient();

const DEFAULT_API =
  process.env.CATEGORIES_BACKFILL_API_URL ??
  'https://zoea-africa.qtsoftwareltd.com/api/categories?flat=true';

/** Curated French display labels (≤100 chars). Keys = category.slug from API/DB. */
const SLUG_TO_FR: Record<string, string> = {
  // Top-level explore / docs (aligned with app_fr.arb exploreHomeCategory*)
  events: 'Événements',
  dining: 'Restauration',
  experiences: 'Expériences',
  nightlife: 'Vie nocturne',
  accommodation: 'Hébergement',
  shopping: 'Shopping',
  attractions: 'Attractions',
  sports: 'Sports',
  services: 'Services',
  transport: 'Transport',
  hiking: 'Randonnée',
  museums: 'Musées',
  'national-parks': 'Parcs nationaux',

  // Experiences subtree
  adventure: 'Aventure',
  'active-adventure': 'Sport et aventure',
  cultural: 'Culturel',
  'community-curtural': 'Communautaire et culturel', // DB slug typo vs “cultural”
  nature: 'Nature',
  'eco-tourism': 'Écotourisme',
  water: 'Activités aquatiques',
  cinema: 'Cinéma',
  'carfree-zone': 'Zone sans voiture',
  'tour-and-travel': 'Circuits et voyages',

  // Dining subtree
  restaurants: 'Restaurants',
  cafes: 'Cafés',
  'fast-food': 'Restauration rapide',
  cuisines: 'Cuisines',
  'dining-types': 'Types de restauration',
  'fine-dining': 'Gastronomie',
  'casual-dining': 'Restauration décontractée',
  continental: 'Cuisine continentale',
  chinese: 'Cuisine chinoise',
  indian: 'Cuisine indienne',
  italian: 'Cuisine italienne',
  'take-a-coffee': 'Café à emporter',

  // Nightlife subtree
  bars: 'Bars',
  clubs: 'Clubs',
  'night-clubs': 'Boîtes de nuit',
  lounges: 'Salons lounge',
  'cocktail-bars': 'Bars à cocktails',
  'rooftop-bars': 'Bars sur les toits',
  'wine-bars': 'Bars à vin',
  'karaoke-bars': 'Bars karaoké',
  'sports-bars': 'Bars sportifs',

  // Accommodation subtree
  hotels: 'Hôtels',
  hostels: 'Auberges de jeunesse',
  resorts: 'Complexes hôteliers',
  motels: 'Motels',
  apartments: 'Appartements',
  villas: 'Villas',
  bnbs: 'Chambres d’hôtes',

  // Shopping subtree
  malls: 'Centres commerciaux',
  markets: 'Marchés',
  boutiques: 'Boutiques',

  // Attractions subtree
  monuments: 'Monuments',
  viewpoints: 'Points de vue',
  'historical-sites': 'Sites historiques',
  'cultural-landmarks': 'Lieux culturels remarquables',
  'natural-landmarks': 'Sites naturels remarquables',
  'statues-memorials': 'Statues et monuments',
  'architectural-sites': 'Sites architecturaux',

  // Events subtree
  'events-venues': 'Salles d’événements et conférences',
  'events-wedding-venues': 'Salles de mariage',

  // Transport subtree
  'transport-airport-shuttles': 'Navettes aéroport',
  'transport-bus-coaches': 'Bus et autocars',
  'transport-car-hire': 'Location de voitures',
  'transport-moto-taxi': 'Moto et taxi',
  taxi: 'Taxi',
  'road-side': 'Assistance routière',

  // Roadside / auto assistance (services context)
  'emergency-roadside': 'Dépannage routier',
  'fuel-delivery': 'Livraison de carburant',
  'tire-services': 'Services pneumatiques',
  'minor-repairs': 'Réparations mineures',
  'jump-start': 'Dépannage batterie',
  'towing-truck': 'Remorquage',
  lockout: 'Ouverture de véhicule',
  'special-features': 'Caractéristiques spéciales',
  'vegan-vegetarian': 'Végétarien et végan',
  halal: 'Halal',
  'kids-friendly': 'Adapté aux enfants',
  'outdoor-seating': 'Terrasse extérieure',

  // Sports subtree
  'golf-courses': 'Terrains de golf',
  'sports-centers': 'Centres sportifs',
  'gyms-fitness': 'Salles de sport et fitness',
  'stadiums-arenas': 'Stades et arènes',

  // Services / institutions
  banking: 'Services bancaires',
  banks: 'Banques',
  atms: 'GAB',
  forex: 'Change de devises',
  telecoms: 'Télécommunications',
  'insurance-companies': 'Assurances',
  pharmacy: 'Pharmacie',
  'medical-services': 'Services médicaux',
  'health-and-wellness': 'Santé et bien-être',
  'beauty-salon': 'Salon de beauté',
  'emergency-services': 'Services d’urgence',
  helplines: 'Lignes d’assistance',
  'fire-stations': 'Pompiers',
  'police-stations': 'Police',
  ministries: 'Ministères',
  'government-institutions': 'Institutions publiques',
  'judicial-institutions': 'Institutions judiciaires',
  'public-offices': 'Administrations publiques',
  'embassies-and-consulates': 'Ambassades et consulats',

  // Places of worship / culture
  churches: 'Églises',
  mosques: 'Mosquées',
  temples: 'Temples',
  synagogues: 'Synagogues',
  'religious-institutions': 'Institutions religieuses',

  // Real estate
  'real-estate': 'Immobilier',
  'real-estate-rentals': 'Locations immobilières',
  'real-estate-sales': 'Ventes immobilières',

  // Misc commerce / creative
  'arts-crafts': 'Arts et artisanat',
  kids: 'Enfants',

  // Legacy odd slug seen on prod dump (duplicate architectural bucket)
  '0': 'Sites architecturaux',
};

function clip100(s: string): string {
  return s.length <= 100 ? s : s.slice(0, 100);
}

function fetchJson(url: string): Promise<unknown> {
  return new Promise((resolve, reject) => {
    https
      .get(url, { headers: { Accept: 'application/json' } }, (res) => {
        if (res.statusCode && res.statusCode >= 400) {
          reject(new Error(`HTTP ${res.statusCode}`));
          return;
        }
        const chunks: Buffer[] = [];
        res.on('data', (c) => chunks.push(c));
        res.on('end', () => {
          try {
            resolve(JSON.parse(Buffer.concat(chunks).toString('utf8')));
          } catch (e) {
            reject(e);
          }
        });
      })
      .on('error', reject);
  });
}

async function main() {
  const force = process.env.FORCE_REFILL === '1';
  const fetchLabels = process.env.FETCH_CATEGORY_LABELS === '1';

  if (fetchLabels) {
    try {
      const data = (await fetchJson(DEFAULT_API)) as Array<{
        slug: string;
        name: string;
      }>;
      const missing = data.filter((r) => !SLUG_TO_FR[r.slug]);
      if (missing.length) {
        console.warn(
          '[backfill] Slugs in API without FR map (add to SLUG_TO_FR):\n',
          missing.map((m) => `${m.slug}\t${m.name}`).join('\n'),
        );
      }
    } catch (e) {
      console.warn('[backfill] API drift check failed:', e);
    }
  }

  const rows = await prisma.category.findMany({
    select: { id: true, slug: true, name: true, nameFr: true },
    orderBy: { slug: 'asc' },
  });

  let updated = 0;
  let skipped = 0;
  let noMap = 0;

  for (const row of rows) {
    const slug = row.slug.trim();
    const fr = SLUG_TO_FR[slug];
    if (!fr) {
      noMap++;
      console.warn(`[skip] No FR map for slug="${slug}" name="${row.name}"`);
      continue;
    }

    const hasExisting =
      row.nameFr != null && String(row.nameFr).trim().length > 0;
    if (hasExisting && !force) {
      skipped++;
      continue;
    }

    const value = clip100(fr);
    await prisma.category.update({
      where: { id: row.id },
      data: { nameFr: value },
    });
    updated++;
    console.log(`[ok] ${slug} → ${value}`);
  }

  console.log(
    `\nDone. updated=${updated} skipped_existing=${skipped} missing_map=${noMap} total_db=${rows.length}`,
  );

  if (noMap > 0) {
    console.warn(
      '\nTip: add missing slugs to SLUG_TO_FR in scripts/backfill-category-name-fr.ts and re-run.',
    );
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
