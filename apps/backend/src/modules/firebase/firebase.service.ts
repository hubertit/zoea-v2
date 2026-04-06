import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class FirebaseService {
  constructor(private configService: ConfigService) {
    if (admin.apps.length === 0) {
      try {
        const projectId = this.configService.get('FIREBASE_PROJECT_ID');
        const clientEmail = this.configService.get('FIREBASE_CLIENT_EMAIL');
        // Handle newline characters in the private key from env variable
        const privateKey = this.configService.get('FIREBASE_PRIVATE_KEY')?.replace(/\\n/g, '\n');

        if (projectId && clientEmail && privateKey) {
          admin.initializeApp({
            credential: admin.credential.cert({
              projectId,
              clientEmail,
              privateKey,
            }),
          });
          console.log('✅ Firebase Admin initialized successfully');
        } else {
          console.warn('⚠️ Firebase Admin initialization skipped: Missing credentials in environment variables (FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY)');
        }
      } catch (error) {
        console.error('❌ Firebase Admin initialization error:', error);
      }
    }
  }

  getMessaging() {
    if (admin.apps.length === 0) {
      throw new Error('Firebase Admin is not initialized');
    }
    return admin.messaging();
  }
}
