"use client";

import { useMemo } from "react";
import { MessageSquareText, Star } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { ListingManageShell } from "@/components/merchant/listing/ListingManageShell";

type Review = {
  id: string;
  author: string;
  rating: number;
  message: string;
  createdAt: string;
};

function seedReviews(listingId: string): Review[] {
  const base: Review[] = [
    {
      id: `r-${listingId}-1`,
      author: "Aline N.",
      rating: 5,
      message: "Great experience. Clean, easy check-in, and friendly staff.",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 6).toISOString(),
    },
    {
      id: `r-${listingId}-2`,
      author: "Kevin M.",
      rating: 4,
      message: "Good value. Would book again.",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 18).toISOString(),
    },
  ];
  // deterministic “mock”: some listings have none
  return listingId.length % 2 === 0 ? base : [];
}

function Stars({ rating }: { rating: number }) {
  return (
    <span className="inline-flex items-center gap-0.5" aria-label={`${rating} out of 5`}>
      {Array.from({ length: 5 }).map((_, i) => (
        <Star
          key={i}
          className={`size-4 ${i < rating ? "fill-amber-400 text-amber-400" : "text-gray-300"}`}
        />
      ))}
    </span>
  );
}

export function ListingReviewsPageClient({ listingId }: { listingId: string }) {
  const listing = useMerchantDemoStore((s) => s.listings.find((l) => l.id === listingId));
  const reviews = useMemo(() => seedReviews(listingId), [listingId]);

  const avg = useMemo(() => {
    if (reviews.length === 0) return 0;
    return reviews.reduce((a, r) => a + r.rating, 0) / reviews.length;
  }, [reviews]);

  return (
    <ListingManageShell listingId={listingId} title="Reviews">
      {!listing ? (
        <p className="text-sm text-muted">Listing not found.</p>
      ) : (
        <div className="flex flex-col gap-4">
          <div className="rounded-xl border border-[var(--color-border)] bg-gray-50 p-4">
            <p className="text-sm font-semibold text-[var(--foreground)]">Summary</p>
            <div className="mt-2 flex flex-wrap items-center gap-3">
              <span className="text-2xl font-bold text-[var(--foreground)] tabular-nums">
                {avg ? avg.toFixed(1) : "—"}
              </span>
              <Stars rating={Math.round(avg)} />
              <span className="text-sm text-muted">{reviews.length} reviews (demo)</span>
            </div>
            <p className="mt-2 text-xs text-muted">
              Merchants can view feedback here and respond once the reviews API is connected.
            </p>
          </div>

          {reviews.length === 0 ? (
            <div className="flex min-h-[240px] flex-col items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white py-12 text-center text-muted">
              <MessageSquareText className="mb-3 size-12 opacity-40" />
              <p className="text-sm font-semibold text-[var(--foreground)]">No reviews yet</p>
              <p className="mt-1 max-w-sm text-sm text-muted">When customers leave feedback, it’ll show up here.</p>
            </div>
          ) : (
            <div className="flex flex-col gap-3">
              {reviews.map((r) => (
                <div key={r.id} className="rounded-2xl border border-[var(--color-border)] bg-white p-4 shadow-sm">
                  <div className="flex flex-wrap items-start justify-between gap-2">
                    <div>
                      <p className="text-sm font-bold text-[var(--foreground)]">{r.author}</p>
                      <p className="text-xs text-muted">{new Date(r.createdAt).toLocaleDateString()}</p>
                    </div>
                    <Stars rating={r.rating} />
                  </div>
                  <p className="mt-3 text-sm text-gray-700">{r.message}</p>
                  <div className="mt-4 flex flex-wrap gap-2">
                    <button
                      type="button"
                      disabled
                      className="rounded-lg border border-[var(--color-border)] bg-gray-50 px-3 py-2 text-sm font-semibold text-gray-400"
                      title="Coming soon"
                    >
                      Reply (soon)
                    </button>
                    <button
                      type="button"
                      disabled
                      className="rounded-lg border border-[var(--color-border)] bg-gray-50 px-3 py-2 text-sm font-semibold text-gray-400"
                      title="Coming soon"
                    >
                      Flag (soon)
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </ListingManageShell>
  );
}

