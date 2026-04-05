import axios, { AxiosInstance, AxiosError, InternalAxiosRequestConfig } from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'https://zoea-africa.qtsoftwareltd.com/api';

type AuthRefreshResponse = {
  accessToken: string;
  refreshToken: string;
};

type RequestConfigWithRetry = InternalAxiosRequestConfig & { _retry?: boolean };

/** No interceptors — used only for POST /auth/refresh to avoid recursion. */
const refreshAxios = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

function mergeAuthStorageTokens(accessToken: string, refreshToken: string) {
  if (typeof window === 'undefined') return;
  try {
    const raw = localStorage.getItem('auth-storage');
    if (!raw) return;
    const parsed = JSON.parse(raw) as { state?: Record<string, unknown> };
    if (!parsed.state) return;
    parsed.state = {
      ...parsed.state,
      token: accessToken,
      refreshToken,
      isAuthenticated: true,
    };
    localStorage.setItem('auth-storage', JSON.stringify(parsed));
  } catch (e) {
    console.error('mergeAuthStorageTokens:', e);
  }
}

class ApiClient {
  private client: AxiosInstance;
  private refreshPromise: Promise<string> | null = null;

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      timeout: 30000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    this.client.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        const url = config.url || '';
        const skipAuth =
          url.includes('/auth/login') ||
          url.includes('/auth/register') ||
          url.includes('/auth/forgot-password') ||
          url.includes('/auth/reset-password');

        if (!skipAuth) {
          const token = this.getToken();
          if (token && config.headers) {
            config.headers.Authorization = `Bearer ${token}`;
          }
        }
        return config;
      },
      (error: AxiosError) => Promise.reject(error)
    );

    this.client.interceptors.response.use(
      (response) => response,
      async (error: AxiosError) => {
        const originalRequest = error.config as RequestConfigWithRetry | undefined;

        if (!error.response || !originalRequest) {
          return Promise.reject(this.formatNetworkError(error));
        }

        const status = error.response.status;
        const data = error.response.data as { message?: string };
        const url = originalRequest.url || '';

        if (status === 401) {
          if (url.includes('/auth/login') || url.includes('/auth/register')) {
            return Promise.reject({
              message: data?.message || error.message || 'Authentication failed',
              status: 401,
              data,
              response: error.response,
            });
          }

          if (url.includes('/auth/refresh')) {
            this.handleUnauthorized();
            return Promise.reject({
              message: data?.message || 'Session expired',
              status: 401,
              data,
              response: error.response,
            });
          }

          if (!originalRequest._retry) {
            try {
              const newToken = await this.ensureRefreshedAccessToken();
              originalRequest._retry = true;
              originalRequest.headers = originalRequest.headers || {};
              originalRequest.headers.Authorization = `Bearer ${newToken}`;
              return this.client.request(originalRequest);
            } catch {
              this.handleUnauthorized();
              return Promise.reject({
                message: 'Session expired. Please sign in again.',
                status: 401,
                data,
                response: error.response,
              });
            }
          }

          this.handleUnauthorized();
          return Promise.reject({
            message: data?.message || error.message || 'Unauthorized',
            status: 401,
            data,
            response: error.response,
          });
        }

        if (status === 403) {
          console.error('Access denied:', data?.message || 'You do not have permission to perform this action.');
        }
        if (status === 404) {
          console.error('Resource not found');
        }
        if (status >= 500) {
          console.error('Server error');
        }

        return Promise.reject({
          message: data?.message || error.message || 'An error occurred',
          status,
          data,
          response: error.response,
        });
      }
    );
  }

  private formatNetworkError(error: AxiosError) {
    if (error.request) {
      return {
        message: 'Network error. Please check your connection.',
        status: 0,
      };
    }
    return error;
  }

  private getToken(): string | null {
    if (typeof window === 'undefined') return null;

    try {
      const authStorage = localStorage.getItem('auth-storage');
      if (authStorage) {
        const parsed = JSON.parse(authStorage);
        return parsed.state?.token || null;
      }
    } catch (e) {
      console.error('Error reading token from storage:', e);
    }

    return null;
  }

  private getRefreshToken(): string | null {
    if (typeof window === 'undefined') return null;

    try {
      const authStorage = localStorage.getItem('auth-storage');
      if (authStorage) {
        const parsed = JSON.parse(authStorage);
        return parsed.state?.refreshToken || null;
      }
    } catch (e) {
      console.error('Error reading refresh token from storage:', e);
    }

    return null;
  }

  /**
   * Single-flight refresh; used by the 401 interceptor and by checkAuth when access token is missing.
   */
  async refreshWithToken(refreshToken: string): Promise<AuthRefreshResponse> {
    const { data } = await refreshAxios.post<AuthRefreshResponse>('/auth/refresh', {
      refreshToken,
    });
    return data;
  }

  private async ensureRefreshedAccessToken(): Promise<string> {
    if (this.refreshPromise) {
      return this.refreshPromise;
    }

    const refreshToken = this.getRefreshToken();
    if (!refreshToken) {
      throw new Error('No refresh token');
    }

    this.refreshPromise = (async () => {
      try {
        const data = await this.refreshWithToken(refreshToken);
        mergeAuthStorageTokens(data.accessToken, data.refreshToken);
        const { useAuthStore } = await import('@/src/store/auth');
        useAuthStore.getState().setSessionTokens(data.accessToken, data.refreshToken);
        return data.accessToken;
      } finally {
        this.refreshPromise = null;
      }
    })();

    return this.refreshPromise;
  }

  private handleUnauthorized() {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('auth-storage');
      if (!window.location.pathname.startsWith('/auth/login')) {
        window.location.href = '/auth/login';
      }
    }
  }

  get<T = any>(url: string, config?: object) {
    return this.client.get<T>(url, config);
  }

  post<T = any>(url: string, data?: object, config?: object) {
    return this.client.post<T>(url, data, config);
  }

  put<T = any>(url: string, data?: object, config?: object) {
    return this.client.put<T>(url, data, config);
  }

  patch<T = any>(url: string, data?: object, config?: object) {
    return this.client.patch<T>(url, data, config);
  }

  delete<T = any>(url: string, config?: object) {
    return this.client.delete<T>(url, config);
  }
}

export const apiClient = new ApiClient();
export default apiClient;
