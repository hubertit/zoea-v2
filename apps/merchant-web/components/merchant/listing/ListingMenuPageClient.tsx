"use client";

import { useMemo, useState } from "react";
import { Minus, NotebookText, Plus, Trash2 } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { formatMoney } from "@/lib/merchant/format";
import { ListingManageShell } from "@/components/merchant/listing/ListingManageShell";
import type { Listing } from "@/lib/types/merchant";

type MenuItem = {
  id: string;
  name: string;
  price: number;
  currency: string;
  description?: string;
  available: boolean;
};

function seedMenu(listing: Listing): MenuItem[] {
  const currency = listing.priceRange.currency || "RWF";
  // deterministic seed based on listing id
  const k = listing.id.length % 3;
  if (k === 0) return [];
  return [
    {
      id: `${listing.id}-m-1`,
      name: "Grilled Tilapia",
      price: 8500,
      currency,
      description: "Served with fries or plantain.",
      available: true,
    },
    {
      id: `${listing.id}-m-2`,
      name: "Chicken Brochettes",
      price: 6500,
      currency,
      description: "Skewers with house sauce.",
      available: true,
    },
    {
      id: `${listing.id}-m-3`,
      name: "Fresh Juice",
      price: 2000,
      currency,
      available: false,
    },
  ];
}

export function ListingMenuPageClient({ listingId }: { listingId: string }) {
  const listing = useMerchantDemoStore((s) => s.listings.find((l) => l.id === listingId));
  const [items, setItems] = useState<MenuItem[]>(() => (listing ? seedMenu(listing) : []));

  const [name, setName] = useState("");
  const [price, setPrice] = useState("");

  const currency = listing?.priceRange.currency ?? "RWF";
  const isRestaurantLike = listing?.type === "table";

  const canAdd = useMemo(() => name.trim().length > 1 && (Number(price) || 0) > 0, [name, price]);

  if (!listing) {
    return (
      <ListingManageShell listingId={listingId} title="Menu">
        <p className="text-sm text-muted">Listing not found.</p>
      </ListingManageShell>
    );
  }

  return (
    <ListingManageShell listingId={listingId} title="Menu">
      <div className="flex flex-col gap-4">
        {!isRestaurantLike ? (
          <div className="rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
            <p className="font-semibold">Menu is typically for dining listings.</p>
            <p className="mt-1 text-xs text-amber-900/80">
              This listing is a <span className="font-semibold">{listing.type}</span>. You can still draft menu items in the portal (demo),
              but we’ll likely scope menus to restaurants when the API is wired.
            </p>
          </div>
        ) : null}

        <div className="rounded-xl border border-[var(--color-border)] bg-gray-50 p-4">
          <div className="flex items-center gap-2">
            <NotebookText className="size-5 text-primary" />
            <p className="text-sm font-semibold text-[var(--foreground)]">Add menu item</p>
          </div>
          <div className="mt-3 grid gap-3 sm:grid-cols-[1fr_180px_auto]">
            <input
              className="w-full rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Item name"
            />
            <input
              inputMode="decimal"
              className="w-full rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              placeholder={`Price (${currency})`}
            />
            <button
              type="button"
              disabled={!canAdd}
              onClick={() => {
                const p = Number(price) || 0;
                if (!name.trim() || p <= 0) return;
                setItems((prev) => [
                  {
                    id: typeof crypto !== "undefined" ? crypto.randomUUID() : `m-${Date.now()}`,
                    name: name.trim(),
                    price: p,
                    currency,
                    available: true,
                  },
                  ...prev,
                ]);
                setName("");
                setPrice("");
              }}
              className="inline-flex items-center justify-center gap-2 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-60"
            >
              <Plus className="size-4" />
              Add
            </button>
          </div>
          <p className="mt-2 text-xs text-muted">Demo-only UI — next step is persisting menu items via merchant API.</p>
        </div>

        {items.length === 0 ? (
          <div className="flex min-h-[240px] flex-col items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white py-12 text-center text-muted">
            <NotebookText className="mb-3 size-12 opacity-40" />
            <p className="text-sm font-semibold text-[var(--foreground)]">No menu items yet</p>
            <p className="mt-1 max-w-sm text-sm text-muted">Add dishes, drinks, and pricing so customers know what to expect.</p>
          </div>
        ) : (
          <div className="overflow-hidden rounded-2xl border border-[var(--color-border)] bg-white shadow-sm">
            <ul className="divide-y divide-[var(--color-border)]">
              {items.map((it) => (
                <li key={it.id} className="flex flex-wrap items-center justify-between gap-3 px-4 py-3">
                  <div className="min-w-0">
                    <p className="truncate text-sm font-semibold text-[var(--foreground)]">{it.name}</p>
                    {it.description ? <p className="truncate text-xs text-muted">{it.description}</p> : null}
                  </div>
                  <div className="ml-auto flex items-center gap-2">
                    <span className="text-sm font-bold tabular-nums text-primary">{formatMoney(it.price, it.currency)}</span>
                    <button
                      type="button"
                      onClick={() =>
                        setItems((prev) =>
                          prev.map((x) => (x.id === it.id ? { ...x, available: !x.available } : x)),
                        )
                      }
                      className={`inline-flex items-center gap-1 rounded-lg border px-2.5 py-1.5 text-xs font-semibold ${
                        it.available ? "border-emerald-200 bg-emerald-50 text-emerald-800" : "border-gray-200 bg-gray-50 text-gray-700"
                      }`}
                      title="Toggle availability"
                    >
                      {it.available ? <Minus className="size-3.5" /> : <Plus className="size-3.5" />}
                      {it.available ? "Available" : "Unavailable"}
                    </button>
                    <button
                      type="button"
                      onClick={() => setItems((prev) => prev.filter((x) => x.id !== it.id))}
                      className="inline-flex items-center gap-1 rounded-lg border border-[var(--color-border)] bg-white px-2.5 py-1.5 text-xs font-semibold text-gray-700 hover:bg-gray-50"
                      title="Delete"
                    >
                      <Trash2 className="size-3.5" />
                      Delete
                    </button>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </ListingManageShell>
  );
}

