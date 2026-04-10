import 'dart:io' show Platform;
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Must be called in [main] before [runApp] (FlutterFire requirement).
  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Initialize Firebase Messaging and Local Notifications
  static Future<void> init() async {
    // Request permission for iOS/Android 13+
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('🔔 User granted notification permission');
    } else {
      debugPrint('🔕 User declined or has not accepted notification permission');
    }

    // Initialize Local Notifications
    await localNotiInit();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message received: ${message.notification?.title}');
      
      if (message.notification != null) {
        showSimpleNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Handle message open app from background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📲 Notification clicked! Message: ${message.data}');
      // Handle navigation here if needed
    });

    debugPrint('✅ Push Notification Service initialized');
  }

  /// Initialize local notifications
  static Future<void> localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Handle notification tap
  static void onNotificationTap(NotificationResponse notificationResponse) {
    debugPrint('👉 Notification tapped with payload: ${notificationResponse.payload}');
    // You can use a navigator key or a provider to navigate to a specific screen
  }

  /// Get FCM Token — waits for APNS token on iOS before requesting the FCM token
  static Future<String?> getFCMToken() async {
    try {
      if (Platform.isIOS) {
        // On iOS, Firebase needs the APNS token before it can issue an FCM token.
        // Poll for the APNS token with retries up to ~10 seconds total.
        String? apnsToken;
        for (int i = 0; i < 5; i++) {
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) break;
          debugPrint('⏳ Waiting for APNS token (attempt ${i + 1}/5)...');
          await Future.delayed(const Duration(seconds: 2));
        }
        if (apnsToken == null) {
          debugPrint('⚠️ APNS token still null after retries. Skipping FCM token.');
          return null;
        }
        debugPrint('✅ APNS token obtained.');
      }

      final String? token = await _firebaseMessaging.getToken();
      debugPrint('🔑 FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Listen for token refreshes and forward the new token to the backend
  static void listenForTokenRefresh(void Function(String token) onToken) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('🔄 FCM Token refreshed: $newToken');
      onToken(newToken);
    });
  }

  /// Show a simple notification manually (e.g. for foreground messages)
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'zoea_notifications',
      'Zoea Notifications',
      channelDescription: 'Main notification channel for Zoea Africa',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    
    await _localNotificationsPlugin.show(
      DateTime.now().millisecond, // Unique ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

/// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🌙 Handling background message: ${message.messageId}');
}
