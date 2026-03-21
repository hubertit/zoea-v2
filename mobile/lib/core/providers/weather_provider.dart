import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../config/app_config.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

/// Parameters for weather query
class WeatherParams {
  final String cityName;
  final String countryCode;

  const WeatherParams({
    required this.cityName,
    this.countryCode = 'RW',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherParams &&
          runtimeType == other.runtimeType &&
          cityName == other.cityName &&
          countryCode == other.countryCode;

  @override
  int get hashCode => cityName.hashCode ^ countryCode.hashCode;
}

/// Provider for current weather by city
final weatherProvider = FutureProvider.family<Map<String, dynamic>, WeatherParams>(
  (ref, params) async {
    final weatherService = ref.watch(weatherServiceProvider);
    return await weatherService.getCurrentWeather(
      cityName: params.cityName,
      countryCode: params.countryCode,
    );
  },
);

/// Provider for default city weather (Kigali)
final defaultWeatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getCurrentWeather(
    cityName: AppConfig.defaultWeatherCity,
    countryCode: AppConfig.defaultWeatherCountryCode,
  );
});

/// Provider for weather by coordinates
class WeatherCoordinatesParams {
  final double latitude;
  final double longitude;

  const WeatherCoordinatesParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherCoordinatesParams &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

final weatherByCoordinatesProvider = FutureProvider.family<Map<String, dynamic>, WeatherCoordinatesParams>(
  (ref, params) async {
    final weatherService = ref.watch(weatherServiceProvider);
    return await weatherService.getWeatherByCoordinates(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  },
);
