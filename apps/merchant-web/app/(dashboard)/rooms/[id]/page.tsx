import type { Metadata } from "next";
import { ListingFormPageClient } from "@/components/merchant/ListingFormPageClient";

export const metadata: Metadata = { title: "Edit Room" };

export default async function EditRoomPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <ListingFormPageClient
      key={id}
      listingId={id}
      forcedType="room"
      allowedTypes={["room"]}
      backHref="/rooms"
      titleOverride="Edit Room"
    />
  );
}

