import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/user_data_collection_provider.dart';
import 'core/providers/health_check_provider.dart';
import 'core/widgets/app_update_layer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage FIRST
  await Hive.initFlutter();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    // Initialize Push Notifications
    await PushNotificationService.init();
    
    // Register FCM token even for guests
    try {
      // Listen for token refreshes — this fires whenever Firebase gets/refreshes its token.
      // This is the most reliable way to capture the token on iOS.
      PushNotificationService.listenForTokenRefresh((token) {
        Future.microtask(() async {
          try {
            final dio = AppConfig.dioInstance();
            await dio.put('/users/fcm-token', data: {'fcmToken': token});
            debugPrint('✅ FCM token saved via refresh listener');
          } catch (e) {
            debugPrint('Failed to send refreshed FCM token: $e');
          }
        });
      });

      // Also try to get it immediately (works on Android and on iOS when APNS is ready)
      final token = await PushNotificationService.getFCMToken();
      if (token != null) {
        Future.microtask(() async {
          try {
            final dio = AppConfig.dioInstance();
            await dio.put('/users/fcm-token', data: {'fcmToken': token});
            debugPrint('✅ Successfully sent guest FCM token to backend');
          } catch (e) {
            debugPrint('Failed to send guest FCM token async: $e');
          }
        });
      } else {
        debugPrint('⚠️ FCM token is null on startup — will be sent via refresh listener when ready');
      }
    } catch (e) {
      debugPrint('Failed to send guest FCM token: $e');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app going to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _uploadAnalyticsBatch();
      // Pause health checks to save battery and network
      ref.read(healthCheckProvider.notifier).pause();
    }
    
    // Handle app coming to foreground
    if (state == AppLifecycleState.resumed) {
      // Resume health checks
      ref.read(healthCheckProvider.notifier).resume();
    }
  }

  Future<void> _uploadAnalyticsBatch() async {
    try {
      final analyticsService = ref.read(analyticsServiceProvider);
      await analyticsService.forceUpload();
    } catch (e) {
      // Silently fail - analytics should never break the app
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return AppUpdateLayer(child: child);
      },
    );
  }
}