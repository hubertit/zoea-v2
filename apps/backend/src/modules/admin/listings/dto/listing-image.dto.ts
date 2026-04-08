import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString, IsUUID } from 'class-validator';

export class AdminAddListingImageDto {
  @ApiProperty({ description: 'Media ID from POST /media/upload', format: 'uuid' })
  @IsUUID()
  mediaId: string;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  isPrimary?: boolean;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  caption?: string;
}

export class AdminSetPrimaryListingImageDto {
  @ApiProperty({ description: 'Listing image row id (listing_images.id)', format: 'uuid' })
  @IsUUID()
  imageId: string;
}
