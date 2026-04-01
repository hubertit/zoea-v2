import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsUUID,
  IsNumber,
  IsObject,
  ValidateNested,
  IsArray,
  IsEnum,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';

class LocationDto {
  @ApiProperty({ description: 'Latitude', example: -1.9403 })
  @IsNumber()
  lat: number;

  @ApiProperty({ description: 'Longitude', example: 30.0644 })
  @IsNumber()
  lng: number;
}

const cardTypeEnum = ['listing', 'tour', 'product', 'service'] as const;

export class ClientAssistantCardDto {
  @ApiProperty({ enum: cardTypeEnum })
  @IsEnum(cardTypeEnum)
  type: (typeof cardTypeEnum)[number];

  @ApiProperty({ description: 'Entity UUID' })
  @IsUUID()
  id: string;

  @ApiProperty()
  @IsString()
  title: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  subtitle?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  imageUrl?: string;

  @ApiProperty()
  @IsString()
  route: string;

  @ApiPropertyOptional({ description: 'Navigation params JSON object' })
  @IsOptional()
  @IsObject()
  params?: Record<string, unknown>;
}

/**
 * When set, the server stores this assistant reply and skips outbound OpenAI (e.g. device-side completions).
 */
export class ClientAssistantReplyDto {
  @ApiProperty({ description: 'Assistant message text (already generated on the client)' })
  @IsString()
  @MaxLength(32000)
  text: string;

  @ApiPropertyOptional({ type: [ClientAssistantCardDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ClientAssistantCardDto)
  cards?: ClientAssistantCardDto[];

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  suggestions?: string[];
}

export class ChatDto {
  @ApiPropertyOptional({ 
    description: 'Conversation ID (omit to create new conversation)',
    example: '123e4567-e89b-12d3-a456-426614174000'
  })
  @IsUUID()
  @IsOptional()
  conversationId?: string;

  @ApiProperty({ 
    description: 'User message',
    example: 'Find 5 restaurants in Kigali'
  })
  @IsString()
  message: string;

  @ApiPropertyOptional({ 
    description: 'User location (for "near me" queries)',
    type: LocationDto
  })
  @IsOptional()
  @IsObject()
  @ValidateNested()
  @Type(() => LocationDto)
  location?: LocationDto;

  @ApiPropertyOptional({ 
    description: 'Country code to filter content (ISO 2-letter code)',
    example: 'RW'
  })
  @IsOptional()
  @IsString()
  countryCode?: string;

  @ApiPropertyOptional({
    type: ClientAssistantReplyDto,
    description:
      'If provided for an authenticated user, the server saves this reply and does not call OpenAI (mobile may call OpenAI directly when the API host has no outbound internet).',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => ClientAssistantReplyDto)
  clientAssistantReply?: ClientAssistantReplyDto;
}

