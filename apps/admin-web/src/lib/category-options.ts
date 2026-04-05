import type { Category } from '@/src/lib/api/categories';

/** Depth-first flatten of API category trees (`tree=true` or nested `children`). */
export function flattenCategoryTree(roots: Category[]): Category[] {
  const out: Category[] = [];
  const walk = (nodes: Category[]) => {
    for (const n of nodes) {
      out.push(n);
      if (n.children?.length) walk(n.children);
    }
  };
  walk(roots);
  return out;
}

function pathLabel(cat: Category, byId: Map<string, Category>): string {
  const parts: string[] = [];
  let cur: Category | undefined = cat;
  const seen = new Set<string>();
  while (cur && !seen.has(cur.id)) {
    seen.add(cur.id);
    parts.unshift(cur.name);
    cur = cur.parentId ? byId.get(cur.parentId) : undefined;
  }
  return parts.join(' › ');
}

/** Options for SearchableSelect / filters: searchable full path, grouped by parent name. */
export function categoryOptionsForSelect(flat: Category[]): Array<{
  value: string;
  label: string;
  group?: string;
}> {
  const byId = new Map(flat.map((c) => [c.id, c]));
  return flat
    .slice()
    .sort((a, b) => pathLabel(a, byId).localeCompare(pathLabel(b, byId)))
    .map((c) => {
      const parent = c.parentId ? byId.get(c.parentId) : undefined;
      return {
        value: c.id,
        label: pathLabel(c, byId),
        group: parent?.name || 'Top level',
      };
    });
}

/** Native `<select>` options: value + single visible label (path). */
export function categoryNativeOptions(flat: Category[]): Array<{ value: string; label: string }> {
  const byId = new Map(flat.map((c) => [c.id, c]));
  return flat
    .slice()
    .sort((a, b) => pathLabel(a, byId).localeCompare(pathLabel(b, byId)))
    .map((c) => ({ value: c.id, label: pathLabel(c, byId) }));
}
