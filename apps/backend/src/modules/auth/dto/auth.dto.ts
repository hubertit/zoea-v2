import { IsEmail, IsString, IsOptional, MinLength, MaxLength, Length } from 'class-validator';
import { Transform } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiPropertyOptional()
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  phoneNumber?: string;

  @ApiProperty()
  @IsString()
  @MinLength(6)
  password: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  fullName?: string;

  @ApiPropertyOptional({
    description: 'Optional referral code from a friend; applied if valid (signup only).',
    example: 'ZOEAXYZ1',
  })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  @Transform(({ value }) =>
    typeof value === 'string' ? value.trim().toUpperCase().slice(0, 20) : value,
  )
  referralCode?: string;
}

export class LoginDto {
  @ApiProperty({ description: 'Email or phone number' })
  @IsString()
  identifier: string;

  @ApiProperty()
  @IsString()
  password: string;
}

export class RefreshTokenDto {
  @ApiProperty()
  @IsString()
  refreshToken: string;
}

export class FirebaseLoginDto {
  @ApiProperty({
    description: 'Firebase Auth ID token (after Google Sign-In on the app).',
    example: 'eyJhbGciOiJSUzI1NiIs...',
  })
  @IsString()
  idToken: string;
}

export class RequestPasswordResetDto {
  @ApiProperty({ 
    description: 'Email address or phone number',
    example: 'user@example.com' 
  })
  @IsString()
  identifier: string;
}

export class VerifyResetCodeDto {
  @ApiProperty({ 
    description: 'Email address or phone number',
    example: 'user@example.com' 
  })
  @IsString()
  identifier: string;

  @ApiProperty({ 
    description: 'Reset code sent by SMS',
    example: '123456' 
  })
  @IsString()
  code: string;
}

export class ResetPasswordDto {
  @ApiProperty({ 
    description: 'Email address or phone number',
    example: 'user@example.com' 
  })
  @IsString()
  identifier: string;

  @ApiProperty({ 
    description: 'Reset code sent to email/phone',
    example: '123456' 
  })
  @IsString()
  code: string;

  @ApiProperty({ 
    description: 'New password (minimum 6 characters)',
    example: 'newPassword123',
    minLength: 6 
  })
  @IsString()
  @MinLength(6)
  newPassword: string;
}

export class RequestPhoneVerificationDto {
  @ApiProperty({ description: 'International digits, e.g. 250788123456', example: '250788123456' })
  @IsString()
  phoneNumber: string;
}

export class VerifyPhoneVerificationDto {
  @ApiProperty({ example: '250788123456' })
  @IsString()
  phoneNumber: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @Length(6, 6)
  code: string;
}

