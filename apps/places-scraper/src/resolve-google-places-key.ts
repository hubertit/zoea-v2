/**
 * Load the same Google Places key used for Kigali scraping: env / .env files / DB `integrations.google_places`.
 */

import * as fs from 'fs';
import * as path from 'path';
import type { PrismaClient } from '@prisma/client';

/** Keys merged from repo .env files when not already set in process.env */
const DOTENV_KEYS = new Set([
  'DATABASE_URL',
  'GOOGLE_PLACES_API_KEY',
  'GOOGLE_MAPS_API_KEY',
  'CLOUDINARY_CLOUD_NAME',
  'CLOUDINARY_API_KEY',
  'CLOUDINARY_API_SECRET',
]);

export function loadPlacesScraperEnvFromFiles(): void {
  const candidates = [
    path.join(__dirname, '../../backend/.env'),
    path.join(__dirname, '../.env'),
  ];
  for (const envPath of candidates) {
    if (!fs.existsSync(envPath)) continue;
    for (const line of fs.readFileSync(envPath, 'utf8').split(/\r?\n/)) {
      const m = line.match(/^([A-Z0-9_]+)=(.*)$/);
      if (!m) continue;
      const key = m[1]!;
      if (!DOTENV_KEYS.has(key)) continue;
      if (process.env[key]?.trim()) continue;
      process.env[key] = m[2]!.trim().replace(/^["']|["']$/g, '');
    }
  }
}

/** Env-only (sync). Call after loadPlacesScraperEnvFromFiles(). */
export function googlePlacesKeyFromEnv(): string | undefined {
  const k =
    process.env.GOOGLE_PLACES_API_KEY?.trim() || process.env.GOOGLE_MAPS_API_KEY?.trim();
  return k || undefined;
}

export async function resolveGooglePlacesApiKey(prisma: PrismaClient): Promise<string | undefined> {
  loadPlacesScraperEnvFromFiles();
  const fromEnv = googlePlacesKeyFromEnv();
  if (fromEnv) return fromEnv;
  try {
    const rows: { config: unknown }[] = await prisma.$queryRaw`
      SELECT config FROM integrations WHERE name = 'google_places' LIMIT 1`;
    const cfg = rows[0]?.config as { apiKey?: string } | undefined;
    const k = cfg?.apiKey;
    if (typeof k === 'string' && k.trim()) return k.trim();
  } catch {
    /* missing table / permissions */
  }
  return undefined;
}
