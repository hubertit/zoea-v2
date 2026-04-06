import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { FirebaseService } from '../firebase/firebase.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private prisma: PrismaService,
    private firebaseService: FirebaseService
  ) {}

  async findAll(userId: string, params: { page?: number; limit?: number; unreadOnly?: boolean }) {
    const { page = 1, limit = 20, unreadOnly } = params;
    const skip = (page - 1) * limit;

    const where = {
      userId,
      ...(unreadOnly && { isRead: false }),
      OR: [
        { expiresAt: null },
        { expiresAt: { gt: new Date() } },
      ],
    };

    const [notifications, total, unreadCount] = await Promise.all([
      this.prisma.notification.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.notification.count({ where }),
      this.prisma.notification.count({ where: { userId, isRead: false } }),
    ]);

    return {
      data: notifications,
      meta: { total, page, limit, unreadCount },
    };
  }

  async markAsRead(id: string, userId: string) {
    const notification = await this.prisma.notification.findUnique({ where: { id } });
    
    if (!notification) throw new NotFoundException('Notification not found');
    if (notification.userId !== userId) throw new NotFoundException('Notification not found');

    return this.prisma.notification.update({
      where: { id },
      data: { isRead: true, readAt: new Date() },
    });
  }

  async markAllAsRead(userId: string) {
    await this.prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true, readAt: new Date() },
    });

    return { success: true };
  }

  async delete(id: string, userId: string) {
    const notification = await this.prisma.notification.findUnique({ where: { id } });
    
    if (!notification) throw new NotFoundException('Notification not found');
    if (notification.userId !== userId) throw new NotFoundException('Notification not found');

    await this.prisma.notification.delete({ where: { id } });
    return { success: true };
  }

  async deleteAll(userId: string) {
    await this.prisma.notification.deleteMany({ where: { userId } });
    return { success: true };
  }

  async getUnreadCount(userId: string) {
    const count = await this.prisma.notification.count({
      where: { userId, isRead: false },
    });
    return { count };
  }

  // Internal method to create notifications
  async create(data: {
    userId: string;
    type: string;
    title: string;
    body: string;
    actionUrl?: string;
    actionData?: any;
    bookingId?: string;
    eventId?: string;
    listingId?: string;
  }) {
    const notification = await this.prisma.notification.create({
      data: {
        userId: data.userId,
        type: data.type as any,
        title: data.title,
        body: data.body,
        actionUrl: data.actionUrl,
        actionData: data.actionData,
        bookingId: data.bookingId,
        eventId: data.eventId,
        listingId: data.listingId,
      },
    });

    // Try to send push notification via Firebase
    await this.sendPushNotification(data.userId, data.title, data.body, data.actionUrl, data.actionData);

    return notification;
  }

  async sendPushNotification(userId: string, title: string, body: string, actionUrl?: string, actionData?: any) {
    try {
      // Find all active sessions for this user that have FCM tokens
      const sessions = await this.prisma.userSession.findMany({
        where: {
          userId,
          isActive: true,
          fcmToken: { not: null }
        },
        select: { fcmToken: true }
      });

      const tokens = sessions.map(s => s.fcmToken).filter(Boolean) as string[];

      if (tokens.length === 0) {
        return { success: false, reason: 'No active devices with FCM tokens' };
      }

      const messaging = this.firebaseService.getMessaging();
      
      const message = {
        notification: {
          title,
          body,
        },
        data: {
          actionUrl: actionUrl || '',
          // FCM data payloads must be string values
          actionData: actionData ? JSON.stringify(actionData) : '',
        },
        tokens,
      };

      const response = await messaging.sendEachForMulticast(message);
      this.logger.debug(`Successfully sent push notifications. Success count: ${response.successCount}, Failure count: ${response.failureCount}`);
      
      return { success: true, response };
    } catch (error) {
      this.logger.error('Failed to send push notification:', error);
      return { success: false, error };
    }
  }
}
