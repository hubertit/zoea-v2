import 'package:dio/dio.dart';
import '../config/app_config.dart';

class WeatherService {
  final Dio _dio;

  WeatherService() : _dio = AppConfig.dioInstance();

  /// Get current weather for a city from backend API
  /// 
  /// [cityName] - City name (e.g., "Kigali")
  /// [countryCode] - ISO 3166 country code (e.g., "RW" for Rwanda)
  Future<Map<String, dynamic>> getCurrentWeather({
    required String cityName,
    String countryCode = 'RW',
  }) async {
    try {
      final response = await _dio.get(
        '/weather/current',
        queryParameters: {
          'city': cityName,
          'country': countryCode,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('City not found');
      } else if (e.response?.statusCode == 503) {
        throw Exception('Weather service unavailable');
      } else {
        throw Exception('Failed to fetch weather: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get weather by coordinates (latitude, longitude) from backend API
  Future<Map<String, dynamic>> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        '/weather/coordinates',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch weather: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get weather icon based on OpenWeatherMap icon code
  static String getWeatherIconCode(String iconCode) {
    final code = iconCode.substring(0, 2);
    switch (code) {
      case '01':
        return 'clear';
      case '02':
        return 'partly_cloudy';
      case '03':
      case '04':
        return 'cloudy';
      case '09':
      case '10':
        return 'rainy';
      case '11':
        return 'thunderstorm';
      case '13':
        return 'snowy';
      case '50':
        return 'misty';
      default:
        return 'clear';
    }
  }
}
