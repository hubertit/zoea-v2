"use client";

import { useState } from "react";
import Link from "next/link";
import { Building2, MapPin, Star, Store } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { businessCategoryLabel } from "@/lib/merchant/labels";
import { MerchantEmptyState } from "@/components/merchant/MerchantEmptyState";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";
import type { Business } from "@/lib/types/merchant";

function BusinessCard({ business }: { business: Business }) {
  const [imgOk, setImgOk] = useState(true);
  const src = business.coverImage || business.logo || "";

  return (
    <Link
      href={`/businesses/${business.id}`}
      className="block overflow-hidden rounded-2xl border border-[var(--color-border)] bg-white shadow-sm transition hover:border-primary/30 hover:shadow-md"
    >
      <div className="relative h-36 bg-gradient-to-br from-primary/15 to-primary/5">
        {src && imgOk ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={src}
            alt=""
            className="size-full object-cover"
            loading="lazy"
            referrerPolicy="no-referrer"
            onError={() => setImgOk(false)}
          />
        ) : null}
        <div className="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/20 via-black/5 to-transparent" />
      </div>
      <div className="space-y-3 p-4">
        <div className="flex items-start justify-between gap-2">
          <h3 className="font-semibold text-[var(--foreground)]">{business.name}</h3>
          {business.isVerified ? (
            <span className="shrink-0 rounded-full bg-success/15 px-2 py-0.5 text-xs font-semibold text-success">Verified</span>
          ) : null}
        </div>
        <p className="line-clamp-2 text-sm text-muted">{business.description}</p>
        <div className="flex flex-wrap items-center gap-2 text-xs text-muted">
          <span className="rounded-md bg-gray-100 px-2 py-1 font-medium text-[var(--foreground)]">
            {businessCategoryLabel(business.category)}
          </span>
        </div>
        <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-muted">
          <span className="inline-flex items-center gap-1">
            <MapPin className="size-4 shrink-0" />
            {business.location.city}, {business.location.country}
          </span>
          {business.rating > 0 ? (
            <span className="inline-flex items-center gap-1 font-medium text-amber-600">
              <Star className="size-4 fill-amber-400 text-amber-400" />
              {business.rating.toFixed(1)}
              <span className="font-normal text-muted">({business.reviewCount})</span>
            </span>
          ) : null}
        </div>
        <div className="text-xs text-muted">{business.listingsCount} listings</div>
      </div>
    </Link>
  );
}

export function BusinessesPageClient() {
  const businesses = useMerchantDemoStore((s) => s.businesses);

  return (
    <div>
      <MerchantPageHeader
        title="My Businesses"
        action={{ href: "/businesses/new", label: "Add business", icon: <Building2 className="size-4" /> }}
      />
      {businesses.length === 0 ? (
        <MerchantEmptyState
          icon={<Store className="size-12 text-primary" />}
          title="No Businesses Yet"
          description={"Create your first business to start\nmanaging listings and bookings"}
          actionHref="/businesses/new"
          actionLabel="Create Business"
        />
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {businesses.map((b) => (
            <BusinessCard key={b.id} business={b} />
          ))}
        </div>
      )}
    </div>
  );
}
