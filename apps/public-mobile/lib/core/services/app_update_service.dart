import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_config.dart';

/// Response from [GET /app/update-check].
class AppUpdateCheckResult {
  AppUpdateCheckResult({
    required this.updateRequired,
    required this.mode,
    required this.title,
    required this.message,
    required this.storeUrl,
    required this.dismissForDays,
    required this.policyFingerprint,
  });

  final bool updateRequired;
  final String mode;
  final String title;
  final String message;
  final String storeUrl;
  final int dismissForDays;
  final String policyFingerprint;

  factory AppUpdateCheckResult.fromJson(Map<String, dynamic> json) {
    return AppUpdateCheckResult(
      updateRequired: json['updateRequired'] == true,
      mode: json['mode']?.toString() ?? 'none',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      storeUrl: json['storeUrl']?.toString() ?? '',
      dismissForDays: (json['dismissForDays'] is num)
          ? (json['dismissForDays'] as num).toInt().clamp(1, 365)
          : 7,
      policyFingerprint: json['policyFingerprint']?.toString() ?? '',
    );
  }
}

/// Public API check for in-app update prompts (fail-open on errors).
class AppUpdateService {
  AppUpdateService({Dio? dio}) : _dio = dio ?? AppConfig.dioInstance();

  final Dio _dio;

  Future<AppUpdateCheckResult?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final platform = Platform.isIOS ? 'ios' : 'android';
      final build = int.tryParse(info.buildNumber) ?? 0;
      final response = await _dio.get<Map<String, dynamic>>(
        '/app/update-check',
        queryParameters: {
          'platform': platform,
          'version': info.version,
          'build': build,
        },
      );
      final data = response.data;
      if (data == null) return null;
      return AppUpdateCheckResult.fromJson(data);
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
