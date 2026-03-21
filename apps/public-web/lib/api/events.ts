import axios from 'axios';

export interface Event {
  id: number;
  eventId: number;
  userId: number;
  creatorId: number;
  isBlocked: boolean;
  slug: string;
  organizerProfileId: number;
  type: string;
  createdAt: string;
  updatedAt: string;
  commentCount: string;
  likeCount: string;
  sincCount: string;
  hasLiked: boolean;
  event: EventDetails;
  owner: EventOwner;
}

export interface EventDetails {
  id: number;
  userId: number;
  name: string;
  description: string;
  organizerProfileId: number;
  flyer: string;
  imageId: number;
  fileId: number;
  location: {
    type: string;
    coordinates: number[];
  };
  locationName: string;
  isAcceptable: boolean;
  eventContextId: number;
  maxAttendance: number;
  attending: number;
  startDate: string;
  endDate: string;
  createdAt: string;
  updatedAt: string;
  setup: string;
  privacy: string;
  postId: number;
  ongoing: boolean;
  tickets: EventTicket[];
  attachments: any[];
  eventContext?: {
    id: number;
    name: string;
    description: string;
  };
}

export interface EventTicket {
  id: number;
  price: number;
  name: string;
  disabled: boolean;
  type: string;
  orderType: string;
  currency: string;
  createdAt: string;
  updatedAt: string;
  description?: string;
}

export interface EventOwner {
  id: number;
  username: string;
  name: string;
  email: string;
  imageUrl: string;
  bgUrl?: string;
  isPrivate: boolean;
  accountType: string;
  isActive: boolean;
  createdAt: string;
  maxDistance: number;
  bio?: string;
  isVerified: boolean;
  organizerProfileVerified: boolean;
  isCallerSubscribedToUser: boolean;
  isUserSubscribedToCaller: boolean;
}

export interface EventsResponse {
  statusCode: string;
  message: string;
  data: {
    events: Event[];
    count: number;
    pagination: {
      current: number;
      limit: number;
      total: number;
      next?: {
        page: number;
        limit: number;
        total: number;
      };
    };
  };
}

const eventsClient = axios.create({
  baseURL: 'https://api-prod.sinc.today/events/v1/public',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Transform API response to match our interface
function transformEvent(apiEvent: any): Event {
  return {
    ...apiEvent,
    event: apiEvent.Event || apiEvent.event,
  };
}

export const eventsApi = {
  async getAll(params?: {
    page?: number;
    limit?: number;
    category?: string;
  }): Promise<Event[]> {
    const response = await eventsClient.get<EventsResponse>('/explore-events', { params });
    return response.data.data.events.map(transformEvent);
  },

  async getById(id: string): Promise<Event> {
    const response = await eventsClient.get<any>(`/explore-events/${id}`);
    return transformEvent(response.data);
  },

  async search(query: string): Promise<Event[]> {
    const response = await eventsClient.get<EventsResponse>('/explore-events', {
      params: { search: query },
    });
    return response.data.data.events.map(transformEvent);
  },
};
