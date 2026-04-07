import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class EventsService {
  static const String _baseUrl = 'https://api-prod.sinc.today/events/v1/public';
  final Dio _dio = Dio();

  EventsService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<EventsResponse> getEvents({
    int page = 1,
    int limit = 25,
    String? category,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (category != null) {
        queryParams['category'] = category;
      }
      if (location != null) {
        queryParams['location'] = location;
      }
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/explore-events',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading events: $e');
    }
  }

  Future<EventsResponse> getTrendingEvents({int limit = 25}) async {
    try {
      final response = await _dio.get(
        '/explore-events',
        queryParameters: {
          'limit': limit,
          'sort': 'trending', // Assuming API supports trending sort
        },
      );

      if (response.statusCode == 200) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'cached_trending_events', json.encode(response.data));
        } catch (_) {} // Ignore caching errors
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load trending events: ${response.statusCode}');
      }
    } catch (e) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('cached_trending_events');
        if (cachedData != null) {
          return EventsResponse.fromJson(json.decode(cachedData));
        }
      } catch (_) {} // Fallback to original error if cache fails

      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Error loading trending events: $e');
    }
  }

  Future<EventsResponse> getNearbyEvents({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get(
        '/explore-events',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radiusKm,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load nearby events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading nearby events: $e');
    }
  }

  Future<EventsResponse> getThisWeekEvents({int limit = 25}) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final response = await _dio.get(
        '/explore-events',
        queryParameters: {
          'startDate': startOfWeek.toIso8601String(),
          'endDate': endOfWeek.toIso8601String(),
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load this week events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading this week events: $e');
    }
  }

  Future<EventsResponse> searchEvents({
    required String query,
    int page = 1,
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get(
        '/explore-events',
        queryParameters: {
          'search': query,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error searching events: $e');
    }
  }
}
