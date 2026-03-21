import apiClient from './client';
import type { Listing } from './listings';

export interface Booking {
  id: string;
  bookingNumber?: string;
  listing: Listing;
  userId: string;
  bookingType: 'hotel' | 'restaurant' | 'tour' | 'event';
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed' | 'checked_in' | 'no_show' | 'refunded';
  
  // Hotel-specific fields
  checkInDate?: string;
  checkOutDate?: string;
  roomCount?: number;
  
  // Restaurant-specific fields
  bookingDate?: string;
  bookingTime?: string;
  partySize?: number;
  
  // Common fields
  guestCount: number;
  totalAmount: number;
  subtotal?: number;
  taxAmount?: number;
  discountAmount?: number;
  currency: string;
  specialRequests?: string;
  fullName?: string;
  email?: string;
  phone?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CreateBookingRequest {
  listingId: string;
  bookingType: 'hotel' | 'restaurant' | 'tour' | 'event';
  
  // Hotel-specific fields
  checkInDate?: string;
  checkOutDate?: string;
  roomCount?: number;
  
  // Restaurant-specific fields
  bookingDate?: string;
  bookingTime?: string;
  
  // Common fields
  guestCount: number;
  specialRequests?: string;
  fullName: string;
  email: string;
  phone: string;
}

export const bookingsApi = {
  async create(data: CreateBookingRequest): Promise<Booking> {
    const response = await apiClient.post<Booking>('/bookings', data);
    return response.data;
  },

  async getMyBookings(): Promise<Booking[]> {
    const response = await apiClient.get<Booking[]>('/bookings/my');
    return response.data;
  },

  async getById(id: string): Promise<Booking> {
    const response = await apiClient.get<Booking>(`/bookings/${id}`);
    return response.data;
  },

  async cancel(id: string): Promise<void> {
    await apiClient.patch(`/bookings/${id}/cancel`);
  },
};
