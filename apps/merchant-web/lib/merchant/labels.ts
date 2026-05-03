import type {
  BookingStatus,
  BookingType,
  BusinessCategory,
  ListingType,
  PaymentMethod,
  PaymentStatus,
  PriceUnit,
} from "@/lib/types/merchant";

const bookingTypeIcons: Record<BookingType, string> = {
  accommodation: "🏨",
  dining: "🍽️",
  tour: "🗺️",
  event: "🎫",
};

export function bookingTypeIcon(type: BookingType): string {
  return bookingTypeIcons[type];
}

export function bookingTypeLabel(type: BookingType): string {
  switch (type) {
    case "accommodation":
      return "Accommodation";
    case "dining":
      return "Dining";
    case "tour":
      return "Tour";
    case "event":
      return "Event";
  }
}

/** Filter sheet uses boot emoji for tours (matches mobile bottom sheet). */
export function bookingTypeFilterIcon(type: BookingType): string {
  return type === "tour" ? "🥾" : bookingTypeIcon(type);
}

export function bookingStatusLabel(status: BookingStatus): string {
  switch (status) {
    case "pending":
      return "Pending";
    case "confirmed":
      return "Confirmed";
    case "checkedIn":
      return "Checked In";
    case "completed":
      return "Completed";
    case "cancelled":
      return "Cancelled";
    case "noShow":
      return "No Show";
  }
}

export function paymentMethodLabel(m: PaymentMethod): string {
  switch (m) {
    case "zoeaCard":
      return "Zoea Card";
    case "momo":
      return "Mobile Money";
    case "bankTransfer":
      return "Bank Transfer";
    case "cash":
      return "Cash";
    case "card":
      return "Card";
  }
}

export function paymentStatusLabel(s: PaymentStatus): string {
  switch (s) {
    case "pending":
      return "Pending";
    case "paid":
      return "Paid";
    case "partiallyPaid":
      return "Partially Paid";
    case "refunded":
      return "Refunded";
    case "failed":
      return "Failed";
  }
}

export function businessCategoryLabel(c: BusinessCategory): string {
  switch (c) {
    case "hotel":
      return "Hotel & Accommodation";
    case "restaurant":
      return "Restaurant & Dining";
    case "tourOperator":
      return "Tour Operator";
    case "eventVenue":
      return "Event Venue";
    case "attraction":
      return "Attraction";
    case "transportation":
      return "Transportation";
    case "other":
      return "Other";
  }
}

export function businessCategoryIcon(c: BusinessCategory): string {
  switch (c) {
    case "hotel":
      return "🏨";
    case "restaurant":
      return "🍽️";
    case "tourOperator":
      return "🗺️";
    case "eventVenue":
      return "🎪";
    case "attraction":
      return "🎢";
    case "transportation":
      return "🚐";
    case "other":
      return "📦";
  }
}

export function listingTypeLabel(t: ListingType): string {
  switch (t) {
    case "room":
      return "Room";
    case "table":
      return "Table";
    case "tour":
      return "Tour";
    case "event":
      return "Event";
    case "activity":
      return "Activity";
    case "package":
      return "Package";
  }
}

export function listingTypeIcon(t: ListingType): string {
  switch (t) {
    case "room":
      return "🛏️";
    case "table":
      return "🍽️";
    case "tour":
      return "🗺️";
    case "event":
      return "🎫";
    case "activity":
      return "🎯";
    case "package":
      return "📦";
  }
}

export function priceUnitLabel(u: PriceUnit): string {
  switch (u) {
    case "perNight":
      return "per night";
    case "perPerson":
      return "per person";
    case "perTable":
      return "per table";
    case "perTour":
      return "per tour";
    case "perTicket":
      return "per ticket";
    case "perHour":
      return "per hour";
  }
}

export function roomTypeLabel(rt: import("@/lib/types/merchant").RoomType): string {
  switch (rt) {
    case "standard":
      return "Standard Room";
    case "deluxe":
      return "Deluxe Room";
    case "suite":
      return "Suite";
    case "executive":
      return "Executive Room";
    case "presidential":
      return "Presidential Suite";
    case "family":
      return "Family Room";
    case "single":
      return "Single Room";
    case "twin":
      return "Twin Room";
  }
}

export function tableLocationLabel(loc: import("@/lib/types/merchant").TableLocation): string {
  switch (loc) {
    case "indoor":
      return "Indoor";
    case "outdoor":
      return "Outdoor";
    case "terrace":
      return "Terrace";
    case "rooftop":
      return "Rooftop";
    case "privateRoom":
      return "Private Room";
    case "poolside":
      return "Poolside";
  }
}

export function tourDifficultyLabel(d: import("@/lib/types/merchant").TourDifficulty): string {
  switch (d) {
    case "easy":
      return "Easy";
    case "moderate":
      return "Moderate";
    case "challenging":
      return "Challenging";
    case "difficult":
      return "Difficult";
  }
}
