import { Body, Controller, Get, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Roles } from '../../common/decorators/roles.decorator';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AppUpdateService } from './app-update.service';
import { AdminMobileAppUpdateBodyDto } from './dto/admin-mobile-app-update.dto';

@ApiTags('Admin - Mobile app')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin', 'super_admin')
@Controller('admin/mobile-app-update')
export class AdminMobileAppUpdateController {
  constructor(private readonly appUpdateService: AppUpdateService) {}

  @Get()
  @ApiOperation({ summary: 'Get mobile app update policy (iOS + Android)' })
  async getPolicy() {
    return this.appUpdateService.getAdminPolicy();
  }

  @Put()
  @ApiOperation({ summary: 'Update mobile app update policy' })
  async putPolicy(@Body() body: AdminMobileAppUpdateBodyDto) {
    return this.appUpdateService.saveAdminPolicy({
      ios: body.ios,
      android: body.android,
      isActive: body.isActive,
    });
  }
}
