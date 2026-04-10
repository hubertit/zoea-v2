import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as https from 'https';
import { PrismaService } from '../../prisma/prisma.service';

/** Mista SMS: credentials from `integrations` (`mista_sms`) then env fallback. */
@Injectable()
export class SmsService {
  private readonly logger = new Logger(SmsService.name);

  constructor(
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  /** Load Mista credentials from DB first, then env (Docker / local). */
  private async resolveMistaCredentials(): Promise<{ apiKey: string; senderId: string } | null> {
    try {
      const row = await this.prisma.integration.findUnique({
        where: { name: 'mista_sms' },
      });
      if (row?.isActive && row.config && typeof row.config === 'object' && !Array.isArray(row.config)) {
        const c = row.config as Record<string, unknown>;
        const apiKey = typeof c.apiKey === 'string' ? c.apiKey.trim() : '';
        const senderIdRaw = typeof c.senderId === 'string' ? c.senderId.trim() : '';
        const senderId = senderIdRaw || 'E-Notifier';
        if (apiKey.length > 0) {
          return { apiKey, senderId };
        }
      }
    } catch (e) {
      this.logger.warn(`Could not read mista_sms integration: ${(e as Error).message}`);
    }

    const apiKey =
      this.config.get<string>('MISTA_SMS_API_KEY')?.trim() ||
      this.config.get<string>('SMS_API_KEY')?.trim();
    if (!apiKey) {
      this.logger.warn(
        'No Mista SMS key: add integrations row mista_sms (config.apiKey) or set MISTA_SMS_API_KEY',
      );
      return null;
    }
    const senderId =
      this.config.get<string>('MISTA_SMS_SENDER_ID')?.trim() || 'E-Notifier';
    return { apiKey, senderId };
  }

  /**
   * @param recipient Digits only, country code included (e.g. 250788123456)
   */
  async sendSMS(recipient: string, message: string): Promise<boolean> {
    const digits = recipient.replace(/\D/g, '');
    if (digits.length < 9) {
      this.logger.warn(`Invalid SMS recipient length: ${recipient}`);
      return false;
    }

    const creds = await this.resolveMistaCredentials();
    if (!creds) {
      return false;
    }
    const { apiKey, senderId } = creds;

    const smsData = {
      recipient: digits,
      sender_id: senderId,
      type: 'plain',
      message,
    };

    return new Promise<boolean>((resolve) => {
      const postData = JSON.stringify(smsData);
      const options = {
        hostname: 'api.mista.io',
        port: 443,
        path: '/sms',
        method: 'POST',
        headers: {
          Authorization: `Bearer ${apiKey}`,
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData),
        },
        timeout: 15000,
      };

      const req = https.request(options, (res) => {
        let responseData = '';
        res.on('data', (chunk) => {
          responseData += chunk;
        });
        res.on('end', () => {
          if (res.statusCode === 200) {
            try {
              const parsed = JSON.parse(responseData) as { status?: string };
              if (parsed.status === 'success') {
                this.logger.log(`SMS sent successfully to ${digits}`);
                resolve(true);
              } else {
                this.logger.error(`SMS API non-success: ${responseData}`);
                resolve(false);
              }
            } catch {
              this.logger.error(`SMS API parse error: ${responseData}`);
              resolve(false);
            }
          } else {
            this.logger.error(`SMS failed: HTTP ${res.statusCode} ${responseData}`);
            resolve(false);
          }
        });
      });

      req.on('error', (error) => {
        this.logger.error(`SMS request error: ${error.message}`, error.stack);
        resolve(false);
      });
      req.on('timeout', () => {
        req.destroy();
        this.logger.error('SMS request timeout');
        resolve(false);
      });
      req.write(postData);
      req.end();
    });
  }
}
