import apiClient from './client';
import type { Listing } from './listings';

export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  phone?: string;
  createdAt: string;
}

export interface Favorite {
  id: string;
  listing: Listing;
  createdAt: string;
}

export const userApi = {
  async getProfile(): Promise<User> {
    const response = await apiClient.get<User>('/users/profile');
    return response.data;
  },

  async updateProfile(data: Partial<User>): Promise<User> {
    const response = await apiClient.patch<User>('/users/profile', data);
    return response.data;
  },

  async getFavorites(): Promise<Favorite[]> {
    const response = await apiClient.get<Favorite[]>('/users/favorites');
    return response.data;
  },

  async addFavorite(listingId: string): Promise<void> {
    await apiClient.post('/users/favorites', { listingId });
  },

  async removeFavorite(listingId: string): Promise<void> {
    await apiClient.delete(`/users/favorites/${listingId}`);
  },
};
