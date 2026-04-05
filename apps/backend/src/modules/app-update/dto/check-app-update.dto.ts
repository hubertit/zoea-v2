import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class CheckAppUpdateQueryDto {
  @ApiProperty({ enum: ['ios', 'android'] })
  @IsString()
  @IsIn(['ios', 'android'])
  platform: 'ios' | 'android';

  @ApiProperty({ example: '2.1.18', description: 'Semantic version from the app (CFBundleShortVersionString / versionName)' })
  @IsString()
  version: string;

  @ApiPropertyOptional({ example: 27, description: 'Build number (CFBundleVersion / versionCode)' })
  @IsOptional()
  @Transform(({ value }) => (value === undefined || value === '' ? 0 : parseInt(String(value), 10)))
  @IsInt()
  @Min(0)
  build?: number;
}
