import type { Metadata } from "next";
import { ListingGalleryPageClient } from "@/components/merchant/listing/ListingGalleryPageClient";

export const metadata: Metadata = { title: "Listing Gallery" };

export default async function ListingGalleryPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <ListingGalleryPageClient listingId={id} />;
}

