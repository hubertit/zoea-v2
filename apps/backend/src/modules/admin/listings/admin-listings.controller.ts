import { Body, Controller, Delete, Get, Param, Patch, Post, Put, Query, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Roles } from '../../../common/decorators/roles.decorator';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { AdminListingsService } from './admin-listings.service';
import { AdminListListingsDto } from './dto/list-listings.dto';
import { AdminUpdateListingStatusDto } from './dto/update-listing-status.dto';
import { AdminCreateListingDto, AdminUpdateListingDto } from './dto/create-listing.dto';
import { AdminAddListingImageDto, AdminSetPrimaryListingImageDto } from './dto/listing-image.dto';

@ApiTags('Admin - Listings')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin', 'super_admin')
@Controller('admin/listings')
export class AdminListingsController {
  constructor(private readonly adminListingsService: AdminListingsService) {}

  @Get()
  @ApiOperation({ summary: 'List listings with filters/pagination' })
  async list(@Query() query: AdminListListingsDto) {
    return this.adminListingsService.listListings(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get listing detail' })
  async getById(@Param('id') id: string) {
    return this.adminListingsService.getListingById(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create listing on behalf of merchant' })
  async create(@Request() req: { user: { id: string } }, @Body() dto: AdminCreateListingDto) {
    return this.adminListingsService.createListing(dto, req.user.id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update listing content' })
  async update(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Body() dto: AdminUpdateListingDto,
  ) {
    return this.adminListingsService.updateListing(id, dto, req.user.id);
  }

  @Patch(':id/status')
  @ApiOperation({ summary: 'Update listing moderation/feature state' })
  async updateStatus(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Body() dto: AdminUpdateListingStatusDto,
  ) {
    return this.adminListingsService.updateListingStatus(id, dto, req.user.id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Soft delete listing' })
  async delete(@Request() req: { user: { id: string } }, @Param('id') id: string) {
    return this.adminListingsService.deleteListing(id, req.user.id);
  }

  @Patch(':id/restore')
  @ApiOperation({ summary: 'Restore soft deleted listing' })
  async restore(@Request() req: { user: { id: string } }, @Param('id') id: string) {
    return this.adminListingsService.restoreListing(id, req.user.id);
  }

  @Post(':id/images')
  @ApiOperation({ summary: 'Add listing image (media must be uploaded first)' })
  async addImage(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Body() dto: AdminAddListingImageDto,
  ) {
    return this.adminListingsService.addListingImage(id, dto, req.user.id);
  }

  @Delete(':id/images/:imageId')
  @ApiOperation({ summary: 'Remove a listing image' })
  async removeImage(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Param('imageId') imageId: string,
  ) {
    return this.adminListingsService.removeListingImage(id, imageId, req.user.id);
  }

  @Patch(':id/images/primary')
  @ApiOperation({ summary: 'Set primary listing image' })
  async setPrimaryImage(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Body() dto: AdminSetPrimaryListingImageDto,
  ) {
    return this.adminListingsService.setPrimaryListingImage(id, dto.imageId, req.user.id);
  }
}


