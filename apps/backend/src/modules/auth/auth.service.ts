import {
  Injectable,
  Logger,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import {
  RegisterDto,
  LoginDto,
  RequestPasswordResetDto,
  VerifyResetCodeDto,
  ResetPasswordDto,
  RequestPhoneVerificationDto,
  VerifyPhoneVerificationDto,
} from './dto/auth.dto';
import { ReferralsService } from '../referrals/referrals.service';
import { SmsService } from '../../common/services/sms.service';
import { FirebaseService, type FirebaseDecodedIdToken } from '../firebase/firebase.service';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private referralsService: ReferralsService,
    private smsService: SmsService,
    private firebaseService: FirebaseService,
  ) {}

  async register(dto: RegisterDto) {
    try {
      // Check if user exists
      const orConditions = [];
      if (dto.email) orConditions.push({ email: dto.email });
      if (dto.phoneNumber) orConditions.push({ phoneNumber: dto.phoneNumber });

      if (orConditions.length > 0) {
        const existingUser = await this.prisma.user.findFirst({
          where: { OR: orConditions },
        });

        if (existingUser) {
          throw new ConflictException('User with this email or phone already exists');
        }
      }

      // Hash password
      const passwordHash = await bcrypt.hash(dto.password, 10);

      // Create user
      const user = await this.prisma.user.create({
        data: {
          email: dto.email || null,
          phoneNumber: dto.phoneNumber || null,
          passwordHash,
          fullName: dto.fullName || null,
        },
        select: {
          id: true,
          email: true,
          phoneNumber: true,
          fullName: true,
          roles: true,
          createdAt: true,
        },
      });

      // Generate tokens
      const tokens = await this.generateTokens(user.id, user.email);

      let referralApplied = false;
      try {
        referralApplied = await this.referralsService.applyReferralOnSignup(
          user.id,
          dto.referralCode,
        );
      } catch (referralErr) {
        console.error('Referral apply failed (non-fatal):', referralErr);
      }

      return {
        user,
        ...tokens,
        referralApplied,
      };
    } catch (error) {
      console.error('Register error:', error);
      throw error;
    }
  }

  async login(dto: LoginDto) {
    // Find user
    const user = await this.prisma.user.findFirst({
      where: {
        OR: [
          { email: dto.identifier },
          { phoneNumber: dto.identifier },
        ],
      },
    });

    if (!user || !user.passwordHash) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Update last login
    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        fullName: user.fullName,
        roles: user.roles,
      },
      ...tokens,
    };
  }

  /**
   * Exchange a Firebase Auth ID token for app JWTs (same shape as `login`).
   * Links `firebaseUid` to an existing account when the email matches.
   */
  async loginWithFirebaseIdToken(idToken: string) {
    if (!this.firebaseService.isInitialized()) {
      throw new ServiceUnavailableException(
        'Firebase Admin is not configured. Add the firebase_admin integration (projectId, clientEmail, privateKey) and set it active.',
      );
    }

    let decoded: FirebaseDecodedIdToken;
    try {
      decoded = await this.firebaseService.verifyIdToken(idToken);
    } catch {
      throw new UnauthorizedException('Invalid or expired token');
    }

    const uid = decoded.uid;
    const emailRaw = decoded.email?.trim().toLowerCase();
    if (!emailRaw) {
      throw new BadRequestException('This sign-in method did not provide an email address.');
    }

    const fullName =
      typeof decoded.name === 'string' && decoded.name.trim().length > 0
        ? decoded.name.trim()
        : emailRaw.split('@')[0];

    const existing = await this.prisma.user.findFirst({
      where: {
        OR: [{ firebaseUid: uid }, { email: emailRaw }],
      },
      select: {
        id: true,
        firebaseUid: true,
        fullName: true,
        emailVerifiedAt: true,
      },
    });

    type FirebaseLoginUser = Prisma.UserGetPayload<{
      select: {
        id: true;
        email: true;
        phoneNumber: true;
        fullName: true;
        roles: true;
      };
    }>;

    let user: FirebaseLoginUser;

    if (existing) {
      const updates: {
        firebaseUid?: string;
        fullName?: string;
        emailVerifiedAt?: Date;
        lastLoginAt?: Date;
      } = { lastLoginAt: new Date() };

      if (!existing.firebaseUid) {
        updates.firebaseUid = uid;
      }
      if (!existing.fullName || existing.fullName.trim().length === 0) {
        updates.fullName = fullName;
      }
      if (!existing.emailVerifiedAt) {
        updates.emailVerifiedAt = new Date();
      }

      user = await this.prisma.user.update({
        where: { id: existing.id },
        data: updates,
        select: {
          id: true,
          email: true,
          phoneNumber: true,
          fullName: true,
          roles: true,
        },
      });
    } else {
      user = await this.prisma.user.create({
        data: {
          email: emailRaw,
          firebaseUid: uid,
          fullName,
          passwordHash: null,
          emailVerifiedAt: new Date(),
          lastLoginAt: new Date(),
        },
        select: {
          id: true,
          email: true,
          phoneNumber: true,
          fullName: true,
          roles: true,
        },
      });
    }

    const tokens = await this.generateTokens(user.id, user.email ?? emailRaw);

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        fullName: user.fullName,
        roles: user.roles,
      },
      ...tokens,
    };
  }

  async refreshToken(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
      });

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
      });

      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      return this.generateTokens(user.id, user.email);
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async getProfile(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        phoneNumber: true,
        username: true,
        fullName: true,
        bio: true,
        gender: true,
        roles: true,
        accountType: true,
        isVerified: true,
        preferredCurrency: true,
        preferredLanguage: true,
        createdAt: true,
        phoneVerifiedAt: true,
      },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    return user;
  }

  private generateOtpCode(): string {
    return crypto.randomInt(100_000, 1_000_000).toString();
  }

  /** Match login behaviour: email as-is; phone as digits with optional 0… vs 250… forms. */
  private async findUserForPasswordReset(identifier: string) {
    const t = identifier.trim();
    if (t.includes('@')) {
      return this.prisma.user.findFirst({
        where: { email: t.toLowerCase() },
      });
    }
    const digits = t.replace(/\D/g, '');
    if (digits.length < 7) return null;

    const variants = new Set<string>([digits]);
    if (digits.length === 9 && digits.startsWith('0')) {
      variants.add(`250${digits.slice(1)}`);
    }
    if (digits.length === 12 && digits.startsWith('250')) {
      variants.add(`0${digits.slice(3)}`);
    }

    return this.prisma.user.findFirst({
      where: {
        OR: [...variants].map((phoneNumber) => ({ phoneNumber })),
      },
    });
  }

  async requestPasswordReset(dto: RequestPasswordResetDto) {
    const user = await this.findUserForPasswordReset(dto.identifier);

    if (!user) {
      return { success: true, message: 'If the account exists, a reset code has been sent.' };
    }

    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15);

    await this.prisma.password_reset_tokens.deleteMany({
      where: {
        user_id: user.id,
        used_at: null,
      },
    });

    let resetCode = this.generateOtpCode();
    let resetTokenCreated = false;
    for (let attempt = 0; attempt < 10; attempt++) {
      try {
        await this.prisma.password_reset_tokens.create({
          data: {
            user_id: user.id,
            token: resetCode,
            expires_at: expiresAt,
          },
        });
        resetTokenCreated = true;
        break;
      } catch (e: unknown) {
        const code = (e as { code?: string })?.code;
        if (code === 'P2002') {
          resetCode = this.generateOtpCode();
          continue;
        }
        throw e;
      }
    }
    if (!resetTokenCreated) {
      throw new BadRequestException('Could not issue reset code. Try again.');
    }

    const phoneDigits = user.phoneNumber?.replace(/\D/g, '') ?? '';
    if (phoneDigits.length >= 9) {
      const msg = `Zoea: Your password reset code is ${resetCode}. It expires in 15 minutes.`;
      // Do not await Mista — slow/unreachable SMS caused gateway 504s; token is already persisted.
      void this.smsService.sendSMS(phoneDigits, msg).then((ok) => {
        if (ok) {
          this.logger.log(`Password reset SMS dispatched for user ${user.id}`);
        } else {
          this.logger.warn(`Password reset SMS failed for user ${user.id} (check Mista / integrations.mista_sms)`);
        }
      });
    }

    return {
      success: true,
      message: 'If the account exists, a reset code has been sent.',
      /** True when an SMS was scheduled (Mista runs in background; may still fail — see logs). */
      smsQueued: phoneDigits.length >= 9,
      ...(process.env.NODE_ENV === 'development' ? { code: resetCode } : {}),
    };
  }

  async verifyResetCode(dto: VerifyResetCodeDto) {
    const user = await this.findUserForPasswordReset(dto.identifier);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const code = dto.code.trim();
    const resetToken = await this.prisma.password_reset_tokens.findFirst({
      where: {
        user_id: user.id,
        token: code,
        used_at: null,
        expires_at: {
          gte: new Date(),
        },
      },
      orderBy: {
        created_at: 'desc',
      },
    });

    if (!resetToken) {
      throw new BadRequestException('Invalid or expired reset code');
    }

    return {
      success: true,
      message: 'Reset code verified successfully.',
    };
  }

  async resetPassword(dto: ResetPasswordDto) {
    const user = await this.findUserForPasswordReset(dto.identifier);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const code = dto.code.trim();
    const resetToken = await this.prisma.password_reset_tokens.findFirst({
      where: {
        user_id: user.id,
        token: code,
        used_at: null,
        expires_at: {
          gte: new Date(),
        },
      },
      orderBy: {
        created_at: 'desc',
      },
    });

    if (!resetToken) {
      throw new BadRequestException('Invalid or expired reset code');
    }

    const passwordHash = await bcrypt.hash(dto.newPassword, 10);

    await this.prisma.user.update({
      where: { id: user.id },
      data: { passwordHash },
    });

    await this.prisma.password_reset_tokens.update({
      where: { id: resetToken.id },
      data: { used_at: new Date() },
    });

    return {
      success: true,
      message: 'Password reset successfully.',
    };
  }

  async requestPhoneVerification(userId: string, dto: RequestPhoneVerificationDto) {
    const phone = dto.phoneNumber.replace(/\D/g, '');
    if (phone.length < 9 || phone.length > 15) {
      throw new BadRequestException('Invalid phone number');
    }

    const taken = await this.prisma.user.findFirst({
      where: {
        phoneNumber: phone,
        id: { not: userId },
      },
    });
    if (taken) {
      throw new ConflictException('Phone number is already in use');
    }

    await this.prisma.phone_verification_tokens.deleteMany({
      where: { user_id: userId, verified_at: null },
    });

    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15);

    let code = this.generateOtpCode();
    for (let attempt = 0; attempt < 10; attempt++) {
      try {
        await this.prisma.phone_verification_tokens.create({
          data: {
            user_id: userId,
            phone,
            token: code,
            expires_at: expiresAt,
          },
        });
        const msg = `Zoea: Your verification code is ${code}. It expires in 15 minutes.`;
        void this.smsService.sendSMS(phone, msg).then((ok) => {
          if (ok) {
            this.logger.log(`Phone verification SMS dispatched for user ${userId}`);
          } else {
            this.logger.warn(`Phone verification SMS failed for user ${userId}`);
          }
        });
        return {
          success: true,
          message: 'Verification code will be sent by SMS shortly.',
          smsQueued: true,
          ...(process.env.NODE_ENV === 'development' ? { code } : {}),
        };
      } catch (e: unknown) {
        const errCode = (e as { code?: string })?.code;
        if (errCode === 'P2002') {
          code = this.generateOtpCode();
          continue;
        }
        throw e;
      }
    }

    throw new BadRequestException('Could not create verification code');
  }

  async verifyPhoneVerification(userId: string, dto: VerifyPhoneVerificationDto) {
    const phone = dto.phoneNumber.replace(/\D/g, '');
    const code = dto.code.trim();

    const row = await this.prisma.phone_verification_tokens.findFirst({
      where: {
        user_id: userId,
        phone,
        token: code,
        verified_at: null,
        expires_at: { gte: new Date() },
      },
      orderBy: { created_at: 'desc' },
    });

    if (!row) {
      throw new BadRequestException('Invalid or expired verification code');
    }

    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: {
          phoneNumber: phone,
          phoneVerifiedAt: new Date(),
        },
      }),
      this.prisma.phone_verification_tokens.update({
        where: { id: row.id },
        data: { verified_at: new Date() },
      }),
    ]);

    return { success: true, message: 'Phone number verified.' };
  }

  private async generateTokens(userId: string, email: string) {
    const payload = { sub: userId, email };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload),
      this.jwtService.signAsync(payload, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
        expiresIn: this.configService.get('JWT_REFRESH_EXPIRATION') || '30d',
      }),
    ]);

    return {
      accessToken,
      refreshToken,
    };
  }
}

