import { create } from "zustand";
import { getSeedBookings, getSeedBusinesses, getSeedListings } from "@/lib/data/mock-merchant";
import type { Booking, BookingStatus, BookingType, Business, Listing } from "@/lib/types/merchant";

type MerchantDemoState = {
  businesses: Business[];
  listings: Listing[];
  bookings: Booking[];
  upsertBusiness: (b: Business) => void;
  upsertListing: (l: Listing) => void;
  updateBookingStatus: (id: string, status: BookingStatus) => void;
  filterBookingsByType: (type: BookingType) => void;
  clearBookingFilters: () => void;
};

export const useMerchantDemoStore = create<MerchantDemoState>((set) => ({
  businesses: getSeedBusinesses(),
  listings: getSeedListings(),
  bookings: getSeedBookings(),
  upsertBusiness: (b) =>
    set((s) => {
      const i = s.businesses.findIndex((x) => x.id === b.id);
      if (i === -1) return { businesses: [...s.businesses, b] };
      const next = [...s.businesses];
      next[i] = b;
      return { businesses: next };
    }),
  upsertListing: (l) =>
    set((s) => {
      const i = s.listings.findIndex((x) => x.id === l.id);
      if (i === -1) return { listings: [...s.listings, l] };
      const next = [...s.listings];
      next[i] = l;
      return { listings: next };
    }),
  updateBookingStatus: (id, status) =>
    set((s) => ({
      bookings: s.bookings.map((b) =>
        b.id === id ? { ...b, status, updatedAt: new Date().toISOString() } : b,
      ),
    })),
  filterBookingsByType: (type) => set({ bookings: getSeedBookings().filter((b) => b.type === type) }),
  clearBookingFilters: () => set({ bookings: getSeedBookings() }),
}));
