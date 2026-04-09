import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const defaultMobileAppUpdateConfig = {
  ios: {
    minVersion: '1.0.0',
    minBuild: null as number | null,
    mode: 'none' as const,
    title: 'Update Zoea',
    message: 'A new version is available with improvements and fixes.',
    storeUrl: '',
    dismissForDays: 7,
  },
  android: {
    minVersion: '1.0.0',
    minBuild: null as number | null,
    mode: 'none' as const,
    title: 'Update Zoea',
    message: 'A new version is available with improvements and fixes.',
    storeUrl: '',
    dismissForDays: 7,
  },
};

async function main() {
  console.log('Seeding integrations...');

  // OpenAI Integration
  // Safety: never wipe an existing key by running seed without env vars.
  const openaiApiKey = (process.env.OPENAI_API_KEY || '').trim();
  if (!openaiApiKey) {
    console.warn(
      '[seed-integrations] OPENAI_API_KEY not provided - preserving existing openai config/isActive (if any).',
    );
  }

  await prisma.integration.upsert({
    where: { name: 'openai' },
    update: openaiApiKey
      ? {
          config: {
            apiKey: openaiApiKey,
            model: 'gpt-4-turbo-preview',
            maxTokens: 1000,
            temperature: 0.7,
          },
          isActive: true,
        }
      : {},
    create: {
      name: 'openai',
      displayName: 'OpenAI',
      description: 'OpenAI API for AI assistant (Ask Zoea)',
      isActive: openaiApiKey !== '',
      config: {
        apiKey: openaiApiKey,
        model: 'gpt-4-turbo-preview',
        maxTokens: 1000,
        temperature: 0.7,
      },
    },
  });

  // Visit Rwanda Events Integration
  await prisma.integration.upsert({
    where: { name: 'visit_rwanda' },
    update: {},
    create: {
      name: 'visit_rwanda',
      displayName: 'Visit Rwanda Events',
      description: 'External events feed from Visit Rwanda',
      isActive: false, // Set to false until URL is configured
      config: {
        eventsUrl: '', // To be configured by admin
        syncInterval: 3600, // Sync every hour (in seconds)
        lastSyncAt: null,
      },
    },
  });

  // Google Places API Integration
  // Safety: same rule as OpenAI; don't disable existing integration accidentally.
  const googlePlacesApiKey = (process.env.GOOGLE_PLACES_API_KEY || '').trim();
  if (!googlePlacesApiKey) {
    console.warn(
      '[seed-integrations] GOOGLE_PLACES_API_KEY not provided - preserving existing google_places config/isActive (if any).',
    );
  }

  await prisma.integration.upsert({
    where: { name: 'google_places' },
    update: googlePlacesApiKey
      ? {
          config: {
            apiKey: googlePlacesApiKey,
          },
          isActive: true,
        }
      : {},
    create: {
      name: 'google_places',
      displayName: 'Google Places API',
      description: 'Google Places API for address autocomplete and location services',
      isActive: googlePlacesApiKey !== '',
      config: {
        apiKey: googlePlacesApiKey,
      },
    },
  });

  // Cloudinary Integration
  // Safety: do not overwrite existing credentials unless all values are provided.
  const cloudinaryCloudName = (process.env.CLOUDINARY_CLOUD_NAME || '').trim();
  const cloudinaryApiKey = (process.env.CLOUDINARY_API_KEY || '').trim();
  const cloudinaryApiSecret = (process.env.CLOUDINARY_API_SECRET || '').trim();
  const hasCloudinaryCredentials =
    cloudinaryCloudName !== '' && cloudinaryApiKey !== '' && cloudinaryApiSecret !== '';

  if (!hasCloudinaryCredentials) {
    console.warn(
      '[seed-integrations] Cloudinary env vars missing/incomplete - preserving existing cloudinary config/isActive (if any).',
    );
  }

  await prisma.integration.upsert({
    where: { name: 'cloudinary' },
    update: hasCloudinaryCredentials
      ? {
          config: {
            cloudName: cloudinaryCloudName,
            apiKey: cloudinaryApiKey,
            apiSecret: cloudinaryApiSecret,
          },
          isActive: true,
        }
      : {},
    create: {
      name: 'cloudinary',
      displayName: 'Cloudinary',
      description: 'Cloudinary for image and media storage and optimization',
      isActive: hasCloudinaryCredentials,
      config: {
        cloudName: cloudinaryCloudName,
        apiKey: cloudinaryApiKey,
        apiSecret: cloudinaryApiSecret,
        maxStorageGB: 25,
      },
    },
  });

  // Weather Integration (Open-Meteo)
  // Note: Open-Meteo is free and requires no API key
  await prisma.integration.upsert({
    where: { name: 'weather' },
    update: {
      config: {
        provider: 'open-meteo',
        baseUrl: 'https://api.open-meteo.com/v1',
        description: 'Free weather API with no API key required',
      },
      isActive: true,
    },
    create: {
      name: 'weather',
      displayName: 'Weather Service (Open-Meteo)',
      description: 'Real-time weather data using Open-Meteo API (free, no API key required)',
      isActive: true,
      config: {
        provider: 'open-meteo',
        baseUrl: 'https://api.open-meteo.com/v1',
        description: 'Free weather API with no API key required',
      },
    },
  });

  await prisma.integration.upsert({
    where: { name: 'mobile_app_update' },
    update: {},
    create: {
      name: 'mobile_app_update',
      displayName: 'Mobile app update prompts',
      description: 'Optional or mandatory in-app update prompts for iOS and Android (public app)',
      isActive: true,
      config: defaultMobileAppUpdateConfig,
    },
  });

  console.log('Integrations seeded successfully!');
}

main()
  .catch((e) => {
    console.error('Error seeding integrations:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

