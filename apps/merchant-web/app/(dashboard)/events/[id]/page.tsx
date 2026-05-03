import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "Edit Event" };

export default async function EditEventPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <ListingFormPageClient
      key={id}
      listingId={id}
      forcedType="event"
      allowedTypes={["event"]}
      backHref="/events"
      titleOverride="Edit Event"
    />
  );
}

