import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/api_endpoints.dart';
import '../controllers/LoginController.dart';
import '../models/notification_model.dart';
import '../screens/AnnouncementsScreen.dart';
import '../services/socket_service.dart';

class NotificationController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();
  late SocketService _socketService;
  
  // Observable variables
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreNotifications = true.obs;
  var currentPage = 1.obs;
  var isSocketConnected = false.obs;
  var socketConnectionInfo = {}.obs;
  
  // Constants
  static const int pageSize = 20;
  
  // Stream subscriptions
  StreamSubscription<NotificationModel>? _notificationSubscription;
  StreamSubscription<int>? _notificationReadSubscription;
  StreamSubscription<void>? _allNotificationReadSubscription;
  
  @override
  void onInit() {
    super.onInit();
    // debugPrint('🔥 NotificationController.onInit() - Initializing notification controller');
    _initializeSocketService();
    ever(isSocketConnected, _onSocketConnectionChanged);
    // debugPrint('✅ NotificationController.onInit() - Initialization complete');
  }

  @override
  void onClose() {
    // debugPrint('🔥 NotificationController.onClose() - Cleaning up notification controller');
    _notificationSubscription?.cancel();
    _notificationReadSubscription?.cancel();
    _allNotificationReadSubscription?.cancel();
    // debugPrint('✅ NotificationController.onClose() - Cleanup complete');
    super.onClose();
  }

  /// Initialize socket service and setup listeners
  void _initializeSocketService() {
    // debugPrint('🔥 NotificationController._initializeSocketService() - Starting socket service initialization');
    
    try {
      _socketService = Get.find<SocketService>();
      // debugPrint('✅ NotificationController._initializeSocketService() - Found SocketService');
    } catch (e) {
      // debugPrint('❌ NotificationController._initializeSocketService() - Failed to find SocketService: $e');
      return;
    }
    
    // Listen to socket connection changes
    ever(_socketService.isConnected, (bool connected) {
      // debugPrint('🔗 NotificationController._initializeSocketService() - Socket connection changed: $connected');
      isSocketConnected.value = connected;
      socketConnectionInfo.value = _socketService.getConnectionInfo();
    });
    
    _setupNotificationListeners();
    // debugPrint('✅ NotificationController._initializeSocketService() - Socket service initialization complete');
  }

  /// Setup notification event listeners
  void _setupNotificationListeners() {
    // debugPrint('🔥 NotificationController._setupNotificationListeners() - Setting up notification listeners');
    
    // Listen for new notifications
    _notificationSubscription = _socketService.notificationStream.listen(
      (notification) {
        // debugPrint('📨 NotificationController._setupNotificationListeners() - Received notification: ${notification.title}');
        _handleNewNotification(notification);
      },
      onError: (error) {
        // debugPrint('❌ NotificationController._setupNotificationListeners() - Error listening to notifications: $error');
      },
    );

    // Listen for notification read events
    _notificationReadSubscription = _socketService.notificationReadStream.listen(
      (notificationId) {
        // debugPrint('📖 NotificationController._setupNotificationListeners() - Notification read: $notificationId');
        _markNotificationAsReadLocally(notificationId);
      },
      onError: (error) {
        // debugPrint('❌ NotificationController._setupNotificationListeners() - Error listening to notification read events: $error');
      },
    );

    // Listen for all notifications read events
    _allNotificationReadSubscription = _socketService.allNotificationReadStream.listen(
      (_) {
        // debugPrint('📖 NotificationController._setupNotificationListeners() - All notifications marked as read');
        _markAllNotificationsAsReadLocally();
      },
      onError: (error) {
        // debugPrint('❌ NotificationController._setupNotificationListeners() - Error listening to all notifications read events: $error');
      },
    );
    
    // debugPrint('✅ NotificationController._setupNotificationListeners() - Notification listeners setup complete');
  }

  /// Handle socket connection changes
  void _onSocketConnectionChanged(bool connected) {
    // debugPrint('🔗 NotificationController._onSocketConnectionChanged() - Connection changed to: $connected');
    if (connected) {
      // debugPrint('🔄 NotificationController._onSocketConnectionChanged() - Socket connected, refreshing notifications');
      // Refresh notifications when reconnected
      refreshNotifications();
    } else {
      // debugPrint('⚠️ NotificationController._onSocketConnectionChanged() - Socket disconnected');
    }
  }

  /// Handle new incoming notification
  void _handleNewNotification(NotificationModel notification) {
    // debugPrint('📨 NotificationController._handleNewNotification() - Processing notification: ${notification.toJson()}');
    
    // Add to the beginning of the list
    notifications.insert(0, notification);
    // debugPrint('📝 NotificationController._handleNewNotification() - Added to notifications list. Total count: ${notifications.length}');
    
    // Increment unread count if not read
    if (!notification.isRead) {
      unreadCount.value++;
      // debugPrint('🔢 NotificationController._handleNewNotification() - Incremented unread count to: ${unreadCount.value}');
    }
    
    // Show in-app notification
    // debugPrint('🔔 NotificationController._handleNewNotification() - Showing in-app notification');
    _showInAppNotification(notification);
  }

  /// Show in-app notification toast/snackbar
  void _showInAppNotification(NotificationModel notification) {
    // debugPrint('🔔 NotificationController._showInAppNotification() - Showing notification: ${notification.title}');
    
    try {
      // Show toast notification
      Fluttertoast.showToast(
        msg: "${notification.title}\n${notification.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Color(int.parse(notification.getPriorityColor().replaceFirst('#', '0xFF'))),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      // debugPrint('✅ NotificationController._showInAppNotification() - Toast shown successfully');

      // Also show GetX snackbar for better visibility
      // Get.snackbar(
      //   notification.title,
      //   notification.message,
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Color(int.parse(notification.getPriorityColor().replaceFirst('#', '0xFF'))),
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 3),
      //   isDismissible: true,
      //   forwardAnimationCurve: Curves.easeOutBack,
      //   icon: Icon(
      //     _getNotificationIcon(notification.type),
      //     color: Colors.white,
      //   ),
      //   shouldIconPulse: true,
      //   onTap: (_) {
      //     debugPrint('👆 NotificationController._showInAppNotification() - Notification tapped');
      //     // Navigate to relevant screen based on notification type
      //     _handleNotificationTap(notification);
      //   },
      // );
      // debugPrint('✅ NotificationController._showInAppNotification() - GetX snackbar shown successfully');
    } catch (e) {
      // debugPrint('❌ NotificationController._showInAppNotification() - Error showing notification: $e');
    }
  }

  /// Get notification icon based on type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'BLOG_POST':
        return Icons.article;
      case 'FRIEND_REQUEST':
        return Icons.person_add;
      case 'EVENT_REMINDER':
        return Icons.event;
      case 'FEE_REMINDER':
        return Icons.payment;
      case 'DEADLINE_ALERT':
        return Icons.warning;
      case 'APPOINTMENT_CONFIRMATION':
        return Icons.check_circle;
      case 'ACADEMIC_UPDATE':
        return Icons.school;
      case 'SYSTEM_ANNOUNCEMENT':
        return Icons.announcement;
      case 'LOST_AND_FOUND':
        return Icons.find_in_page;
      default:
        return Icons.notifications;
    }
  }

  /// Handle notification tap - navigate to relevant screen
  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read when tapped
    if (notification.id != null && !notification.isRead) {
      markAsRead(notification.id!);
    }

    // Navigate based on notification type and data
    switch (notification.type) {
      case 'BLOG_POST':
        Get.toNamed('/student-dashboard'); // Navigate to blog section
        break;
      case 'FRIEND_REQUEST':
        Get.toNamed('/profile'); // Navigate to friend requests
        break;
      case 'EVENT_REMINDER':
        Get.toNamed('/calendar'); // Navigate to calendar
        break;
      case 'FEE_REMINDER':
        Get.toNamed('/feesScreen'); // Navigate to fees screen
        break;
      case 'DEADLINE_ALERT':
        Get.toNamed('/student-dashboard'); // Navigate to dashboard
        break;
      case 'APPOINTMENT_CONFIRMATION':
        // Navigate to appointments if available
        break;
      case 'ACADEMIC_UPDATE':
        Get.toNamed('/student-dashboard'); // Navigate to academic section
        break;
      case 'ANNOUNCEMENTS':
        Get.to(AnnouncementsScreen()); // Navigate to announcements screen
        break;
      default:
        Get.toNamed('/student-dashboard'); // Default navigation
    }
  }

  /// Connect to socket
  Future<void> connectSocket() async {
    // debugPrint('🔗 NotificationController.connectSocket() - Attempting to connect socket');
    
    try {
      final success = await _socketService.connect();
      if (success) {
        // debugPrint('✅ NotificationController.connectSocket() - Socket connected successfully');
        // Load initial notifications after connection
        await refreshNotifications();
      } else {
        // debugPrint('❌ NotificationController.connectSocket() - Failed to connect to socket');
        _showError('Failed to connect to notification service');
      }
    } catch (e) {
      // debugPrint('❌ NotificationController.connectSocket() - Error connecting socket: $e');
      _showError('Connection error: ${e.toString()}');
    }
  }

  /// Disconnect from socket
  void disconnectSocket() {
    // debugPrint('🔌 NotificationController.disconnectSocket() - Disconnecting socket');
    _socketService.disconnect();
    // debugPrint('✅ NotificationController.disconnectSocket() - Socket disconnected');
  }

  /// Load notifications from server
  Future<void> loadNotifications({bool refresh = false}) async {
    // debugPrint('📥 NotificationController.loadNotifications() - Starting to load notifications (refresh: $refresh)');
    
    if (refresh) {
      // debugPrint('🔄 NotificationController.loadNotifications() - Refreshing notifications');
      currentPage.value = 1;
      hasMoreNotifications.value = true;
      notifications.clear();
      isLoading.value = true;
    } else {
      if (!hasMoreNotifications.value || isLoadingMore.value) {
        // debugPrint('⏹️ NotificationController.loadNotifications() - No more notifications or already loading');
        return;
      }
      // debugPrint('📄 NotificationController.loadNotifications() - Loading more notifications (page: ${currentPage.value})');
      isLoadingMore.value = true;
    }

    try {
      final url = '${ApiEndPoints.baseUrl}/api/notifications/my-notifications?page=${currentPage.value}&limit=$pageSize';
      // debugPrint('🌐 NotificationController.loadNotifications() - Making request to: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${_loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      // debugPrint('📡 NotificationController.loadNotifications() - Response status: ${response.statusCode}');
      // debugPrint('📡 NotificationController.loadNotifications() - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final notificationData = data['data'];
        
        // debugPrint('📋 NotificationController.loadNotifications() - Raw notification data: $notificationData');
        
        final notificationsList = notificationData['notifications'] as List;
        // debugPrint('📋 NotificationController.loadNotifications() - Processing ${notificationsList.length} raw notifications');
        
        final List<NotificationModel> newNotifications = [];
        
        for (int i = 0; i < notificationsList.length; i++) {
          try {
            final notificationJson = notificationsList[i];

            final notification = NotificationModel.fromJson(notificationJson);
            newNotifications.add(notification);
          } catch (e) {
            // debugPrint('❌ NotificationController.loadNotifications() - Error parsing notification $i: $e');
            // debugPrint('🔍 NotificationController.loadNotifications() - Failed notification data: ${notificationsList[i]}');
          }
        }

        // debugPrint('📊 NotificationController.loadNotifications() - Successfully loaded ${newNotifications.length} notifications');

        if (refresh) {
          notifications.value = newNotifications;
        } else {
          notifications.addAll(newNotifications);
        }

        hasMoreNotifications.value = notificationData['hasNextPage'] ?? false;
        currentPage.value++;
        
        // debugPrint('✅ NotificationController.loadNotifications() - Total notifications: ${notifications.length}, Has more: ${hasMoreNotifications.value}');
      } else {
        // debugPrint('❌ NotificationController.loadNotifications() - Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      // debugPrint('❌ NotificationController.loadNotifications() - Error loading notifications: $e');
      _showError('Failed to load notifications');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      // debugPrint('🏁 NotificationController.loadNotifications() - Loading complete');
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await Future.wait([
      loadNotifications(refresh: true),
      loadUnreadCount(),
    ]);
  }

  /// Load unread notification count
  Future<void> loadUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}/api/notifications/unread-count'),
        headers: {
          'Authorization': 'Bearer ${_loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        unreadCount.value = data['data']['unreadCount'];
      }
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiEndPoints.baseUrl}/api/notifications/mark-read/$notificationId'),
        headers: {
          'Authorization': 'Bearer ${_loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _markNotificationAsReadLocally(notificationId);
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      _showError('Failed to mark notification as read');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiEndPoints.baseUrl}/api/notifications/mark-all-read'),
        headers: {
          'Authorization': 'Bearer ${_loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _markAllNotificationsAsReadLocally();
      } else {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      _showError('Failed to mark all notifications as read');
    }
  }

  /// Test notification (for testing purposes)
  Future<void> sendTestNotification() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}/api/notifications/test'),
        headers: {
          'Authorization': 'Bearer ${_loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Test notification sent!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to send test notification');
      }
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      _showError('Failed to send test notification');
    }
  }

  /// Mark notification as read locally
  void _markNotificationAsReadLocally(int notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      unreadCount.value = (unreadCount.value - 1).clamp(0, double.infinity).toInt();
    }
  }

  /// Mark all notifications as read locally
  void _markAllNotificationsAsReadLocally() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    unreadCount.value = 0;
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  /// Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((n) => n.type == type).toList();
  }

  /// Get notifications by priority
  List<NotificationModel> getNotificationsByPriority(String priority) {
    return notifications.where((n) => n.priority == priority).toList();
  }

  /// Get unread notifications
  List<NotificationModel> get unreadNotifications {
    return notifications.where((n) => !n.isRead).toList();
  }

  /// Get read notifications
  List<NotificationModel> get readNotifications {
    return notifications.where((n) => n.isRead).toList();
  }

  /// Check if has unread notifications
  bool get hasUnreadNotifications => unreadCount.value > 0;

  /// Force reconnect socket
  Future<void> reconnectSocket() async {
    await _socketService.reconnect();
  }

  /// Get socket connection info
  Map<String, dynamic> get connectionInfo => _socketService.getConnectionInfo();
}
