import type { Metadata } from "next";
import { ListingReviewsPageClient } from "@/components/merchant/listing/ListingReviewsPageClient";

export const metadata: Metadata = { title: "Listing Reviews" };

export default async function ListingReviewsPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <ListingReviewsPageClient listingId={id} />;
}

