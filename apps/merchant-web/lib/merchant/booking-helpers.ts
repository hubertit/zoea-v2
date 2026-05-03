import type { Booking, BookingType } from "@/lib/types/merchant";

export function bookingGuestCount(b: Booking): number {
  switch (b.type) {
    case "accommodation":
      return b.accommodationDetails?.guestCount ?? 1;
    case "dining":
      return b.diningDetails?.partySize ?? 1;
    case "tour":
      return b.tourDetails?.participants ?? 1;
    case "event":
      return b.eventDetails?.ticketCount ?? 1;
  }
}

export function bookingPrimaryDateIso(b: Booking): string {
  switch (b.type) {
    case "accommodation":
      return b.accommodationDetails?.checkInDate ?? b.createdAt;
    case "dining":
      return b.diningDetails?.reservationDate ?? b.createdAt;
    case "tour":
      return b.tourDetails?.tourDate ?? b.createdAt;
    case "event":
      return b.eventDetails?.eventDate ?? b.createdAt;
  }
}

export function bookingCardGuestLine(b: Booking): string {
  const n = bookingGuestCount(b);
  switch (b.type) {
    case "accommodation": {
      const nights = b.accommodationDetails?.nights ?? 1;
      return `${nights} night${nights === 1 ? "" : "s"}, ${n} guests`;
    }
    case "dining":
      return `${n} guests`;
    case "tour":
      return `${n} participants`;
    case "event":
      return `${n} tickets`;
  }
}

export function bookingGuestIconType(type: BookingType): "hotel" | "people" | "hiking" | "ticket" {
  switch (type) {
    case "accommodation":
      return "hotel";
    case "dining":
      return "people";
    case "tour":
      return "hiking";
    case "event":
      return "ticket";
  }
}
