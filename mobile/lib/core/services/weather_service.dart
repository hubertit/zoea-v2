import 'package:dio/dio.dart';

class WeatherService {
  final Dio _dio;
  static const String _openMeteoBaseUrl = 'https://api.open-meteo.com/v1';

  // City coordinates mapping for major African cities
  static const Map<String, Map<String, dynamic>> _cityCoordinates = {
    'kigali': {'lat': -1.9536, 'lon': 30.0606, 'name': 'Kigali'},
    'nairobi': {'lat': -1.2921, 'lon': 36.8219, 'name': 'Nairobi'},
    'kampala': {'lat': 0.3476, 'lon': 32.5825, 'name': 'Kampala'},
    'dar es salaam': {'lat': -6.7924, 'lon': 39.2083, 'name': 'Dar es Salaam'},
    'addis ababa': {'lat': 9.0320, 'lon': 38.7469, 'name': 'Addis Ababa'},
    'lagos': {'lat': 6.5244, 'lon': 3.3792, 'name': 'Lagos'},
    'accra': {'lat': 5.6037, 'lon': -0.1870, 'name': 'Accra'},
  };

  WeatherService()
      : _dio = Dio(BaseOptions(
          baseUrl: _openMeteoBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  /// Get current weather for a city by calling Open-Meteo API directly
  ///
  /// [cityName] - City name (e.g., "Kigali")
  /// [countryCode] - ISO 3166 country code (not used with Open-Meteo)
  Future<Map<String, dynamic>> getCurrentWeather({
    required String cityName,
    String countryCode = 'RW',
  }) async {
    try {
      final cityKey = cityName.toLowerCase();
      final coords = _cityCoordinates[cityKey] ?? _cityCoordinates['kigali']!;

      return await getWeatherByCoordinates(
        latitude: coords['lat'] as double,
        longitude: coords['lon'] as double,
        cityName: coords['name'] as String,
      );
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Get weather by coordinates (latitude, longitude) from Open-Meteo API
  Future<Map<String, dynamic>> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
    String? cityName,
  }) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current':
              'temperature_2m,relative_humidity_2m,precipitation,weather_code,cloud_cover,wind_speed_10m',
          'timezone': 'Africa/Kigali',
        },
      );

      return _parseOpenMeteoResponse(response.data, cityName);
    } on DioException catch (e) {
      throw Exception('Failed to fetch weather: ${e.message}');
    }
  }

  Map<String, dynamic> _parseOpenMeteoResponse(
      Map<String, dynamic> data, String? cityName) {
    final current = data['current'] as Map<String, dynamic>? ?? {};
    final temperature = (current['temperature_2m'] as num?)?.toDouble() ?? 0.0;
    final humidity = (current['relative_humidity_2m'] as num?)?.toInt() ?? 0;
    final precipitation =
        (current['precipitation'] as num?)?.toDouble() ?? 0.0;
    final weatherCode = (current['weather_code'] as num?)?.toInt() ?? 0;
    final cloudCover = (current['cloud_cover'] as num?)?.toInt() ?? 0;
    final windSpeed = (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0;

    // Calculate rain probability
    int rainProbability = 0;
    if (precipitation > 0) {
      rainProbability = (precipitation * 30).round().clamp(0, 100);
    } else if (cloudCover > 80) {
      rainProbability = 30;
    } else if (cloudCover > 60) {
      rainProbability = 15;
    } else if (cloudCover > 40) {
      rainProbability = 5;
    }

    final weatherInfo = _getWeatherInfo(weatherCode);

    return {
      'cityName': cityName ?? 'Location',
      'temperature': temperature,
      'feelsLike': temperature,
      'humidity': humidity,
      'weatherMain': weatherInfo['main'],
      'weatherDescription': weatherInfo['description'],
      'weatherIcon': weatherInfo['icon'],
      'cloudiness': cloudCover,
      'rainProbability': rainProbability,
      'windSpeed': windSpeed,
      'precipitation': precipitation,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Map<String, String> _getWeatherInfo(int code) {
    // WMO Weather interpretation codes
    if (code == 0) {
      return {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'};
    }
    if (code == 1) {
      return {'main': 'Clear', 'description': 'mainly clear', 'icon': '01d'};
    }
    if (code == 2) {
      return {'main': 'Clouds', 'description': 'partly cloudy', 'icon': '02d'};
    }
    if (code == 3) {
      return {'main': 'Clouds', 'description': 'overcast', 'icon': '03d'};
    }
    if (code >= 45 && code <= 48) {
      return {'main': 'Fog', 'description': 'foggy', 'icon': '50d'};
    }
    if (code >= 51 && code <= 55) {
      return {'main': 'Drizzle', 'description': 'drizzle', 'icon': '09d'};
    }
    if (code >= 61 && code <= 65) {
      return {'main': 'Rain', 'description': 'rain', 'icon': '10d'};
    }
    if (code >= 71 && code <= 77) {
      return {'main': 'Snow', 'description': 'snow', 'icon': '13d'};
    }
    if (code >= 80 && code <= 82) {
      return {'main': 'Rain', 'description': 'rain showers', 'icon': '09d'};
    }
    if (code >= 95 && code <= 99) {
      return {
        'main': 'Thunderstorm',
        'description': 'thunderstorm',
        'icon': '11d'
      };
    }

    return {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'};
  }
}

