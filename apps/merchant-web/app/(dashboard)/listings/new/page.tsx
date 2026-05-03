import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "New Listing" };

export default function NewListingPage() {
  return <ListingFormPageClient key="new" />;
}
