import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { WeatherService } from './weather.service';

@ApiTags('Weather')
@Controller('weather')
export class WeatherController {
  constructor(private weatherService: WeatherService) {}

  @Get('current')
  @ApiOperation({ 
    summary: 'Get current weather for a city',
    description: 'Retrieve current weather information for a specified city. No authentication required.'
  })
  @ApiQuery({ 
    name: 'city', 
    required: false, 
    type: String, 
    example: 'Kigali',
    description: 'City name (defaults to Kigali)'
  })
  @ApiQuery({ 
    name: 'country', 
    required: false, 
    type: String, 
    example: 'RW',
    description: 'ISO 3166 country code (defaults to RW)'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Weather data retrieved successfully',
    schema: {
      example: {
        cityName: 'Kigali',
        temperature: 22.5,
        feelsLike: 23.1,
        tempMin: 21.0,
        tempMax: 24.0,
        humidity: 65,
        pressure: 1013,
        weatherMain: 'Clouds',
        weatherDescription: 'scattered clouds',
        weatherIcon: '03d',
        cloudiness: 40,
        rainProbability: 5,
        windSpeed: 3.5,
        timestamp: '2026-03-21T11:30:00.000Z'
      }
    }
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 503, description: 'Weather service unavailable' })
  async getCurrentWeather(
    @Query('city') city: string = 'Kigali',
    @Query('country') country: string = 'RW',
  ) {
    return this.weatherService.getCurrentWeather(city, country);
  }

  @Get('coordinates')
  @ApiOperation({ 
    summary: 'Get weather by coordinates',
    description: 'Retrieve current weather information for specified GPS coordinates. No authentication required.'
  })
  @ApiQuery({ 
    name: 'lat', 
    required: true, 
    type: Number, 
    example: -1.9536,
    description: 'Latitude'
  })
  @ApiQuery({ 
    name: 'lon', 
    required: true, 
    type: Number, 
    example: 30.0606,
    description: 'Longitude'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Weather data retrieved successfully'
  })
  @ApiResponse({ status: 400, description: 'Bad request - Invalid coordinates' })
  @ApiResponse({ status: 503, description: 'Weather service unavailable' })
  async getWeatherByCoordinates(
    @Query('lat') lat: string,
    @Query('lon') lon: string,
  ) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);

    if (isNaN(latitude) || isNaN(longitude)) {
      throw new Error('Invalid coordinates');
    }

    return this.weatherService.getWeatherByCoordinates(latitude, longitude);
  }
}
