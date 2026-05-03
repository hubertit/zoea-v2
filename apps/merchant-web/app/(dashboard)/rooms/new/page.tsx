import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "New Room" };

export default function NewRoomPage() {
  return (
    <ListingFormPageClient
      key="new-room"
      forcedType="room"
      allowedTypes={["room"]}
      backHref="/rooms"
      titleOverride="New Room"
    />
  );
}

