import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomInt } from 'crypto';
import { Prisma } from '@prisma/client';
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

  /** Authenticated: user code, share URL, stats, and current program snapshot. */
  async getMyReferralSummary(userId: string) {
    const [codeRow, program] = await Promise.all([
      this.getOrCreateReferralCode(userId),
      this.getActiveProgram(),
    ]);
    return {
      code: codeRow.code,
      shareUrl: this.buildShareUrl(codeRow.code),
      stats: {
        totalReferrals: codeRow.total_referrals ?? 0,
        successfulReferrals: codeRow.successful_referrals ?? 0,
        totalPointsEarned: codeRow.total_points_earned ?? 0,
        pendingPoints: codeRow.pending_points ?? 0,
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
