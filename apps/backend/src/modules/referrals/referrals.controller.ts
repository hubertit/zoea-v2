import { Controller, Get, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ReferralsService } from './referrals.service';

@ApiTags('Referrals')
@Controller('referrals')
export class ReferralsController {
  constructor(private readonly referralsService: ReferralsService) {}

  @Get('program')
  @ApiOperation({
    summary: 'Get active referral program (points rules)',
    description:
      'Returns the currently active referral program rule for public UI (referrer and referee points). No authentication required.',
  })
  @ApiResponse({ status: 200, description: 'Program rule or null if none configured' })
  async getProgram() {
    return this.referralsService.getActiveProgram();
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Get my referral code and stats',
    description:
      'Returns the authenticated user referral code (creating one if needed), share URL, point stats, and active program snapshot.',
  })
  @ApiResponse({ status: 200, description: 'Referral summary' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async getMine(@Request() req: { user: { id: string } }) {
    return this.referralsService.getMyReferralSummary(req.user.id);
  }
}
