/** Merchant domain types aligned with `merchant-mobile` models (mock-first). */

export type ISODateString = string;

export type BusinessCategory =
  | "hotel"
  | "restaurant"
  | "tourOperator"
  | "eventVenue"
  | "attraction"
  | "transportation"
  | "other";

export interface BusinessLocation {
  latitude: number;
  longitude: number;
  address: string;
  city: string;
  country: string;
  district?: string;
  sector?: string;
}

export interface BusinessContact {
  phone?: string;
  email?: string;
  website?: string;
  whatsapp?: string;
}

export interface Business {
  id: string;
  ownerId: string;
  name: string;
  description: string;
  category: BusinessCategory;
  logo?: string;
  coverImage?: string;
  location: BusinessLocation;
  contact: BusinessContact;
  isVerified: boolean;
  isActive: boolean;
  createdAt: ISODateString;
  updatedAt: ISODateString;
  listingsCount: number;
  rating: number;
  reviewCount: number;
}

export type ListingType = "room" | "table" | "tour" | "event" | "activity" | "package";

export type PriceUnit =
  | "perNight"
  | "perPerson"
  | "perTable"
  | "perTour"
  | "perTicket"
  | "perHour";

export interface PriceRange {
  minPrice: number;
  maxPrice: number;
  currency: string;
  unit: PriceUnit;
}

export type RoomType =
  | "standard"
  | "deluxe"
  | "suite"
  | "executive"
  | "presidential"
  | "family"
  | "single"
  | "twin";

export type BedType = "single" | "double" | "queen" | "king" | "twin";

export interface RoomDetails {
  roomType: RoomType;
  capacity: number;
  bedCount: number;
  bedType: BedType;
  size: number;
  hasBalcony: boolean;
  hasView: boolean;
  totalRooms: number;
  availableRooms: number;
}

export type TableLocation =
  | "indoor"
  | "outdoor"
  | "terrace"
  | "rooftop"
  | "privateRoom"
  | "poolside";

export interface TableDetails {
  capacity: number;
  location: TableLocation;
  isPrivate?: boolean;
  totalTables: number;
  availableTables: number;
  availableTimeSlots: string[];
}

export type TourDifficulty = "easy" | "moderate" | "challenging" | "difficult";

export interface TourDetails {
  duration: string;
  difficulty: TourDifficulty;
  minParticipants: number;
  maxParticipants: number;
  included: string[];
  notIncluded: string[];
  itinerary?: string[];
  pickupLocation?: string;
  meetingPoint?: string;
  availableDates?: ISODateString[];
}

export interface TicketType {
  name: string;
  price: number;
  currency: string;
  available: number;
  description?: string;
}

export interface EventDetails {
  eventDate: ISODateString;
  eventEndDate?: ISODateString;
  venue?: string;
  totalCapacity: number;
  availableSpots: number;
  ticketTypes: TicketType[];
  isRecurring: boolean;
  recurringPattern?: string;
}

export interface Listing {
  id: string;
  businessId: string;
  name: string;
  description: string;
  type: ListingType;
  images: string[];
  priceRange: PriceRange;
  amenities: string[];
  tags: string[];
  isActive: boolean;
  isFeatured: boolean;
  rating: number;
  reviewCount: number;
  bookingsCount: number;
  createdAt: ISODateString;
  updatedAt: ISODateString;
  roomDetails?: RoomDetails;
  tableDetails?: TableDetails;
  tourDetails?: TourDetails;
  eventDetails?: EventDetails;
}

export type BookingType = "accommodation" | "dining" | "tour" | "event";

export type BookingStatus =
  | "pending"
  | "confirmed"
  | "checkedIn"
  | "completed"
  | "cancelled"
  | "noShow";

export type PaymentMethod = "zoeaCard" | "momo" | "bankTransfer" | "cash" | "card";

export type PaymentStatus = "pending" | "paid" | "partiallyPaid" | "refunded" | "failed";

export interface TimeOfDay {
  hour: number;
  minute: number;
}

export interface BookingGuest {
  firstName: string;
  lastName: string;
  email?: string;
  phoneNumber?: string;
  isPrimary: boolean;
}

export interface AccommodationBookingDetails {
  checkInDate: ISODateString;
  checkOutDate: ISODateString;
  nights: number;
  roomCount: number;
  guestCount: number;
  roomType?: string;
  checkInTime?: TimeOfDay;
  checkOutTime?: TimeOfDay;
  guests: BookingGuest[];
}

export interface DiningBookingDetails {
  reservationDate: ISODateString;
  timeSlot: string;
  partySize: number;
  tablePreference?: string;
  occasion?: string;
  isHighChairNeeded: boolean;
}

export interface TourBookingDetails {
  tourDate: ISODateString;
  participants: number;
  pickupLocation?: string;
  pickupTime?: string;
  participantNames: string[];
  preferredLanguage?: string;
}

export interface EventBookingDetails {
  eventDate: ISODateString;
  ticketType: string;
  ticketCount: number;
  attendeeNames: string[];
  seatPreference?: string;
}

export interface Booking {
  id: string;
  listingId: string;
  businessId: string;
  customerId: string;
  customerName: string;
  customerEmail?: string;
  customerPhone?: string;
  type: BookingType;
  status: BookingStatus;
  totalAmount: number;
  currency: string;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  createdAt: ISODateString;
  updatedAt: ISODateString;
  specialRequests?: string;
  listingName?: string;
  businessName?: string;
  accommodationDetails?: AccommodationBookingDetails;
  diningDetails?: DiningBookingDetails;
  tourDetails?: TourBookingDetails;
  eventDetails?: EventBookingDetails;
}
