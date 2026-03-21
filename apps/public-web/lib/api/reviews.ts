import apiClient from './client';

export interface Review {
  id: string;
  userId: string;
  userName: string;
  userAvatar?: string;
  listingId: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface CreateReviewRequest {
  listingId: string;
  rating: number;
  comment: string;
}

export interface ReviewsResponse {
  data: Review[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

export const reviewsApi = {
  async getByListing(listingId: string): Promise<Review[]> {
    const response = await apiClient.get<ReviewsResponse>(`/reviews`, {
      params: {
        listingId,
      },
    });
    return response.data.data;
  },

  async create(data: CreateReviewRequest): Promise<Review> {
    const response = await apiClient.post<Review>('/reviews', data);
    return response.data;
  },

  async delete(id: string): Promise<void> {
    await apiClient.delete(`/reviews/${id}`);
  },
};
