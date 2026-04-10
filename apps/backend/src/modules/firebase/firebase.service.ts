import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { IntegrationsService } from '../integrations/integrations.service';

export type FirebaseDecodedIdToken = admin.auth.DecodedIdToken;

/** Stored in `integrations` row `firebase_admin` → `config` (JSON). */
interface FirebaseAdminIntegrationConfig {
  projectId?: string;
  clientEmail?: string;
  privateKey?: string;
}

@Injectable()
export class FirebaseService implements OnModuleInit {
  private readonly logger = new Logger(FirebaseService.name);

  constructor(private integrationsService: IntegrationsService) {}

  async onModuleInit() {
    await this.tryInitializeFromIntegration();
  }

  private async tryInitializeFromIntegration(): Promise<void> {
    if (admin.apps.length > 0) {
      return;
    }

    const config = await this.integrationsService.getConfig<FirebaseAdminIntegrationConfig>(
      'firebase_admin',
    );

    if (!config) {
      this.logger.warn(
        "Firebase Admin skipped: integration 'firebase_admin' is missing, inactive, or has no usable config",
      );
      return;
    }

    const projectId = typeof config.projectId === 'string' ? config.projectId.trim() : '';
    const clientEmail = typeof config.clientEmail === 'string' ? config.clientEmail.trim() : '';
    const privateKeyRaw = typeof config.privateKey === 'string' ? config.privateKey : '';
    const privateKey = privateKeyRaw.replace(/\\n/g, '\n');

    if (!projectId || !clientEmail || !privateKey) {
      this.logger.warn(
        "Firebase Admin skipped: integration 'firebase_admin' config must include projectId, clientEmail, and privateKey",
      );
      return;
    }

    try {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          clientEmail,
          privateKey,
        }),
      });
      this.logger.log("Firebase Admin initialized from integrations table (firebase_admin)");
    } catch (error) {
      this.logger.error('Firebase Admin initialization error:', error);
    }
  }

  getMessaging() {
    if (admin.apps.length === 0) {
      throw new Error('Firebase Admin is not initialized');
    }
    return admin.messaging();
  }

  isInitialized(): boolean {
    return admin.apps.length > 0;
  }

  /** Verifies a Firebase Auth ID token (e.g. from Google Sign-In on the client). */
  async verifyIdToken(idToken: string): Promise<FirebaseDecodedIdToken> {
    if (admin.apps.length === 0) {
      throw new Error('Firebase Admin is not initialized');
    }
    return admin.auth().verifyIdToken(idToken);
  }
}
