"use client";

import { useMemo } from "react";
import Link from "next/link";
import { BedDouble, ListPlus } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { formatMoney } from "@/lib/merchant/format";
import { listingSubtitle } from "@/lib/merchant/listing-subtitle";
import { roomTypeLabel } from "@/lib/merchant/labels";
import { MerchantEmptyState } from "@/components/merchant/MerchantEmptyState";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";
import type { Listing } from "@/lib/types/merchant";

function RoomCard({ listing }: { listing: Listing }) {
  const d = listing.roomDetails;
  const thumb = listing.images[0];
  const availability = d ? `${d.availableRooms}/${d.totalRooms} available` : "Room details missing";

  return (
    <Link
      href={`/rooms/${listing.id}`}
      className="flex overflow-hidden rounded-xl border border-[var(--color-border)] bg-white shadow-sm transition hover:border-primary/30 hover:shadow-md"
    >
      <div className="relative flex w-24 shrink-0 items-center justify-center bg-primary/10 sm:w-28">
        {thumb ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={thumb} alt="" className="size-full object-cover" />
        ) : (
          <span className="text-3xl" aria-hidden>
            🛏️
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
        <p className="mt-1 line-clamp-1 text-xs text-muted sm:text-sm">
          {d ? roomTypeLabel(d.roomType) : listingSubtitle(listing)}
        </p>
        <div className="mt-2 flex flex-wrap items-end justify-between gap-2">
          <p className="text-sm">
            <span className="font-bold text-primary">
              {formatMoney(listing.priceRange.minPrice, listing.priceRange.currency)}
            </span>
            <span className="text-xs text-muted"> per night</span>
          </p>
          <span className="text-xs font-semibold text-muted">{availability}</span>
        </div>
      </div>
    </Link>
  );
}

export function RoomsPageClient() {
  const listings = useMerchantDemoStore((s) => s.listings);
  const rooms = useMemo(() => listings.filter((l) => l.type === "room"), [listings]);

  return (
    <div>
      <MerchantPageHeader
        title="Rooms"
        action={{ href: "/rooms/new", label: "Add room", icon: <ListPlus className="size-4" /> }}
      />

      {rooms.length === 0 ? (
        <MerchantEmptyState
          icon={<BedDouble className="size-12 text-primary" />}
          title="No Rooms Yet"
          description={"Add rooms for your accommodation listings\nto start receiving bookings"}
          actionHref="/rooms/new"
          actionLabel="Create Room"
        />
      ) : (
        <div className="flex flex-col gap-3">
          {rooms.map((l) => (
            <RoomCard key={l.id} listing={l} />
          ))}
        </div>
      )}
    </div>
  );
}

