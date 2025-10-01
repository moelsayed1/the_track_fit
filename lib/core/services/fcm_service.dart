import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/services/notification_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'dart:convert';
import 'dart:developer';

// Handle background messages - Must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('📩 Background message: ${message.messageId}');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Data: ${message.data}');

  // Save notification to local storage
  if (message.notification != null) {
    final notification = NotificationService.fromFCMData(
      messageId: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification!.title ?? 'Notification',
      body: message.notification!.body ?? '',
      data: message.data,
    );
    await NotificationService.addNotification(notification);
  }
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final ApiService _apiService = ApiService();

  // Callback for handling notification taps
  static Function(Map<String, dynamic>)? onNotificationTap;

  /// Initialize FCM Service
  static Future<void> initialize() async {
    try {
      // Request permission for iOS and Android 13+
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        criticalAlert: false,
        announcement: false,
      );

      log('✅ User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Initialize local notifications
        await _initializeLocalNotifications();

        // Set up background message handler
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle notification tap when app is in background/terminated
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

        // Check for notification that opened the app
        RemoteMessage? initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          log('📱 App opened from notification: ${initialMessage.messageId}');
          _handleNotificationTap(initialMessage);
        }

        // Get and print FCM token
        await getFCMToken();

        // Set foreground notification presentation options for iOS
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        log('✅ FCM Service initialized successfully');
      } else {
        log('⚠️ Notification permission denied');
      }
    } catch (e) {
      log('❌ Error initializing FCM: $e');
    }
  }

  /// Initialize local notifications for foreground messages
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            onNotificationTap?.call(data);
            log('🔔 Notification tapped: $data');
          } catch (e) {
            log('❌ Error parsing notification payload: $e');
          }
        }
      },
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'trackfit_notifications', // id
      'TrackFit Notifications', // name
      description: 'Important notifications from TrackFit app',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM Token
  static Future<String?> getFCMToken() async {
    try {
      String? token = await _messaging.getToken();
      log('🔑 FCM Token: $token');

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        log('🔄 FCM Token refreshed: $newToken');
        // Only send refreshed token if user is authenticated
        sendCurrentTokenToBackend();
      });

      return token;
    } catch (e) {
      log('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Send FCM token to backend
  static Future<void> sendTokenToBackend(String token) async {
    try {
      log('📤 Sending FCM token to backend: $token');
      
      // Ensure ApiService is initialized
      _apiService.init();
      
      // Initialize CSRF token before sending FCM token
      await _apiService.initializeCsrfToken();
      
      final response = await _apiService.postForm(
        AppConstants.saveDeviceTokenEndpoint,
        data: {
          'device_token': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ FCM token sent to backend successfully');
      } else {
        log('⚠️ Failed to send FCM token to backend. Status: ${response.statusCode}');
        log('Response: ${response.data}');
      }
    } catch (e) {
      log('❌ Error sending FCM token to backend: $e');
      // Store the token for later retry if authentication is required
      if (e.toString().contains('Unauthenticated') || e.toString().contains('401')) {
        log('🔄 FCM token will be retried after user authentication');
      }
    }
  }

  /// Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    log('📱 Foreground message received: ${message.messageId}');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('Data: ${message.data}');

    // Save notification to local storage
    if (message.notification != null) {
      final notification = NotificationService.fromFCMData(
        messageId: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification!.title ?? 'Notification',
        body: message.notification!.body ?? '',
        data: message.data,
      );
      NotificationService.addNotification(notification);
    }

    // Show local notification when app is in foreground
    _showLocalNotification(message);
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    log('👆 Notification tapped: ${message.messageId}');
    log('Data: ${message.data}');

    // Save notification to local storage if not already saved
    if (message.notification != null) {
      final notification = NotificationService.fromFCMData(
        messageId: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification!.title ?? 'Notification',
        body: message.notification!.body ?? '',
        data: message.data,
      );
      NotificationService.addNotification(notification);
    }

    // Call the callback with notification data
    if (message.data.isNotEmpty) {
      onNotificationTap?.call(message.data);
    }

    // Navigate to specific screens based on message data
    _handleNotificationNavigation(message.data);
  }

  /// Handle navigation based on notification data
  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    final screen = data['screen'];
    final action = data['action'];

    log('🧭 Notification navigation - Type: $type, Screen: $screen, Action: $action');

    // You can implement navigation logic here
    // This will be called when user taps on notification
    switch (type) {
      case 'workout_reminder':
        // Navigate to workout screen
        break;
      case 'meal_reminder':
        // Navigate to meal screen
        break;
      case 'general':
        // Navigate to home screen
        break;
      default:
        // Default navigation
        break;
    }
  }

  /// Show local notification for foreground messages
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
           android: AndroidNotificationDetails(
             'trackfit_notifications',
             'TrackFit Notifications',
             channelDescription: 'Important notifications from TrackFit app',
             importance: Importance.high,
             priority: Priority.high,
             icon: '@drawable/ic_notification',
             enableVibration: true,
             playSound: true,
           ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      );
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log('✅ Subscribed to topic: $topic');
    } catch (e) {
      log('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      log('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      log('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token (for logout)
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      log('✅ FCM token deleted');
      
      // Optionally notify backend that token is no longer valid
      // You can implement this if your backend needs to know about token deletion
    } catch (e) {
      log('❌ Error deleting FCM token: $e');
    }
  }

  /// Manually send current FCM token to backend (useful after login)
  static Future<void> sendCurrentTokenToBackend() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        await sendTokenToBackend(token);
      } else {
        log('⚠️ No FCM token available to send');
      }
    } catch (e) {
      log('❌ Error sending current FCM token: $e');
    }
  }

  /// Check if user is authenticated and send FCM token if needed
  static Future<void> sendTokenIfAuthenticated() async {
    try {
      // Check if ApiService has a Bearer token (user is authenticated)
      if (_apiService.hasBearerToken()) {
        log('🔐 User is authenticated, sending FCM token...');
        await sendCurrentTokenToBackend();
      } else {
        log('🔒 User not authenticated, skipping FCM token send');
      }
    } catch (e) {
      log('❌ Error checking authentication status: $e');
    }
  }

  /// Get notification badge count (iOS)
  static Future<void> setBadgeCount(int count) async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      log('✅ Badge count set to: $count');
    } catch (e) {
      log('❌ Error setting badge count: $e');
    }
  }
}
