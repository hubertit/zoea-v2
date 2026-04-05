import apiClient from './client';

export type MobileUpdateMode = 'none' | 'optional' | 'mandatory';

export interface MobilePlatformPolicy {
  minVersion: string;
  minBuild: number | null;
  mode: MobileUpdateMode;
  title: string;
  message: string;
  storeUrl: string;
  dismissForDays: number;
}

export interface MobileAppUpdatePolicyResponse {
  integrationId: string;
  isActive: boolean;
  ios: MobilePlatformPolicy;
  android: MobilePlatformPolicy;
  updatedAt: string;
}

export const MobileAppUpdateAPI = {
  getPolicy: async (): Promise<MobileAppUpdatePolicyResponse> => {
    const { data } = await apiClient.get<MobileAppUpdatePolicyResponse>('/admin/mobile-app-update');
    return data;
  },

  savePolicy: async (body: {
    ios?: Partial<MobilePlatformPolicy>;
    android?: Partial<MobilePlatformPolicy>;
    isActive?: boolean;
  }): Promise<MobileAppUpdatePolicyResponse> => {
    const { data } = await apiClient.put<MobileAppUpdatePolicyResponse>('/admin/mobile-app-update', body);
    return data;
  },
};
