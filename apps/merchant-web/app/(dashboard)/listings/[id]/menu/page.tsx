import type { Metadata } from "next";
import { ListingMenuPageClient } from "@/components/merchant/listing/ListingMenuPageClient";

export const metadata: Metadata = { title: "Listing Menu" };

export default async function ListingMenuPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <ListingMenuPageClient listingId={id} />;
}

