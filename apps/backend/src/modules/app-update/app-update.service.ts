import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
  MOBILE_APP_UPDATE_INTEGRATION_NAME,
  MobileAppUpdateConfig,
  MobilePlatformPolicy,
  MobileUpdateMode,
  defaultMobileAppUpdateConfig,
} from './mobile-app-update.types';

export type PublicUpdateCheckResult = {
  updateRequired: boolean;
  mode: MobileUpdateMode;
  title: string;
  message: string;
  storeUrl: string;
  dismissForDays: number;
  /** Changes when admin edits policy; client uses to invalidate snooze */
  policyFingerprint: string;
};

@Injectable()
export class AppUpdateService {
  constructor(private readonly prisma: PrismaService) {}

  private parseSemverCore(version: string): number[] {
    const core = version.trim().split('-')[0].split('+')[0];
    return core.split('.').map((p) => {
      const n = parseInt(p, 10);
      return Number.isFinite(n) ? n : 0;
    });
  }

  /** -1 if a < b, 0 if equal, 1 if a > b */
  compareSemver(a: string, b: string): number {
    const pa = this.parseSemverCore(a);
    const pb = this.parseSemverCore(b);
    const n = Math.max(pa.length, pb.length);
    for (let i = 0; i < n; i++) {
      const da = pa[i] ?? 0;
      const db = pb[i] ?? 0;
      if (da !== db) {
        return da < db ? -1 : 1;
      }
    }
    return 0;
  }

  needsUpdate(clientVersion: string, clientBuild: number, policy: MobilePlatformPolicy): boolean {
    const minV = (policy.minVersion || '0.0.0').trim();
    const cmp = this.compareSemver(clientVersion, minV);
    if (cmp < 0) {
      return true;
    }
    if (cmp > 0) {
      return false;
    }
    if (policy.minBuild == null || policy.minBuild <= 0) {
      return false;
    }
    return clientBuild < policy.minBuild;
  }

  private coercePolicy(p: Partial<MobilePlatformPolicy> | undefined, fallback: MobilePlatformPolicy): MobilePlatformPolicy {
    const mode: MobileUpdateMode =
      p?.mode === 'optional' || p?.mode === 'mandatory' || p?.mode === 'none' ? p.mode : fallback.mode;
    const minBuildRaw = p?.minBuild;
    const minBuild =
      minBuildRaw === null || minBuildRaw === undefined
        ? fallback.minBuild
        : Number.isFinite(Number(minBuildRaw))
          ? Number(minBuildRaw)
          : fallback.minBuild;
    return {
      minVersion: typeof p?.minVersion === 'string' ? p.minVersion.trim() : fallback.minVersion,
      minBuild,
      mode,
      title: typeof p?.title === 'string' ? p.title : fallback.title,
      message: typeof p?.message === 'string' ? p.message : fallback.message,
      storeUrl: typeof p?.storeUrl === 'string' ? p.storeUrl.trim() : fallback.storeUrl,
      dismissForDays: Math.max(1, Math.min(365, Number(p?.dismissForDays) || fallback.dismissForDays)),
    };
  }

  async getConfig(): Promise<MobileAppUpdateConfig> {
    const row = await this.prisma.integration.findUnique({
      where: { name: MOBILE_APP_UPDATE_INTEGRATION_NAME },
    });
    if (!row || !row.isActive) {
      return defaultMobileAppUpdateConfig();
    }
    const raw = row.config as Partial<MobileAppUpdateConfig> | null;
    const base = defaultMobileAppUpdateConfig();
    if (!raw || typeof raw !== 'object') {
      return base;
    }
    return {
      ios: this.coercePolicy(raw.ios, base.ios),
      android: this.coercePolicy(raw.android, base.android),
    };
  }

  private async ensureIntegrationRow() {
    const existing = await this.prisma.integration.findUnique({
      where: { name: MOBILE_APP_UPDATE_INTEGRATION_NAME },
    });
    if (existing) {
      return existing;
    }
    const defaults = defaultMobileAppUpdateConfig();
    return this.prisma.integration.create({
      data: {
        name: MOBILE_APP_UPDATE_INTEGRATION_NAME,
        displayName: 'Mobile app update prompts',
        description: 'Optional or mandatory in-app update prompts for iOS and Android',
        isActive: true,
        config: defaults as object,
      },
    });
  }

  async getAdminPolicy() {
    const row = await this.ensureIntegrationRow();
    const config = await this.getConfig();
    return {
      integrationId: row.id,
      isActive: row.isActive,
      ...config,
      updatedAt: row.updatedAt,
    };
  }

  async saveAdminPolicy(body: { ios?: Partial<MobilePlatformPolicy>; android?: Partial<MobilePlatformPolicy>; isActive?: boolean }) {
    const row = await this.ensureIntegrationRow();
    const current = await this.getConfig();
    const next: MobileAppUpdateConfig = {
      ios: this.coercePolicy({ ...current.ios, ...body.ios }, current.ios),
      android: this.coercePolicy({ ...current.android, ...body.android }, current.android),
    };

    const updated = await this.prisma.integration.update({
      where: { id: row.id },
      data: {
        ...(body.isActive !== undefined && { isActive: body.isActive }),
        config: next as object,
        updatedAt: new Date(),
      },
    });

    return {
      integrationId: updated.id,
      isActive: updated.isActive,
      ...next,
      updatedAt: updated.updatedAt,
    };
  }

  async checkUpdate(platform: 'ios' | 'android', clientVersion: string, clientBuild: number): Promise<PublicUpdateCheckResult> {
    const config = await this.getConfig();
    const policy = platform === 'ios' ? config.ios : config.android;

    const fingerprint = `${policy.minVersion}|${policy.minBuild ?? ''}|${policy.mode}`;

    const none: PublicUpdateCheckResult = {
      updateRequired: false,
      mode: 'none',
      title: '',
      message: '',
      storeUrl: '',
      dismissForDays: policy.dismissForDays,
      policyFingerprint: fingerprint,
    };

    if (policy.mode === 'none') {
      return none;
    }

    const outdated = this.needsUpdate(clientVersion, clientBuild, policy);
    if (!outdated) {
      return none;
    }

    return {
      updateRequired: true,
      mode: policy.mode,
      title: policy.title,
      message: policy.message,
      storeUrl: policy.storeUrl,
      dismissForDays: policy.dismissForDays,
      policyFingerprint: fingerprint,
    };
  }
}
