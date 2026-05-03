import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "New Event" };

export default function NewEventPage() {
  return (
    <ListingFormPageClient
      key="new-event"
      forcedType="event"
      allowedTypes={["event"]}
      backHref="/events"
      titleOverride="New Event"
    />
  );
}

