import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsIn, IsInt, IsOptional, IsString, Max, Min, ValidateNested } from 'class-validator';
import type { MobileUpdateMode } from '../mobile-app-update.types';

export class AdminMobilePlatformPolicyDto {
  @ApiPropertyOptional({ example: '2.0.0' })
  @IsOptional()
  @IsString()
  minVersion?: string;

  @ApiPropertyOptional({ nullable: true, description: 'If set, client build must be >= this when version equals minVersion' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  minBuild?: number | null;

  @ApiPropertyOptional({ enum: ['none', 'optional', 'mandatory'] })
  @IsOptional()
  @IsIn(['none', 'optional', 'mandatory'])
  mode?: MobileUpdateMode;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  message?: string;

  @ApiPropertyOptional({ description: 'App Store or Play Store URL' })
  @IsOptional()
  @IsString()
  storeUrl?: string;

  @ApiPropertyOptional({ description: 'Days to snooze optional prompt', minimum: 1, maximum: 365 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(365)
  dismissForDays?: number;
}

export class AdminMobileAppUpdateBodyDto {
  @ApiPropertyOptional()
  @IsOptional()
  @ValidateNested()
  @Type(() => AdminMobilePlatformPolicyDto)
  ios?: AdminMobilePlatformPolicyDto;

  @ApiPropertyOptional()
  @IsOptional()
  @ValidateNested()
  @Type(() => AdminMobilePlatformPolicyDto)
  android?: AdminMobilePlatformPolicyDto;

  @ApiPropertyOptional({ description: 'When false, public check uses default "no update" policy' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
