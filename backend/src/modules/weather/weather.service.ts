import { Injectable, Logger } from '@nestjs/common';
import axios from 'axios';

export interface WeatherData {
  cityName: string;
  temperature: number;
  feelsLike: number;
  humidity: number;
  weatherMain: string;
  weatherDescription: string;
  weatherIcon: string;
  cloudiness: number;
  rainProbability: number;
  windSpeed: number;
  precipitation: number;
  timestamp: string;
}

@Injectable()
export class WeatherService {
  private readonly logger = new Logger(WeatherService.name);
  private readonly openMeteoBaseUrl = 'https://api.open-meteo.com/v1';

  // City coordinates mapping for major African cities
  private readonly cityCoordinates: Record<string, { lat: number; lon: number; name: string }> = {
    'kigali': { lat: -1.9536, lon: 30.0606, name: 'Kigali' },
    'nairobi': { lat: -1.2921, lon: 36.8219, name: 'Nairobi' },
    'kampala': { lat: 0.3476, lon: 32.5825, name: 'Kampala' },
    'dar es salaam': { lat: -6.7924, lon: 39.2083, name: 'Dar es Salaam' },
    'addis ababa': { lat: 9.0320, lon: 38.7469, name: 'Addis Ababa' },
    'lagos': { lat: 6.5244, lon: 3.3792, name: 'Lagos' },
    'accra': { lat: 5.6037, lon: -0.1870, name: 'Accra' },
  };

  async getCurrentWeather(cityName: string, countryCode: string = 'RW'): Promise<WeatherData> {
    try {
      const cityKey = cityName.toLowerCase();
      const coords = this.cityCoordinates[cityKey] || this.cityCoordinates['kigali'];

      return await this.getWeatherByCoordinates(coords.lat, coords.lon, coords.name);
    } catch (error) {
      this.logger.error(`Failed to fetch weather for ${cityName}`, error.message);
      throw error;
    }
  }

  async getWeatherByCoordinates(latitude: number, longitude: number, cityName?: string): Promise<WeatherData> {
    try {
      const response = await axios.get(`${this.openMeteoBaseUrl}/forecast`, {
        params: {
          latitude,
          longitude,
          current: 'temperature_2m,relative_humidity_2m,precipitation,weather_code,cloud_cover,wind_speed_10m',
          timezone: 'Africa/Kigali',
        },
        timeout: 5000,
      });

      return this.parseOpenMeteoResponse(response.data, cityName);
    } catch (error) {
      this.logger.error(`Failed to fetch weather for coordinates (${latitude}, ${longitude})`, error.message);
      throw error;
    }
  }

  private parseOpenMeteoResponse(data: any, cityName?: string): WeatherData {
    const current = data.current || {};
    const temperature = current.temperature_2m || 0;
    const humidity = current.relative_humidity_2m || 0;
    const precipitation = current.precipitation || 0;
    const weatherCode = current.weather_code || 0;
    const cloudCover = current.cloud_cover || 0;
    const windSpeed = current.wind_speed_10m || 0;

    // Calculate rain probability from precipitation and cloud cover
    let rainProbability = 0;
    if (precipitation > 0) {
      rainProbability = Math.min(Math.round(precipitation * 30), 100);
    } else if (cloudCover > 80) {
      rainProbability = 30;
    } else if (cloudCover > 60) {
      rainProbability = 15;
    } else if (cloudCover > 40) {
      rainProbability = 5;
    }

    // Map WMO weather code to description and icon
    const weatherInfo = this.getWeatherInfo(weatherCode);

    return {
      cityName: cityName || 'Location',
      temperature,
      feelsLike: temperature,
      humidity,
      weatherMain: weatherInfo.main,
      weatherDescription: weatherInfo.description,
      weatherIcon: weatherInfo.icon,
      cloudiness: cloudCover,
      rainProbability,
      windSpeed,
      precipitation,
      timestamp: new Date().toISOString(),
    };
  }

  private getWeatherInfo(code: number): { main: string; description: string; icon: string } {
    // WMO Weather interpretation codes
    // https://open-meteo.com/en/docs
    if (code === 0) return { main: 'Clear', description: 'clear sky', icon: '01d' };
    if (code === 1) return { main: 'Clear', description: 'mainly clear', icon: '01d' };
    if (code === 2) return { main: 'Clouds', description: 'partly cloudy', icon: '02d' };
    if (code === 3) return { main: 'Clouds', description: 'overcast', icon: '03d' };
    if (code >= 45 && code <= 48) return { main: 'Fog', description: 'foggy', icon: '50d' };
    if (code >= 51 && code <= 55) return { main: 'Drizzle', description: 'drizzle', icon: '09d' };
    if (code >= 61 && code <= 65) return { main: 'Rain', description: 'rain', icon: '10d' };
    if (code >= 71 && code <= 77) return { main: 'Snow', description: 'snow', icon: '13d' };
    if (code >= 80 && code <= 82) return { main: 'Rain', description: 'rain showers', icon: '09d' };
    if (code >= 95 && code <= 99) return { main: 'Thunderstorm', description: 'thunderstorm', icon: '11d' };
    
    return { main: 'Clear', description: 'clear sky', icon: '01d' };
  }
}
