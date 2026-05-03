import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _prefsKey = 'app_locale_code';

  LocaleNotifier() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == 'fr' || code == 'en' || code == 'sw') {
      state = Locale(code!);
      return;
    }
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final resolved = localeFromLanguageCode(device.languageCode);
    state = resolved;
    await prefs.setString(_prefsKey, resolved.languageCode);
  }

  /// Public: map API or device code to one of the supported app locales.
  static Locale localeFromLanguageCode(String? code) {
    final normalized = (code ?? '').toLowerCase();
    if (normalized == 'fr') return const Locale('fr');
    if (normalized == 'sw') return const Locale('sw');
    return const Locale('en');
  }

  Future<void> setLanguageCode(String code) async {
    final locale = localeFromLanguageCode(code);
    if (state.languageCode == locale.languageCode) return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  /// Apply server or device preference (en / fr / sw / anything else → en).
  Future<void> applyLanguageCode(String? code) async {
    final normalized = (code ?? '').toLowerCase();
    final target =
        normalized == 'fr' ? 'fr' : normalized == 'sw' ? 'sw' : 'en';
    await setLanguageCode(target);
  }
}
