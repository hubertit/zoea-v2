/**
 * Ensure each top-level (root) category subtree has at least N featured active listings.
 * Picks the highest-rated listings with at least one image; falls back to listings without images.
 *
 * Run: cd apps/backend && npx ts-node scripts/balance-featured-listings.ts
 *
 * Env:
 *   FEATURED_MIN_PER_ROOT (default 6) — minimum featured listings per root tab
 *   DRY_RUN=1 — log only, no updates
 *
 * Roots with zero active listings are reported — use places-scraper with SCRAPE_ROOT_SLUG=<slug>.
 */
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const MIN_PER_ROOT = Math.max(1, Number(process.env.FEATURED_MIN_PER_ROOT ?? 6));
const DRY_RUN = process.env.DRY_RUN === '1' || process.env.DRY_RUN === 'true';

type Cat = { id: string; parentId: string | null; name: string; slug: string };

function buildChildrenMap(rows: Cat[]): Map<string, string[]> {
  const byParent = new Map<string, string[]>();
  for (const c of rows) {
    if (c.parentId == null) continue;
    if (!byParent.has(c.parentId)) byParent.set(c.parentId, []);
    byParent.get(c.parentId)!.push(c.id);
  }
  return byParent;
}

function descendantIds(rootId: string, byParent: Map<string, string[]>): string[] {
  const out = new Set<string>([rootId]);
  const q = [rootId];
  while (q.length) {
    const id = q.shift()!;
    for (const ch of byParent.get(id) || []) {
      if (!out.has(ch)) {
        out.add(ch);
        q.push(ch);
      }
    }
  }
  return [...out];
}

async function main() {
  const active = await prisma.category.findMany({
    where: { isActive: true },
    select: { id: true, parentId: true, name: true, slug: true },
    orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
  });

  const byParent = buildChildrenMap(active);
  const roots = active.filter((c) => c.parentId == null);

  console.log(
    `balance-featured-listings: MIN_PER_ROOT=${MIN_PER_ROOT}, DRY_RUN=${DRY_RUN}, roots=${roots.length}\n`,
  );

  const emptySubtrees: { slug: string; name: string }[] = [];
  let updatedTotal = 0;

  for (const root of roots) {
    const catIds = descendantIds(root.id, byParent);

    const totalActive = await prisma.listing.count({
      where: {
        categoryId: { in: catIds },
        status: 'active',
        deletedAt: null,
      },
    });

    if (totalActive === 0) {
      emptySubtrees.push({ slug: root.slug, name: root.name });
      console.log(`⚠️  "${root.name}" (${root.slug}) — no active listings in subtree. Scrape or add listings.`);
      continue;
    }

    const featuredCount = await prisma.listing.count({
      where: {
        categoryId: { in: catIds },
        status: 'active',
        deletedAt: null,
        isFeatured: true,
      },
    });

    const need = Math.max(0, MIN_PER_ROOT - featuredCount);
    if (need === 0) {
      console.log(`✓ "${root.name}" — ${featuredCount} featured (ok)`);
      continue;
    }

    const notFeatured = {
      OR: [{ isFeatured: false }, { isFeatured: null }],
    };

    let picks = await prisma.listing.findMany({
      where: {
        categoryId: { in: catIds },
        status: 'active',
        deletedAt: null,
        ...notFeatured,
        images: { some: {} },
      },
      orderBy: [{ rating: 'desc' }, { reviewCount: 'desc' }],
      take: need,
      select: { id: true, name: true, rating: true, reviewCount: true },
    });

    if (picks.length < need) {
      const rest = await prisma.listing.findMany({
        where: {
          categoryId: { in: catIds },
          status: 'active',
          deletedAt: null,
          ...notFeatured,
          NOT: { id: { in: picks.map((p) => p.id) } },
        },
        orderBy: [{ rating: 'desc' }, { reviewCount: 'desc' }],
        take: need - picks.length,
        select: { id: true, name: true, rating: true, reviewCount: true },
      });
      picks = [...picks, ...rest];
    }

    if (picks.length === 0) {
      console.log(`⚠️  "${root.name}" — could not find non-featured listings to promote (${featuredCount} featured).`);
      continue;
    }

    const ids = picks.map((p) => p.id);
    console.log(
      `→ "${root.name}" (${root.slug}): promoting ${ids.length} listing(s) to featured — ${picks
        .map((p) => p.name)
        .join(', ')}`,
    );

    if (!DRY_RUN) {
      const res = await prisma.listing.updateMany({
        where: { id: { in: ids } },
        data: { isFeatured: true },
      });
      updatedTotal += res.count;
    }
  }

  console.log(`\nDone. ${DRY_RUN ? 'No DB writes (DRY_RUN).' : `Updated ${updatedTotal} listings (is_featured=true).`}`);

  if (emptySubtrees.length > 0) {
    console.log('\n--- Subtrees with no listings (run scraper per slug) ---');
    for (const e of emptySubtrees) {
      console.log(
        `cd apps/places-scraper && SCRAPE_ROOT_SLUG=${e.slug} npm run scrape:places`,
      );
    }
  }

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
