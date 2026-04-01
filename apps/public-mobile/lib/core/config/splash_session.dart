import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/splash_assets.dart';

const _prefsKeyLastSplash = 'splash_last_background_path';

/// Chosen in [warmUpSplashBackground] before [runApp].
/// Do not use [rootBundle.load] here to “verify” assets — it can fail spuriously
/// before the embedder has wired the bundle, which hid all photos behind the fallback.
String splashAssetPathForSession = kSplashBackgroundAssetPaths.first;

Future<void> warmUpSplashBackground() async {
  try {
    const options = kSplashBackgroundAssetPaths;
    if (options.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_prefsKeyLastSplash);
    final candidates = last != null
        ? options.where((p) => p != last).toList()
        : List<String>.from(options);
    final pool = candidates.isEmpty ? options : candidates;
    final pick = pool[Random().nextInt(pool.length)];

    await prefs.setString(_prefsKeyLastSplash, pick);
    splashAssetPathForSession = pick;
  } catch (_) {
    const options = kSplashBackgroundAssetPaths;
    if (options.length > 1) {
      splashAssetPathForSession =
          options[Random().nextInt(options.length)];
    }
  }
}
