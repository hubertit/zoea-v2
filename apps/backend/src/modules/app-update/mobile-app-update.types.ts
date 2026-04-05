export type MobileUpdateMode = 'none' | 'optional' | 'mandatory';

export interface MobilePlatformPolicy {
  minVersion: string;
  minBuild: number | null;
  mode: MobileUpdateMode;
  title: string;
  message: string;
  storeUrl: string;
  /** Days to hide optional prompt after "Later" */
  dismissForDays: number;
}

export interface MobileAppUpdateConfig {
  ios: MobilePlatformPolicy;
  android: MobilePlatformPolicy;
}

export const MOBILE_APP_UPDATE_INTEGRATION_NAME = 'mobile_app_update';

export const defaultMobileAppUpdateConfig = (): MobileAppUpdateConfig => ({
  ios: {
    minVersion: '1.0.0',
    minBuild: null,
    mode: 'none',
    title: 'Update Zoea',
    message: 'A new version is available with improvements and fixes.',
    storeUrl: '',
    dismissForDays: 7,
  },
  android: {
    minVersion: '1.0.0',
    minBuild: null,
    mode: 'none',
    title: 'Update Zoea',
    message: 'A new version is available with improvements and fixes.',
    storeUrl: '',
    dismissForDays: 7,
  },
});
