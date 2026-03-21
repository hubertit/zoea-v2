import apiClient from './client';

export interface Tour {
  id: string;
  name: string;
  slug: string;
  description: string;
  shortDescription?: string;
  duration: string;
  difficulty: string;
  minPrice: string;
  maxPrice: string;
  currency: string;
  type: string;
  status: string;
  rating?: number | string;
  reviewCount: number;
  images: Array<{
    id: string;
    tourId: string;
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
}

export interface ToursResponse {
  data: Tour[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

export const toursApi = {
  async getAll(params?: {
    page?: number;
    limit?: number;
    status?: string;
  }): Promise<ToursResponse> {
    const response = await apiClient.get<ToursResponse>('/tours', {
      params: {
        status: 'active',
        ...params,
      },
    });
    return response.data;
  },

  async getById(id: string): Promise<Tour> {
    const response = await apiClient.get<Tour>(`/tours/${id}`);
    return response.data;
  },
};
