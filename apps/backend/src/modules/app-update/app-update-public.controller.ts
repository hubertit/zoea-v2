import { Controller, Get, Query } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AppUpdateService } from './app-update.service';
import { CheckAppUpdateQueryDto } from './dto/check-app-update.dto';

@ApiTags('App')
@Controller('app')
export class AppUpdatePublicController {
  constructor(private readonly appUpdateService: AppUpdateService) {}

  @Get('update-check')
  @ApiOperation({
    summary: 'Check if the mobile app should prompt for an update',
    description: 'Public endpoint. Compares client version/build to configured minimums.',
  })
  async checkUpdate(@Query() query: CheckAppUpdateQueryDto) {
    const build = query.build ?? 0;
    return this.appUpdateService.checkUpdate(query.platform, query.version, build);
  }
}
