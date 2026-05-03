"use client";

import { useMemo, useState } from "react";
import { ImageIcon, Plus, Trash2 } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { ListingManageShell } from "@/components/merchant/listing/ListingManageShell";

function isValidHttpUrl(s: string): boolean {
  try {
    const u = new URL(s);
    return u.protocol === "http:" || u.protocol === "https:";
  } catch {
    return false;
  }
}

export function ListingGalleryPageClient({ listingId }: { listingId: string }) {
  const listing = useMerchantDemoStore((s) => s.listings.find((l) => l.id === listingId));
  const upsert = useMerchantDemoStore((s) => s.upsertListing);
  const [newUrl, setNewUrl] = useState("");

  const images = listing?.images ?? [];

  const canAdd = useMemo(() => isValidHttpUrl(newUrl.trim()), [newUrl]);

  if (!listing) {
    return (
      <ListingManageShell listingId={listingId} title="Gallery">
        <p className="text-sm text-muted">Listing not found.</p>
      </ListingManageShell>
    );
  }

  const handleAdd = () => {
    const url = newUrl.trim();
    if (!isValidHttpUrl(url)) return;
    const next = { ...listing, images: [...images, url], updatedAt: new Date().toISOString() };
    upsert(next);
    setNewUrl("");
  };

  const handleRemove = (idx: number) => {
    const nextImages = images.filter((_, i) => i !== idx);
    upsert({ ...listing, images: nextImages, updatedAt: new Date().toISOString() });
  };

  return (
    <ListingManageShell listingId={listingId} title="Gallery">
      <div className="flex flex-col gap-4">
        <div className="rounded-xl border border-[var(--color-border)] bg-gray-50 p-4">
          <p className="text-sm font-semibold text-[var(--foreground)]">Add image URL</p>
          <p className="mt-1 text-xs text-muted">Demo-only: paste an HTTPS image URL. Later we’ll switch to uploads.</p>
          <div className="mt-3 flex flex-col gap-2 sm:flex-row">
            <input
              className="w-full flex-1 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={newUrl}
              onChange={(e) => setNewUrl(e.target.value)}
              placeholder="https://…"
            />
            <button
              type="button"
              disabled={!canAdd}
              onClick={handleAdd}
              className="inline-flex items-center justify-center gap-2 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-60"
            >
              <Plus className="size-4" />
              Add
            </button>
          </div>
        </div>

        {images.length === 0 ? (
          <div className="flex min-h-[240px] flex-col items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white py-12 text-center text-muted">
            <ImageIcon className="mb-3 size-12 opacity-40" />
            <p className="text-sm font-semibold text-[var(--foreground)]">No images yet</p>
            <p className="mt-1 max-w-sm text-sm text-muted">Add photos to help customers understand what they’re booking.</p>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
            {images.map((src, idx) => (
              <div key={`${src}-${idx}`} className="group relative overflow-hidden rounded-xl border border-[var(--color-border)] bg-white">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={src} alt="" className="aspect-square w-full object-cover" />
                <button
                  type="button"
                  onClick={() => handleRemove(idx)}
                  className="absolute right-2 top-2 hidden items-center gap-1 rounded-lg bg-white/95 px-2 py-1 text-xs font-semibold text-gray-700 shadow-sm hover:bg-white group-hover:inline-flex"
                  title="Remove"
                >
                  <Trash2 className="size-3.5" />
                  Remove
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </ListingManageShell>
  );
}

