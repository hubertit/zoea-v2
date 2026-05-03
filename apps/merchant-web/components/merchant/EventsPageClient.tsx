"use client";

import { useMemo } from "react";
import Link from "next/link";
import { CalendarDays, ListPlus, Ticket } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { formatMoney, formatShortDate } from "@/lib/merchant/format";
import { MerchantEmptyState } from "@/components/merchant/MerchantEmptyState";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";
import type { Listing } from "@/lib/types/merchant";

function EventCard({ listing }: { listing: Listing }) {
  const d = listing.eventDetails;
  const thumb = listing.images[0];
  const when = d?.eventDate ? formatShortDate(d.eventDate) : "Date not set";
  const capacity = d ? `${d.availableSpots}/${d.totalCapacity} spots` : "Capacity not set";

  return (
    <Link
      href={`/events/${listing.id}`}
      className="flex overflow-hidden rounded-xl border border-[var(--color-border)] bg-white shadow-sm transition hover:border-primary/30 hover:shadow-md"
    >
      <div className="relative flex w-24 shrink-0 items-center justify-center bg-primary/10 sm:w-28">
        {thumb ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={thumb} alt="" className="size-full object-cover" />
        ) : (
          <span className="text-3xl" aria-hidden>
            🎫
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
            {listing.isActive ? "Live" : "Draft"}
          </span>
        </div>
        <div className="mt-2 flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted">
          <span className="inline-flex items-center gap-1">
            <CalendarDays className="size-3.5" />
            {when}
          </span>
          <span className="inline-flex items-center gap-1">
            <Ticket className="size-3.5" />
            {capacity}
          </span>
        </div>
        <p className="mt-2 text-sm">
          <span className="font-bold text-primary">
            {formatMoney(listing.priceRange.minPrice, listing.priceRange.currency)}
          </span>
          <span className="text-xs text-muted"> per ticket</span>
        </p>
      </div>
    </Link>
  );
}

export function EventsPageClient() {
  const listings = useMerchantDemoStore((s) => s.listings);
  const events = useMemo(() => listings.filter((l) => l.type === "event"), [listings]);

  return (
    <div>
      <MerchantPageHeader
        title="Events"
        action={{ href: "/events/new", label: "Add event", icon: <ListPlus className="size-4" /> }}
      />

      {events.length === 0 ? (
        <MerchantEmptyState
          icon={<CalendarDays className="size-12 text-primary" />}
          title="No Events Yet"
          description={"Create events and publish tickets\nright from your portal"}
          actionHref="/events/new"
          actionLabel="Create Event"
        />
      ) : (
        <div className="flex flex-col gap-3">
          {events.map((l) => (
            <EventCard key={l.id} listing={l} />
          ))}
        </div>
      )}
    </div>
  );
}

