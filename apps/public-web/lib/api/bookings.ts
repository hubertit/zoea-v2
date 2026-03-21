import apiClient from './client';
import type { Listing } from './listings';

export interface Booking {
  id: string;
  listing: Listing;
  userId: string;
  startDate: string;
  endDate: string;
  guests: number;
  totalAmount: number;
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed';
  specialRequests?: string;
  createdAt: string;
}

export interface CreateBookingRequest {
  listingId: string;
  startDate: string;
  endDate: string;
  guests: number;
  specialRequests?: string;
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
