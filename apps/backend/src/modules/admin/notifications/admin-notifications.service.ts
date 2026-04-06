import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { Prisma, approval_status } from '@prisma/client';
import { PrismaService } from '../../../prisma/prisma.service';
import { FirebaseService } from '../../firebase/firebase.service';
import { AdminListNotificationRequestsDto } from './dto/list-notification-requests.dto';
import { AdminUpdateNotificationRequestDto } from './dto/update-notification-request.dto';
import { AdminCreateBroadcastDto } from './dto/create-broadcast.dto';

@Injectable()
export class AdminNotificationsService {
  private readonly logger = new Logger(AdminNotificationsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly firebaseService: FirebaseService
  ) {}

  async listRequests(dto: AdminListNotificationRequestsDto) {
    const page = dto.page ?? 1;
    const limit = dto.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: Prisma.notification_requestsWhereInput = {};
    const andFilters: Prisma.notification_requestsWhereInput[] = [];
    if (dto.status) andFilters.push({ status: dto.status });
    if (dto.requesterId) andFilters.push({ requester_id: dto.requesterId });
    if (dto.search) {
      const search = dto.search.trim();
      andFilters.push({
        OR: [
          { title: { contains: search, mode: 'insensitive' } },
          { body: { contains: search, mode: 'insensitive' } },
        ],
      });
    }
    if (andFilters.length) where.AND = andFilters;

    const [data, total] = await Promise.all([
      this.prisma.notification_requests.findMany({
        where,
        skip,
        take: limit,
        orderBy: { created_at: 'desc' },
        select: {
          id: true,
          title: true,
          status: true,
          target_type: true,
          scheduled_at: true,
          requester_id: true,
          created_at: true,
        },
      }),
      this.prisma.notification_requests.count({ where }),
    ]);

    return { data, meta: { total, page, limit, totalPages: Math.max(Math.ceil(total / limit), 1) } };
  }

  async updateRequest(id: string, adminId: string, dto: AdminUpdateNotificationRequestDto) {
    await this.ensureRequestExists(id);

    const data: Prisma.notification_requestsUncheckedUpdateInput = {};
    if (dto.status) {
      data.status = dto.status as approval_status;
      data.reviewed_by = adminId;
      data.reviewed_at = new Date();
      if (dto.status === 'approved' && !data.sent_at) {
        data.sent_at = new Date();
      }
    }
    if (dto.rejectionReason !== undefined) data.rejection_reason = dto.rejectionReason;
    if (dto.revisionNotes !== undefined) data.revision_notes = dto.revisionNotes;

    const updated = await this.prisma.notification_requests.update({
      where: { id },
      data,
      select: {
        id: true,
        status: true,
        rejection_reason: true,
        revision_notes: true,
        reviewed_at: true,
        reviewed_by: true,
      },
    });

    return updated;
  }

  async createBroadcast(adminId: string, dto: AdminCreateBroadcastDto) {
    const isApproved = !dto.scheduleAt;
    
    const request = await this.prisma.notification_requests.create({
      data: {
        requester_id: adminId,
        title: dto.title,
        body: dto.body,
        target_type: dto.targetType,
        target_segment: dto.segments ? (dto.segments as any) : undefined,
        action_url: dto.actionUrl,
        scheduled_at: dto.scheduleAt,
        status: isApproved ? 'approved' : 'pending',
        reviewed_by: isApproved ? adminId : null,
        reviewed_at: isApproved ? new Date() : null,
        sent_at: isApproved ? new Date() : null,
      },
      select: {
        id: true,
        title: true,
        status: true,
        scheduled_at: true,
        target_type: true,
      },
    });

    if (isApproved) {
      // Dispatch immediately
      await this.dispatchBroadcast(dto.targetType, dto.title, dto.body, dto.actionUrl);
    }

    return request;
  }

  private async dispatchBroadcast(targetType: string, title: string, body: string, actionUrl?: string) {
    try {
      let sessionWhere: Prisma.UserSessionWhereInput = {
        isActive: true,
        fcmToken: { not: null }
      };

      if (targetType === 'guests') {
        sessionWhere.userId = null;
      } else if (targetType === 'users') {
        sessionWhere.userId = { not: null };
      }
      // 'all' or other types will target everyone by default if no segment filtering is built

      const sessions = await this.prisma.userSession.findMany({
        where: sessionWhere,
        select: { fcmToken: true }
      });

      const tokens = sessions.map(s => s.fcmToken).filter(Boolean) as string[];

      if (tokens.length === 0) {
        this.logger.debug(`No active devices found for broadcast to targetType=${targetType}`);
        return;
      }

      const messaging = this.firebaseService.getMessaging();

      const message = {
        notification: {
          title,
          body,
        },
        data: {
          actionUrl: actionUrl || '',
          broadcast: 'true'
        },
        tokens,
      };

      const response = await messaging.sendEachForMulticast(message);
      this.logger.debug(`Successfully sent broadcast push notifications. Success count: ${response.successCount}, Failure count: ${response.failureCount}`);
    } catch (error) {
      this.logger.error('Failed to dispatch broadcast push notifications:', error);
    }
  }

  private async ensureRequestExists(id: string) {
    const exists = await this.prisma.notification_requests.findUnique({ where: { id }, select: { id: true } });
    if (!exists) throw new NotFoundException('Notification request not found');
  }
}


