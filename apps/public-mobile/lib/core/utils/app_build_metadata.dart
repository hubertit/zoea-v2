import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Optional ISO-8601 timestamp injected at release build, e.g.
/// `--dart-define=APP_BUILD_TIME_ISO=2026-04-10T15:30:00Z`
const String _kBuildTimeIso = String.fromEnvironment(
  'APP_BUILD_TIME_ISO',
  defaultValue: '',
);

/// User-visible OS (mobile targets: iOS / Android; no framework suffix).
String describeRuntimePlatform() {
  if (kIsWeb) {
    return 'Web';
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'Android';
    case TargetPlatform.iOS:
      return 'iOS';
    case TargetPlatform.macOS:
      return 'macOS';
    case TargetPlatform.windows:
      return 'Windows';
    case TargetPlatform.linux:
      return 'Linux';
    case TargetPlatform.fuchsia:
      return 'Fuchsia';
  }
}

/// Prefer mobile app update policy [policyUpdatedAtIso], then [APP_BUILD_TIME_ISO], then [fallback].
String lastUpdatedDisplayLabel({
  String? policyUpdatedAtIso,
  required String fallback,
  String? intlLocale,
}) {
  final iso = policyUpdatedAtIso?.trim();
  if (iso != null && iso.isNotEmpty) {
    final dt = DateTime.tryParse(iso);
    if (dt != null) {
      return DateFormat.yMMMMd(intlLocale).format(dt.toLocal());
    }
  }
  return buildTimeDisplayLabel(fallback: fallback, intlLocale: intlLocale);
}

/// Build / release date when [APP_BUILD_TIME_ISO] is set; otherwise [fallback].
String buildTimeDisplayLabel({
  required String fallback,
  String? intlLocale,
}) {
  if (_kBuildTimeIso.isEmpty) return fallback;
  final dt = DateTime.tryParse(_kBuildTimeIso);
  if (dt == null) return _kBuildTimeIso;
  return DateFormat.yMMMMd(intlLocale).format(dt.toLocal());
}

String localeDisplayLabel(Locale locale) {
  final cc = locale.countryCode;
  if (cc != null && cc.isNotEmpty) {
    return '${locale.languageCode.toUpperCase()}-$cc';
  }
  return locale.languageCode.toUpperCase();
}
