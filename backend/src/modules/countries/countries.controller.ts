import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { CountriesService } from './countries.service';

@ApiTags('Countries')
@Controller('countries')
export class CountriesController {
  constructor(private readonly countriesService: CountriesService) {}

  /**
   * Get all active countries
   * Public endpoint - no authentication required
   */
  @Get('active')
  @ApiOperation({ 
    summary: 'Get all active countries',
    description: 'Retrieves all active countries. Public endpoint accessible without authentication. Used for country selection in the app.'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Active countries retrieved successfully',
    schema: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          name: { type: 'string', example: 'Rwanda' },
          code2: { type: 'string', example: 'RW' },
          code3: { type: 'string', example: 'RWA' },
          isActive: { type: 'boolean', example: true }
        }
      }
    }
  })
  async getActiveCountries() {
    return this.countriesService.findActive();
  }

  /**
   * Get country by ID
   * Public endpoint - no authentication required
   */
  @Get(':id')
  @ApiOperation({ 
    summary: 'Get country by ID',
    description: 'Retrieves a specific country by UUID. Public endpoint accessible without authentication.'
  })
  @ApiParam({ name: 'id', type: String, description: 'Country UUID' })
  @ApiResponse({ status: 200, description: 'Country retrieved successfully' })
  @ApiResponse({ status: 404, description: 'Country not found' })
  async getCountryById(@Param('id') id: string) {
    return this.countriesService.findById(id);
  }

  /**
   * Get country by 2-letter code
   * Public endpoint - no authentication required
   */
  @Get('code/:code')
  @ApiOperation({ 
    summary: 'Get country by code',
    description: 'Retrieves a specific country by its 2-letter ISO code. Public endpoint accessible without authentication.'
  })
  @ApiParam({ name: 'code', type: String, description: '2-letter country code', example: 'RW' })
  @ApiResponse({ status: 200, description: 'Country retrieved successfully' })
  @ApiResponse({ status: 404, description: 'Country not found' })
  async getCountryByCode(@Param('code') code: string) {
    return this.countriesService.findByCode(code);
  }

  /**
   * Get cities for a country
   * Public endpoint - no authentication required
   */
  @Get(':id/cities')
  @ApiOperation({ 
    summary: 'Get cities for a country',
    description: 'Retrieves all cities for a specific country. Public endpoint accessible without authentication. Used for city selection and location filtering.'
  })
  @ApiParam({ name: 'id', type: String, description: 'Country UUID' })
  @ApiResponse({ 
    status: 200, 
    description: 'Cities retrieved successfully',
    schema: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          name: { type: 'string', example: 'Kigali' },
          countryId: { type: 'string' }
        }
      }
    }
  })
  async getCountryCities(@Param('id') id: string) {
    return this.countriesService.findCitiesByCountry(id);
  }

  /**
   * Get all countries (including inactive)
   * Public endpoint - no authentication required
   */
  @Get()
  @ApiOperation({ 
    summary: 'Get all countries',
    description: 'Retrieves all countries including inactive ones. Public endpoint accessible without authentication.'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Countries retrieved successfully',
    schema: {
      type: 'array',
      items: { type: 'object' }
    }
  })
  async getAllCountries() {
    return this.countriesService.findAll();
  }
}
