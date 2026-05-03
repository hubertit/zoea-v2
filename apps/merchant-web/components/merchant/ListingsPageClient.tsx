"use client";

import { useState } from "react";
import Link from "next/link";
import { LayoutList, ListPlus, Star } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { listingTypeIcon, priceUnitLabel } from "@/lib/merchant/labels";
import { listingSubtitle } from "@/lib/merchant/listing-subtitle";
import { formatMoney } from "@/lib/merchant/format";
import { MerchantEmptyState } from "@/components/merchant/MerchantEmptyState";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";
import type { Listing } from "@/lib/types/merchant";

function ListingCard({ listing }: { listing: Listing }) {
  const [imgOk, setImgOk] = useState(true);
  const thumb = listing.images[0];
  return (
    <Link
      href={`/listings/${listing.id}`}
      className="flex overflow-hidden rounded-xl border border-[var(--color-border)] bg-white shadow-sm transition hover:border-primary/30 hover:shadow-md"
    >
      <div className="relative flex w-24 shrink-0 items-center justify-center bg-primary/10 sm:w-28">
        {thumb && imgOk ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={thumb}
            alt=""
            className="size-full object-cover"
            loading="lazy"
            referrerPolicy="no-referrer"
            onError={() => setImgOk(false)}
          />
        ) : (
          <span className="text-3xl" aria-hidden>
            {listingTypeIcon(listing.type)}
          </span>
        )}
      </div>
      <div className="min-w-0 flex-1 p-3 sm:p-4">
        <div className="flex items-start justify-between gap-2">
          <h3 className="truncate font-semibold text-[var(--foreground)]">{listing.name}</h3>
          <span
            className={`shrink-0 rounded-md px-2 py-0.5 text-[10px] font-semibold ${
              listing.isActive ? "bg-success/15 text-success" : "bg-gray-100 text-muted"
            }`}
          >
            {listing.isActive ? "Active" : "Inactive"}
          </span>
        </div>
        <p className="mt-1 line-clamp-1 text-xs text-muted sm:text-sm">{listingSubtitle(listing)}</p>
        <p className="mt-2 text-sm">
          <span className="font-bold text-primary">
            {formatMoney(listing.priceRange.minPrice, listing.priceRange.currency)}
          </span>
          <span className="text-xs text-muted"> {listing.priceRange.minPrice !== listing.priceRange.maxPrice ? `– ${listing.priceRange.maxPrice}` : ""}</span>
          <span className="text-xs text-muted"> {priceUnitLabel(listing.priceRange.unit)}</span>
        </p>
        <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted">
          {listing.rating > 0 ? (
            <span className="inline-flex items-center gap-0.5 font-semibold text-amber-600">
              <Star className="size-3.5 fill-amber-400 text-amber-400" />
              {listing.rating.toFixed(1)}
            </span>
          ) : null}
          <span>{listing.bookingsCount} bookings</span>
        </div>
      </div>
    </Link>
  );
}

export function ListingsPageClient() {
  const listings = useMerchantDemoStore((s) => s.listings);
  const propertyListings = listings.filter((l) => l.type !== "room");

  return (
    <div>
      <MerchantPageHeader
        title="My Listings"
        action={{ href: "/listings/new", label: "Add listing", icon: <ListPlus className="size-4" /> }}
      />
      {propertyListings.length === 0 ? (
        <MerchantEmptyState
          icon={<LayoutList className="size-12 text-primary" />}
          title="No Listings Yet"
          description={"Create listings for your business\n(Rooms are managed separately in the Rooms section)"}
          actionHref="/listings/new"
          actionLabel="Create Listing"
        />
      ) : (
        <div className="flex flex-col gap-3">
          {propertyListings.map((l) => (
            <ListingCard key={l.id} listing={l} />
          ))}
        </div>
      )}
    </div>
  );
}
