import type { Category } from '@/lib/api/categories';

/**
 * Order used for “most relevant” travel / lifestyle categories (lower index = show first).
 * Matched against slug, name, and icon (substring match, case-insensitive).
 */
const PRIORITY_TERMS: readonly string[] = [
  'hotel',
  'stay',
  'accommodation',
  'lodg',
  'restaurant',
  'dine',
  'food',
  'cafe',
  'tour',
  'experience',
  'adventure',
  'attract',
  'sight',
  'culture',
  'heritage',
  'event',
  'night',
  'club',
  'bar',
  'shop',
  'retail',
  'spa',
  'wellness',
  'transport',
  'outdoor',
  'nature',
];

function relevanceRank(category: Category): number {
  const haystack = `${category.slug} ${category.name} ${category.icon ?? ''}`.toLowerCase();
  let best = PRIORITY_TERMS.length;
  for (let i = 0; i < PRIORITY_TERMS.length; i++) {
    if (haystack.includes(PRIORITY_TERMS[i])) {
      best = Math.min(best, i);
    }
  }
  return best;
}

/** Active categories first by relevance, then by listing count. */
export function sortCategoriesByRelevance(categories: Category[]): Category[] {
  const active = categories.filter((c) => c.isActive !== false);
  return [...active].sort((a, b) => {
    const ra = relevanceRank(a);
    const rb = relevanceRank(b);
    if (ra !== rb) return ra - rb;
    return (b.listingCount ?? 0) - (a.listingCount ?? 0);
  });
}
