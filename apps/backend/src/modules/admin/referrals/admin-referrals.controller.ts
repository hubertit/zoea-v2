import { Controller, Param, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Roles } from '../../../common/decorators/roles.decorator';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ReferralsService } from '../../referrals/referrals.service';

@ApiTags('Admin - Referrals')
@ApiBearerAuth('JWT-auth')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin', 'super_admin')
@Controller('admin/referrals')
export class AdminReferralsController {
  constructor(private readonly referralsService: ReferralsService) {}

  @Post('actions/credit-all-pending-signup')
  @ApiOperation({
    summary: 'Credit all pending signup referral rewards',
    description:
      'Sets signup_referrer / signup_referee rewards from pending to credited, updates referral_codes aggregates where rows exist. Processes each distinct referral_id once.',
  })
  async creditAllPendingSignup() {
    return this.referralsService.creditAllPendingSignupRewards();
  }

  @Post(':referralId/credit-pending')
  @ApiOperation({
    summary: 'Credit pending rewards for one referral',
    description:
      'Moves all pending referral_rewards for the given referrals.id to credited and syncs inviter/referee referral_codes totals when present.',
  })
  async creditPendingForReferral(@Param('referralId') referralId: string) {
    return this.referralsService.creditPendingRewardsForReferral(referralId);
  }
}
