import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../controllers/NotificationController.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📨 Background notification received: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final GetStorage _storage = GetStorage();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize FCM and local notifications
  Future<void> initialize() async {
    try {
      print('🔥 Initializing FCM Service...');

      // Request notification permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token (with timeout and error handling)
      try {
        _fcmToken = await _fcm.getToken().timeout(
          Duration(seconds: 10),
          onTimeout: () {
            print('⚠️ FCM token retrieval timed out');
            return null;
          },
        );
        
        if (_fcmToken != null) {
          print('✅ FCM Token obtained: ${_fcmToken!.substring(0, 30)}...');
          print('📏 Token length: ${_fcmToken!.length} characters');
        } else {
          print('⚠️ FCM Token is null - running on emulator without Google Play Services?');
        }
      } catch (tokenError) {
        print('⚠️ FCM Token error: $tokenError');
        if (tokenError.toString().contains('SERVICE_NOT_AVAILABLE')) {
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('⚠️  EMULATOR WARNING: Google Play Services not available');
          print('💡 FCM Push Notifications will NOT work on this emulator');
          print('💡 To test push notifications:');
          print('   1. Use a real Android device, OR');
          print('   2. Use an emulator with Google Play Store (not basic AOSP)');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        }
        _fcmToken = null;
      }

      // Send token to backend (will be called after login)
      if (_fcmToken != null && _storage.read('token') != null) {
        await sendTokenToBackend(_fcmToken!);
      }

      // Setup message handlers (even if token is null, for future use)
      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        print('🔄 FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        if (_storage.read('token') != null) {
          sendTokenToBackend(newToken);
        }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Handle notification tap when app is terminated
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Register background handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      print('✅ FCM Service initialized successfully');
    } catch (e) {
      print('❌ FCM initialization error: $e');
      print('⚠️  App will continue without push notifications');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permissions granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ Provisional notification permissions granted');
    } else {
      print('❌ Notification permissions denied');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _navigateFromPayload(response.payload!);
        }
      },
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('✅ Local notifications initialized');
  }

  /// Handle foreground messages (when app is open)
  void _handleForegroundMessage(RemoteMessage message) {
    print('📨 Foreground notification received');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Show local notification
    _showLocalNotification(message);

    // Refresh notification list in app
    try {
      final notificationController = Get.find<NotificationController>();
      notificationController.loadNotifications(refresh: true);
    } catch (e) {
      print('⚠️ NotificationController not found: $e');
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 Notification tapped: ${message.data}');
    _navigateFromPayload(jsonEncode(message.data));
  }

  /// Navigate based on notification payload
  void _navigateFromPayload(String payloadJson) {
    try {
      final data = jsonDecode(payloadJson);
      final type = data['type'] ?? '';

      print('📱 Navigating to: $type');

      switch (type) {
        case 'DEADLINE_ALERT':
          Get.toNamed('/student-dashboard');
          break;
        case 'EVENT_REMINDER':
          Get.toNamed('/calendar');
          break;
        case 'FEE_REMINDER':
          Get.toNamed('/feesScreen');
          break;
        case 'FRIEND_REQUEST':
          Get.toNamed('/profile');
          break;
        case 'BLOG_POST':
          Get.toNamed('/student-dashboard');
          break;
        default:
          Get.toNamed('/notifications');
      }
    } catch (e) {
      print('❌ Error navigating from payload: $e');
      Get.toNamed('/notifications');
    }
  }

  /// Send FCM token to backend (called after login)
  Future<bool> sendTokenToBackend(String token) async {
    try {
      final authToken = _storage.read('token');

      if (authToken == null) {
        print('❌ No auth token found in storage, skipping FCM token registration');
        print('🔍 Storage contents: ${_storage.getKeys()}');
        return false;
      }

      print('📤 Sending FCM token to backend...');
      print('🔑 Auth token: ${authToken.toString().substring(0, 20)}...');
      print('📱 FCM token: ${token.substring(0, 20)}...');

      final url = '${ApiEndPoints.baseUrl}/api/auth/fcm-token';
      print('🌐 URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'fcmToken': token}),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📊 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ FCM token registered with backend');
        return true;
      } else {
        print('❌ Failed to register FCM token: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending FCM token to backend: $e');
      return false;
    }
  }

  /// Clear FCM token on logout
  Future<void> clearToken() async {
    try {
      print('🔴 Clearing FCM token...');

      final authToken = _storage.read('token');

      // Remove token from backend first
      if (authToken != null) {
        try {
          final response = await http.delete(
            Uri.parse('${ApiEndPoints.baseUrl}/api/auth/fcm-token'),
            headers: {
              'Authorization': 'Bearer $authToken',
            },
          );

          if (response.statusCode == 200) {
            print('✅ FCM token removed from backend');
          } else {
            print('⚠️ Failed to remove FCM token from backend: ${response.statusCode}');
          }
        } catch (e) {
          print('❌ Error removing token from backend: $e');
        }
      }

      // Delete token from Firebase
      await _fcm.deleteToken();
      _fcmToken = null;

      print('✅ FCM token cleared successfully');
    } catch (e) {
      print('❌ Error clearing FCM token: $e');
    }
  }

  /// Get a new FCM token (called after login or when token is needed)
  Future<String?> getNewToken() async {
    try {
      print('🔄 Getting new FCM token...');
      _fcmToken = await _fcm.getToken().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('⚠️ FCM token retrieval timed out');
          return null;
        },
      );
      
      if (_fcmToken != null) {
        print('✅ Got new FCM token: ${_fcmToken!.substring(0, 30)}...');
        print('📏 Token length: ${_fcmToken!.length} characters');
      } else {
        print('⚠️ FCM token is null');
        print('💡 This happens when Google Play Services is not available');
        print('💡 Use a real device or emulator with Google Play Store');
      }
      
      return _fcmToken;
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      if (e.toString().contains('SERVICE_NOT_AVAILABLE')) {
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('⚠️  Cannot get FCM token: Google Play Services unavailable');
        print('💡 Push notifications will NOT work');
        print('💡 Solution: Test on a real device or Google Play emulator');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }
      return null;
    }
  }
}
