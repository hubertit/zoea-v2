import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomInt } from 'crypto';
import { Prisma, referral_reward_status } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const CODE_LENGTH = 8;
const MAX_CODE_ALLOC_ATTEMPTS = 16;

@Injectable()
export class ReferralsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
  ) {}

  /** Public program config: active rule for UI (referrer/referee points). */
  async getActiveProgram() {
    const now = new Date();
    const rule = await this.prisma.referral_program_rules.findFirst({
      where: {
        is_active: true,
        effective_from: { lte: now },
        OR: [{ effective_to: null }, { effective_to: { gte: now } }],
      },
      orderBy: { effective_from: 'desc' },
    });
    return { rule: rule ? this.toProgramRuleDto(rule) : null };
  }

  /**
   * Called after a new user is created. Idempotent: skips if user already has a referral row
   * or code is invalid / self / no active program. Does not throw for business skips.
   * @returns whether a referral link and pending rewards were created
   */
  async applyReferralOnSignup(newUserId: string, rawCode?: string | null): Promise<boolean> {
    const codeNorm = typeof rawCode === 'string' ? rawCode.trim().toUpperCase() : '';
    if (!codeNorm) return false;

    const existingLink = await this.prisma.referrals.findUnique({
      where: { referred_id: newUserId },
    });
    if (existingLink) return false;

    const codeRow = await this.prisma.referral_codes.findFirst({
      where: { code: codeNorm, is_active: true },
    });
    if (!codeRow || codeRow.user_id === newUserId) return false;

    const now = new Date();
    const rule = await this.prisma.referral_program_rules.findFirst({
      where: {
        is_active: true,
        effective_from: { lte: now },
        OR: [{ effective_to: null }, { effective_to: { gte: now } }],
      },
      orderBy: { effective_from: 'desc' },
    });
    if (!rule) return false;

    try {
      await this.prisma.$transaction(async (tx) => {
        const referral = await tx.referrals.create({
          data: {
            referrer_id: codeRow.user_id,
            referred_id: newUserId,
            referral_code_id: codeRow.id,
            is_successful: true,
            qualified_at: now,
          },
        });

        await tx.referral_rewards.createMany({
          data: [
            {
              referral_id: referral.id,
              user_id: codeRow.user_id,
              reward_type: 'signup_referrer',
              points: rule.referrer_points,
              status: referral_reward_status.pending,
            },
            {
              referral_id: referral.id,
              user_id: newUserId,
              reward_type: 'signup_referee',
              points: rule.referee_points,
              status: referral_reward_status.pending,
            },
          ],
        });

        await tx.referral_codes.update({
          where: { id: codeRow.id },
          data: {
            total_referrals: { increment: 1 },
            successful_referrals: { increment: 1 },
            pending_points: { increment: rule.referrer_points },
          },
        });
      });
      return true;
    } catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
        return false;
      }
      throw e;
    }
  }

  /** Authenticated: user code, share URL, stats (ledger-based), and current program snapshot. */
  async getMyReferralSummary(userId: string) {
    const [codeRow, program, totalReferrals, successfulReferrals, creditedAgg, pendingAgg] =
      await Promise.all([
        this.getOrCreateReferralCode(userId),
        this.getActiveProgram(),
        this.prisma.referrals.count({ where: { referrer_id: userId } }),
        this.prisma.referrals.count({
          where: { referrer_id: userId, is_successful: true },
        }),
        this.prisma.referral_rewards.aggregate({
          where: { user_id: userId, status: referral_reward_status.credited },
          _sum: { points: true },
        }),
        this.prisma.referral_rewards.aggregate({
          where: { user_id: userId, status: referral_reward_status.pending },
          _sum: { points: true },
        }),
      ]);

    return {
      code: codeRow.code,
      shareUrl: this.buildShareUrl(codeRow.code),
      stats: {
        totalReferrals,
        successfulReferrals,
        totalPointsEarned: creditedAgg._sum.points ?? 0,
        pendingPoints: pendingAgg._sum.points ?? 0,
      },
      program: program.rule,
    };
  }

  private toProgramRuleDto(rule: {
    id: string;
    name: string;
    referrer_points: number;
    referee_points: number;
    effective_from: Date;
    effective_to: Date | null;
  }) {
    return {
      id: rule.id,
      name: rule.name,
      referrerPoints: rule.referrer_points,
      refereePoints: rule.referee_points,
      effectiveFrom: rule.effective_from.toISOString(),
      effectiveTo: rule.effective_to ? rule.effective_to.toISOString() : null,
    };
  }

  private buildShareUrl(code: string): string {
    const base =
      this.config.get<string>('REFERRAL_WEB_BASE_URL')?.replace(/\/$/, '') ||
      'https://zoea.africa';
    return `${base}/r/${encodeURIComponent(code)}`;
  }

  private generateCode(): string {
    let out = '';
    for (let i = 0; i < CODE_LENGTH; i++) {
      out += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
    }
    return out;
  }

  private async getOrCreateReferralCode(userId: string) {
    const existing = await this.prisma.referral_codes.findUnique({
      where: { user_id: userId },
    });
    if (existing) return existing;

    for (let i = 0; i < MAX_CODE_ALLOC_ATTEMPTS; i++) {
      const code = this.generateCode();
      try {
        return await this.prisma.referral_codes.create({
          data: {
            user_id: userId,
            code,
            is_active: true,
            total_referrals: 0,
            successful_referrals: 0,
            total_points_earned: 0,
            pending_points: 0,
          },
        });
      } catch (e) {
        if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
          continue;
        }
        throw e;
      }
    }
    throw new InternalServerErrorException('Could not allocate a unique referral code');
  }
}
