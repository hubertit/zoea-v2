/**
 * Task-based presets for `SCRAPE_TASK=<name>`.
 * Existing `process.env` values always win (override preset defaults).
 */

export type ScrapeTaskPreset = {
  description: string;
  /** Maintenance / docs-only (no Places scrape). */
  kind?: 'scrape' | 'help';
  env: Record<string, string>;
};

export const SCRAPE_TASK_PRESETS: Record<string, ScrapeTaskPreset> = {
  /** Accommodation subtree: hotels, motels, BnBs, apartments, hostels, resorts, villas (rooms + amenities where applicable). */
  'accommodation-kigali': {
    description:
      'Kigali — full **accommodation** tree (all leaf categories under `accommodation`). Listings use hotel-style rooms + amenities when the scraper infers a lodging type.',
    env: {
      SCRAPE_COUNTRY_CODE: 'RW',
      SCRAPE_CITY_SLUG: 'kigali',
      SCRAPE_CATEGORY_SLUG: 'accommodation',
      LEAF_GOAL_LISTINGS: '15',
      LEAF_FILL_MAX_ROUNDS: '35',
      TEXT_SEARCH_MAX_PAGES: '5',
    },
  },
  /** Everything: all leaf categories city-wide (dining, shopping, services, etc.). */
  'general-kigali': {
    description:
      'Kigali — **all** category leaves (no category filter). Add `LEGACY_SCRAPE=1` for extra curated seed passes.',
    env: {
      SCRAPE_COUNTRY_CODE: 'RW',
      SCRAPE_CITY_SLUG: 'kigali',
      LEAF_GOAL_LISTINGS: '12',
      LEAF_FILL_MAX_ROUNDS: '25',
      TEXT_SEARCH_MAX_PAGES: '4',
    },
  },
  'dining-kigali': {
    description: 'Kigali — **dining** subtree only (all cuisine / restaurant leaves).',
    env: {
      SCRAPE_COUNTRY_CODE: 'RW',
      SCRAPE_CITY_SLUG: 'kigali',
      SCRAPE_CATEGORY_SLUG: 'dining',
      LEAF_GOAL_LISTINGS: '15',
      LEAF_FILL_MAX_ROUNDS: '40',
      TEXT_SEARCH_MAX_PAGES: '5',
    },
  },
  'maintenance-inactive-images': {
    kind: 'help',
    description:
      'Does not run Places scrape. Use: `npm run backfill:inactive-images` (same repo) to refresh photos for inactive listings.',
    env: {},
  },
};

export function applyScrapeTaskIfSet(): void {
  const name = (process.env.SCRAPE_TASK ?? '').trim();
  if (!name || name === 'list-tasks' || name === 'list-accommodation-leaves') return;

  const preset = SCRAPE_TASK_PRESETS[name];
  if (!preset) {
    console.error(`Unknown SCRAPE_TASK="${name}". Run with SCRAPE_TASK=list-tasks for names and descriptions.`);
    process.exit(1);
  }

  if (preset.kind === 'help' && Object.keys(preset.env).length === 0) {
    console.log(`Task "${name}" — ${preset.description}`);
    process.exit(0);
  }

  for (const [key, value] of Object.entries(preset.env)) {
    if (process.env[key] === undefined) process.env[key] = value;
  }
}

export function formatTasksHelp(): string {
  const lines = ['Named scrape tasks (set SCRAPE_TASK=<key> before running scrape-google-places):', ''];
  for (const [key, p] of Object.entries(SCRAPE_TASK_PRESETS)) {
    lines.push(`  ${key}`);
    lines.push(`    ${p.description}`);
    lines.push('');
  }
  lines.push('Utility:');
  lines.push('  SCRAPE_TASK=list-tasks           — print this help');
  lines.push('  SCRAPE_TASK=list-accommodation-leaves — print DB leaf slugs under `accommodation`');
  lines.push('');
  lines.push('Any env var you set yourself overrides the task defaults.');
  return lines.join('\n');
}
