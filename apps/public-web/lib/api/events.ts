import axios from 'axios';

export interface Event {
  id: string;
  name: string;
  description: string;
  startDate: string;
  endDate: string;
  location: {
    name: string;
    city: string;
    address?: string;
  };
  image?: string;
  category: string;
  price?: {
    min: number;
    max: number;
    currency: string;
  };
  organizer?: string;
  website?: string;
}

const eventsClient = axios.create({
  baseURL: 'https://api-prod.sinc.today/events/v1/public',
  headers: {
    'Content-Type': 'application/json',
  },
});

export const eventsApi = {
  async getAll(params?: {
    page?: number;
    limit?: number;
    category?: string;
  }): Promise<Event[]> {
    const response = await eventsClient.get<Event[]>('/explore-events', { params });
    return response.data;
  },

  async getById(id: string): Promise<Event> {
    const response = await eventsClient.get<Event>(`/explore-events/${id}`);
    return response.data;
  },

  async search(query: string): Promise<Event[]> {
    const response = await eventsClient.get<Event[]>('/explore-events', {
      params: { search: query },
    });
    return response.data;
  },
};
