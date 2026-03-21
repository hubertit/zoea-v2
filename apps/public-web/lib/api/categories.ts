import apiClient from './client';

export interface Category {
  id: string;
  name: string;
  slug: string;
  description?: string;
  icon?: string;
  image?: string;
  listingCount: number;
  isActive: boolean;
}

export const categoriesApi = {
  async getAll(): Promise<Category[]> {
    const response = await apiClient.get<Category[]>('/categories');
    return response.data;
  },

  async getBySlug(slug: string): Promise<Category> {
    const response = await apiClient.get<Category>(`/categories/${slug}`);
    return response.data;
  },
};
