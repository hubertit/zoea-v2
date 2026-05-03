import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "Edit Listing" };

export default async function EditListingPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <ListingFormPageClient key={id} listingId={id} />;
}
