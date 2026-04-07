/**
 * Reports active categories with fewer than N direct active listings.
 * Run: cd apps/backend && npx ts-node scripts/report-category-listing-gaps.ts
 */
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const MIN = 5;

type Row = {
  id: string;
  slug: string;
  name: string;
  parent_id: string | null;
  active_listings: bigint;
};

function serialize(rows: Row[]) {
  return rows.map((r) => ({
    id: r.id,
    slug: r.slug,
    name: r.name,
    parentId: r.parent_id,
    activeListings: Number(r.active_listings),
  }));
}

async function main() {
  const rows = await prisma.$queryRaw<Row[]>`
    SELECT c.id, c.slug, c.name, c.parent_id,
           COUNT(l.id) FILTER (
             WHERE l.status = 'active' AND l.deleted_at IS NULL
           ) AS active_listings
    FROM categories c
    LEFT JOIN listings l ON l.category_id = c.id
    WHERE c.is_active = true
    GROUP BY c.id, c.slug, c.name, c.parent_id
    ORDER BY active_listings ASC, c.sort_order ASC NULLS LAST, c.name ASC
  `;

  const mapped = serialize(rows);
  const under = mapped.filter((r) => r.activeListings < MIN);

  const byParent = new Map<string | null, typeof mapped>();
  for (const c of mapped) {
    const k = c.parentId ?? null;
    if (!byParent.has(k)) byParent.set(k, []);
    byParent.get(k)!.push(c);
  }

  const idToName = new Map(mapped.map((c) => [c.id, c.name]));

  const report = under.map((c) => ({
    ...c,
    parentName: c.parentId ? idToName.get(c.parentId) ?? '(unknown)' : null,
    childSlugs: (byParent.get(c.id) ?? []).map((ch) => ch.slug),
  }));

  console.log(
    JSON.stringify(
      {
        minRequired: MIN,
        totalActiveCategories: mapped.length,
        categoriesUnderMinimum: report.length,
        categories: report,
      },
      null,
      2
    )
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
