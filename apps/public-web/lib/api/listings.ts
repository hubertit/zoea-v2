import apiClient from './client';

export interface Listing {
  id: string;
  name: string;
  slug: string;
  description: string;
  shortDescription?: string;
  type: string;
  categoryId: string;
  category: {
    id: string;
    name: string;
    slug: string;
    icon?: string;
  };
  city?: {
    id: string;
    name: string;
    slug: string;
  };
  country?: {
    id: string;
    name: string;
    code: string;
  };
  address?: string;
  images: Array<{
    id: string;
    listingId: string;
    mediaId: string;
    isPrimary: boolean;
    sortOrder: number;
    caption?: string;
    media: {
      id: string;
      url: string;
      mediaType: string;
      fileName: string;
      altText?: string;
    };
  }>;
  rating?: number | string;
  reviewCount: number;
  minPrice?: string;
  maxPrice?: string;
  priceRange?: string;
  currency?: string;
  isVerified: boolean;
  isFeatured: boolean;
  isBlocked: boolean;
  status: string;
  acceptsBookings: boolean;
  contactPhone?: string;
  contactEmail?: string;
  website?: string;
  operatingHours?: Record<string, {
    open: string;
    close: string;
    closed: boolean;
  }>;
  amenities?: string[];
  viewCount: number;
  favoriteCount: number;
  bookingCount: number;
  _count?: {
    reviews: number;
    bookings: number;
    favorites: number;
  };
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
    const response = await apiClient.get<ListingsResponse>(`/listings`, {
      params: {
        isFeatured: true,
        limit,
      },
    });
    return response.data.data;
  },

  async getRandom(limit = 10): Promise<Listing[]> {
    const response = await apiClient.get<Listing[]>(`/listings/random`, {
      params: {
        limit,
      },
    });
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

  async getBySlug(slug: string): Promise<Listing> {
    const response = await apiClient.get<Listing>(`/listings/slug/${slug}`);
    return response.data;
  },

  async search(query: string, location?: string): Promise<ListingsResponse> {
    const response = await apiClient.get<ListingsResponse>(`/listings/search`, {
      params: { query, location },
    });
    return response.data;
  },
};
