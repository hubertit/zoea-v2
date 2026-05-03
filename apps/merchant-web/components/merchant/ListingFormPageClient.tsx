"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ImageIcon, MessageSquareText, NotebookText, X } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { businessCategoryIcon, listingTypeLabel, priceUnitLabel } from "@/lib/merchant/labels";
import { suggestedPriceUnit, typeSpecificSlice } from "@/lib/merchant/listing-defaults";
import type { Listing, ListingType, PriceUnit } from "@/lib/types/merchant";

const AMENITIES = ["WiFi", "AC", "TV", "Mini Bar", "Parking", "Pool", "Gym", "Breakfast", "Room Service", "Balcony"];

const LISTING_TYPES: ListingType[] = ["room", "table", "tour", "event", "activity", "package"];

const PRICE_UNITS: PriceUnit[] = ["perNight", "perPerson", "perTable", "perTour", "perTicket", "perHour"];

export function ListingFormPageClient({
  listingId,
  forcedType,
  allowedTypes,
  backHref,
  titleOverride,
}: {
  listingId?: string;
  forcedType?: ListingType;
  allowedTypes?: ListingType[];
  backHref?: string;
  titleOverride?: string;
}) {
  const router = useRouter();
  const businesses = useMerchantDemoStore((s) => s.businesses);
  const listings = useMerchantDemoStore((s) => s.listings);
  const upsertListing = useMerchantDemoStore((s) => s.upsertListing);
  const isEditing = Boolean(listingId);

  const existing = useMemo(
    () => (listingId ? listings.find((l) => l.id === listingId) : undefined),
    [listingId, listings],
  );

  const effectiveBackHref = backHref ?? "/listings";
  const effectiveAllowedTypes = allowedTypes && allowedTypes.length > 0 ? allowedTypes : LISTING_TYPES;

  const typeLocked = Boolean(forcedType) || effectiveAllowedTypes.length === 1;
  const lockedType = forcedType ?? effectiveAllowedTypes[0];

  const [businessId, setBusinessId] = useState(() => existing?.businessId ?? "");
  const [name, setName] = useState(() => existing?.name ?? "");
  const [description, setDescription] = useState(() => existing?.description ?? "");
  const [type, setType] = useState<ListingType>(() => forcedType ?? existing?.type ?? lockedType ?? "room");
  const [minPrice, setMinPrice] = useState(() => String(existing?.priceRange.minPrice ?? "0"));
  const [maxPrice, setMaxPrice] = useState(() => String(existing?.priceRange.maxPrice ?? "0"));
  const [currency, setCurrency] = useState(() => existing?.priceRange.currency ?? "RWF");
  const [unit, setUnit] = useState<PriceUnit>(() => existing?.priceRange.unit ?? "perNight");
  const [amenities, setAmenities] = useState<string[]>(() => (existing ? [...existing.amenities] : []));
  const [isActive, setIsActive] = useState(() => existing?.isActive ?? true);
  const [saving, setSaving] = useState(false);

  const effectiveBusinessId = businessId || businesses[0]?.id || "";

  const toggleAmenity = (a: string) => {
    setAmenities((prev) => (prev.includes(a) ? prev.filter((x) => x !== a) : [...prev, a]));
  };

  const handleSave = () => {
    if (!name.trim() || !description.trim() || !effectiveBusinessId) return;
    const min = Number(minPrice) || 0;
    const max = Number(maxPrice) || min;
    setSaving(true);
    const now = new Date().toISOString();
    const id = existing?.id ?? (typeof crypto !== "undefined" ? crypto.randomUUID() : `l-${Date.now()}`);
    const slice = type === existing?.type && existing ? pickTypeSlice(existing) : typeSpecificSlice(type);
    const next: Listing = {
      id,
      businessId: effectiveBusinessId,
      name: name.trim(),
      description: description.trim(),
      type,
      images: existing?.images ?? [],
      priceRange: { minPrice: min, maxPrice: Math.max(min, max), currency: currency.trim() || "RWF", unit },
      amenities,
      tags: existing?.tags ?? [],
      isActive,
      isFeatured: existing?.isFeatured ?? false,
      rating: existing?.rating ?? 0,
      reviewCount: existing?.reviewCount ?? 0,
      bookingsCount: existing?.bookingsCount ?? 0,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      ...slice,
    };
    upsertListing(next);
    queueMicrotask(() => {
      setSaving(false);
      router.push(effectiveBackHref);
    });
  };

  if (isEditing && listingId && !existing) {
    return (
      <div className="rounded-2xl border border-[var(--color-border)] bg-white p-8 text-center shadow-sm">
        <p className="mb-4 text-muted">Listing not found.</p>
        <Link href={effectiveBackHref} className="text-sm font-semibold text-primary underline">
          Back
        </Link>
      </div>
    );
  }

  if (isEditing && existing && forcedType && existing.type !== forcedType) {
    return (
      <div className="rounded-2xl border border-[var(--color-border)] bg-white p-8 text-center shadow-sm">
        <p className="mb-4 text-muted">This item isn’t a {listingTypeLabel(forcedType).toLowerCase()} listing.</p>
        <Link href={effectiveBackHref} className="text-sm font-semibold text-primary underline">
          Back
        </Link>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl">
      <div className="mb-6 flex items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <Link
            href={effectiveBackHref}
            className="flex size-10 items-center justify-center rounded-xl border border-[var(--color-border)] text-muted transition hover:bg-gray-50"
            aria-label="Close"
          >
            <X className="size-5" />
          </Link>
          <h1 className="text-xl font-bold sm:text-2xl">
            {titleOverride ?? (isEditing ? "Edit Listing" : "New Listing")}
          </h1>
        </div>
        <button type="button" className="btn btn-primary rounded-lg px-4 py-2 text-sm font-semibold" disabled={saving} onClick={handleSave}>
          {saving ? "Saving…" : "Save"}
        </button>
      </div>

      {listingId ? (
        <div className="mb-6 flex flex-wrap items-center gap-2">
          <Link
            href={`/listings/${listingId}/menu`}
            className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-semibold text-gray-700 shadow-sm hover:bg-gray-50"
          >
            <NotebookText className="size-4" />
            Menu
          </Link>
          <Link
            href={`/listings/${listingId}/reviews`}
            className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-semibold text-gray-700 shadow-sm hover:bg-gray-50"
          >
            <MessageSquareText className="size-4" />
            Reviews
          </Link>
          <Link
            href={`/listings/${listingId}/gallery`}
            className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-semibold text-gray-700 shadow-sm hover:bg-gray-50"
          >
            <ImageIcon className="size-4" />
            Gallery
          </Link>
          <span className="text-xs text-muted">Merchant tools (demo) — API wiring next.</span>
        </div>
      ) : null}

      <div className="space-y-8 rounded-2xl border border-[var(--color-border)] bg-white p-6 shadow-sm">
        <section>
          <h2 className="mb-3 text-base font-bold">Select Business</h2>
          <select
            className="w-full rounded-xl border border-[var(--color-border)] px-4 py-3 text-sm outline-none focus:border-primary"
            value={effectiveBusinessId}
            onChange={(e) => setBusinessId(e.target.value)}
          >
            {businesses.length === 0 ? (
              <option value="">No businesses — create one first</option>
            ) : (
              businesses.map((b) => (
                <option key={b.id} value={b.id}>
                  {businessCategoryIcon(b.category)} {b.name}
                </option>
              ))
            )}
          </select>
        </section>

        <section>
          <h2 className="mb-4 text-base font-bold">Listing Information</h2>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Listing Name</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., Deluxe Room, Family Table"
            />
          </label>
          <p className="mb-2 text-sm text-muted">Type</p>
          {typeLocked ? (
            <div className="mb-4 inline-flex items-center gap-2 rounded-xl border border-[var(--color-border)] bg-gray-50 px-4 py-3 text-sm font-semibold text-[var(--foreground)]">
              {listingTypeLabel(type)}
              <span className="text-xs font-medium text-muted">(locked)</span>
            </div>
          ) : (
            <div className="mb-4 flex flex-wrap gap-2">
              {effectiveAllowedTypes.map((t) => (
                <button
                  key={t}
                  type="button"
                  onClick={() => {
                    setType(t);
                    setUnit(suggestedPriceUnit(t));
                  }}
                  className={`rounded-xl border px-3 py-2 text-sm font-medium transition ${
                    type === t ? "border-primary bg-primary text-white" : "border-[var(--color-border)] hover:bg-gray-50"
                  }`}
                >
                  {listingTypeLabel(t)}
                </button>
              ))}
            </div>
          )}
          <label className="block">
            <span className="mb-1 block text-sm text-muted">Description</span>
            <textarea
              className="min-h-[88px] w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
            />
          </label>
        </section>

        <section>
          <h2 className="mb-4 text-base font-bold">Pricing</h2>
          <div className="mb-4 grid gap-4 sm:grid-cols-2">
            <label className="block">
              <span className="mb-1 block text-sm text-muted">Min price</span>
              <input
                inputMode="decimal"
                className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
                value={minPrice}
                onChange={(e) => setMinPrice(e.target.value)}
              />
            </label>
            <label className="block">
              <span className="mb-1 block text-sm text-muted">Max price</span>
              <input
                inputMode="decimal"
                className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
                value={maxPrice}
                onChange={(e) => setMaxPrice(e.target.value)}
              />
            </label>
          </div>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Currency</span>
            <input
              className="w-full max-w-xs rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={currency}
              onChange={(e) => setCurrency(e.target.value)}
            />
          </label>
          <p className="mb-2 text-sm text-muted">Price unit</p>
          <div className="flex flex-wrap gap-2">
            {PRICE_UNITS.map((u) => (
              <button
                key={u}
                type="button"
                onClick={() => setUnit(u)}
                className={`rounded-xl border px-3 py-2 text-xs font-medium sm:text-sm ${
                  unit === u ? "border-primary bg-primary text-white" : "border-[var(--color-border)] hover:bg-gray-50"
                }`}
              >
                {priceUnitLabel(u)}
              </button>
            ))}
          </div>
        </section>

        <section>
          <h2 className="mb-3 text-base font-bold">Amenities</h2>
          <div className="flex flex-wrap gap-2">
            {AMENITIES.map((a) => (
              <button
                key={a}
                type="button"
                onClick={() => toggleAmenity(a)}
                className={`rounded-lg border px-3 py-1.5 text-sm ${
                  amenities.includes(a) ? "border-primary bg-primary/10 font-semibold text-primary" : "border-[var(--color-border)] text-muted"
                }`}
              >
                {a}
              </button>
            ))}
          </div>
        </section>

        <label className="flex cursor-pointer items-center gap-3">
          <input type="checkbox" className="size-4 rounded border-gray-300" checked={isActive} onChange={(e) => setIsActive(e.target.checked)} />
          <span className="text-sm font-medium">Listing is active</span>
        </label>
      </div>
    </div>
  );
}

function pickTypeSlice(listing: Listing): Pick<Listing, "roomDetails" | "tableDetails" | "tourDetails" | "eventDetails"> {
  return {
    roomDetails: listing.roomDetails,
    tableDetails: listing.tableDetails,
    tourDetails: listing.tourDetails,
    eventDetails: listing.eventDetails,
  };
}
