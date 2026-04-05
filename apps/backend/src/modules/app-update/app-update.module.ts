import { Module } from '@nestjs/common';
import { PrismaModule } from '../../prisma/prisma.module';
import { AppUpdateService } from './app-update.service';
import { AppUpdatePublicController } from './app-update-public.controller';
import { AdminMobileAppUpdateController } from './admin-mobile-app-update.controller';

@Module({
  imports: [PrismaModule],
  controllers: [AppUpdatePublicController, AdminMobileAppUpdateController],
  providers: [AppUpdateService],
  exports: [AppUpdateService],
})
export class AppUpdateModule {}
