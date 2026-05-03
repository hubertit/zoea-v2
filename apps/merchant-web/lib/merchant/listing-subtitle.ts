import { listingTypeLabel, roomTypeLabel, tableLocationLabel, tourDifficultyLabel } from "@/lib/merchant/labels";
import type { Listing } from "@/lib/types/merchant";

/** Mirrors `_getListingSubtitle` in `merchant-mobile` listings_screen. */
export function listingSubtitle(listing: Listing): string {
  switch (listing.type) {
    case "room": {
      const d = listing.roomDetails;
      if (d) return `${roomTypeLabel(d.roomType)} • ${d.capacity} guests`;
      return listingTypeLabel(listing.type);
    }
    case "table": {
      const d = listing.tableDetails;
      if (d) return `${tableLocationLabel(d.location)} • ${d.capacity} seats`;
      return listingTypeLabel(listing.type);
    }
    case "tour": {
      const d = listing.tourDetails;
      if (d) return `${d.duration} • ${tourDifficultyLabel(d.difficulty)}`;
      return listingTypeLabel(listing.type);
    }
    case "event": {
      const d = listing.eventDetails;
      if (d) return `${d.availableSpots} spots available`;
      return listingTypeLabel(listing.type);
    }
    default:
      return listingTypeLabel(listing.type);
  }
}
