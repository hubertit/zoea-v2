import apiClient from './client';

export interface Listing {
  id: string;
  name: string;
  slug: string;
  description: string;
  categoryId: string;
  category: {
    id: string;
    name: string;
    slug: string;
  };
  location: {
    city: string;
    address?: string;
    latitude?: number;
    longitude?: number;
  };
  images: Array<{
    id: string;
    url: string;
    isPrimary: boolean;
  }>;
  rating?: number;
  reviewCount: number;
  priceRange?: string;
  isVerified: boolean;
  isFeatured: boolean;
  status: string;
  amenities?: string[];
  contactInfo?: {
    phone?: string;
    email?: string;
    website?: string;
  };
  businessHours?: Array<{
    day: string;
    openTime: string;
    closeTime: string;
    isClosed: boolean;
  }>;
}

export interface ListingsResponse {
  data: Listing[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

export const listingsApi = {
  async getFeatured(limit = 10): Promise<Listing[]> {
    const response = await apiClient.get<Listing[]>(`/listings/featured?limit=${limit}`);
    return response.data;
  },

  async getByCategory(categoryId: string, params?: {
    page?: number;
    limit?: number;
    sortBy?: string;
    priceRange?: string;
  }): Promise<ListingsResponse> {
    const response = await apiClient.get<ListingsResponse>(`/listings`, {
      params: {
        categoryId,
        ...params,
      },
    });
    return response.data;
  },

  async getById(id: string): Promise<Listing> {
    const response = await apiClient.get<Listing>(`/listings/${id}`);
    return response.data;
  },

  async search(query: string, location?: string): Promise<ListingsResponse> {
    const response = await apiClient.get<ListingsResponse>(`/listings/search`, {
      params: { query, location },
    });
    return response.data;
  },
};
