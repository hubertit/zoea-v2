import type { Listing, ListingType, PriceUnit } from "@/lib/types/merchant";

export function suggestedPriceUnit(type: ListingType): PriceUnit {
  switch (type) {
    case "room":
      return "perNight";
    case "table":
      return "perTable";
    case "tour":
      return "perPerson";
    case "event":
      return "perTicket";
    case "activity":
      return "perHour";
    case "package":
      return "perTour";
  }
}

export function typeSpecificSlice(type: ListingType): Pick<Listing, "roomDetails" | "tableDetails" | "tourDetails" | "eventDetails"> {
  switch (type) {
    case "room":
      return {
        roomDetails: {
          roomType: "standard",
          capacity: 2,
          bedCount: 1,
          bedType: "queen",
          size: 22,
          hasBalcony: false,
          hasView: false,
          totalRooms: 1,
          availableRooms: 1,
        },
      };
    case "table":
      return {
        tableDetails: {
          capacity: 4,
          location: "indoor",
          totalTables: 4,
          availableTables: 4,
          availableTimeSlots: ["12:00", "13:00", "19:00", "20:00"],
        },
      };
    case "tour":
      return {
        tourDetails: {
          duration: "Half day",
          difficulty: "moderate",
          minParticipants: 1,
          maxParticipants: 10,
          included: [],
          notIncluded: [],
        },
      };
    case "event":
      return {
        eventDetails: {
          eventDate: new Date().toISOString(),
          totalCapacity: 100,
          availableSpots: 100,
          ticketTypes: [],
          isRecurring: false,
        },
      };
    default:
      return {};
  }
}
