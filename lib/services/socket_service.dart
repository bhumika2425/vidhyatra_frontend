import 'dart:async';
import 'dart:developer' as developer;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import '../constants/api_endpoints.dart';
import '../controllers/LoginController.dart';
import '../models/notification_model.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;
  final LoginController _loginController = Get.find<LoginController>();
  
  // Connection status
  var isConnected = false.obs;
  var connectionAttempts = 0.obs;
  var lastConnectionError = ''.obs;
  
  // Notification streams
  final StreamController<NotificationModel> _notificationController = 
      StreamController<NotificationModel>.broadcast();
  final StreamController<int> _notificationReadController = 
      StreamController<int>.broadcast();
  final StreamController<void> _allNotificationReadController = 
      StreamController<void>.broadcast();
  final StreamController<Map<String, dynamic>> _userStatusController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  // Getters for streams
  Stream<NotificationModel> get notificationStream => _notificationController.stream;
  Stream<int> get notificationReadStream => _notificationReadController.stream;
  Stream<void> get allNotificationReadStream => _allNotificationReadController.stream;
  Stream<Map<String, dynamic>> get userStatusStream => _userStatusController.stream;
  
  // Constants
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 2);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  @override
  void onInit() {
    super.onInit();
    developer.log('🔥 SocketService.onInit() - SocketService initialized', name: 'SocketService');
  }

  @override
  void onClose() {
    developer.log('🔥 SocketService.onClose() - Cleaning up SocketService', name: 'SocketService');
    disconnect();
    _notificationController.close();
    _notificationReadController.close();
    _allNotificationReadController.close();
    _userStatusController.close();
    developer.log('✅ SocketService.onClose() - SocketService cleanup complete', name: 'SocketService');
    super.onClose();
  }

  /// Connect to Socket.IO server
  Future<bool> connect() async {
    try {
      if (_socket?.connected == true) {
        developer.log('🔗 SocketService.connect() - Socket already connected', name: 'SocketService');
        return true;
      }

      final token = _loginController.token.value;
      if (token.isEmpty) {
        developer.log('❌ SocketService.connect() - No authentication token available', name: 'SocketService');
        throw Exception('No authentication token available');
      }

      developer.log('🔗 SocketService.connect() - Attempting to connect to socket server...', name: 'SocketService');
      developer.log('🔑 SocketService.connect() - Using token: ${token.substring(0, 20)}...', name: 'SocketService');
      developer.log('🌐 SocketService.connect() - Connecting to: ${ApiEndPoints.baseUrl}', name: 'SocketService');
      
      _socket = IO.io(
        ApiEndPoints.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setTimeout(connectionTimeout.inMilliseconds)
            .setAuth({'token': token})
            .enableReconnection()
            .setReconnectionAttempts(maxReconnectAttempts)
            .setReconnectionDelay(reconnectDelay.inMilliseconds)
            .build(),
      );

      developer.log('⚙️ SocketService.connect() - Socket.IO client created with options', name: 'SocketService');
      _setupEventListeners();
      
      // Wait for connection with timeout
      final completer = Completer<bool>();
      Timer? timeoutTimer;
      
      void onConnect(_) {
        developer.log('✅ SocketService.connect() - Connection established successfully', name: 'SocketService');
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
      
      void onError(error) {
        developer.log('❌ SocketService.connect() - Connection failed: $error', name: 'SocketService');
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      }
      
      _socket!.once('connect', onConnect);
      _socket!.once('connect_error', onError);
      
      timeoutTimer = Timer(connectionTimeout, () {
        developer.log('⏰ SocketService.connect() - Connection timeout', name: 'SocketService');
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
      
      return await completer.future;
      
    } catch (e) {
      developer.log('Connection error: $e', name: 'SocketService');
      lastConnectionError.value = e.toString();
      return false;
    }
  }

  /// Disconnect from Socket.IO server
  void disconnect() {
    if (_socket != null) {
      developer.log('Disconnecting from socket server...', name: 'SocketService');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      isConnected.value = false;
      connectionAttempts.value = 0;
    }
  }

  /// Reconnect to Socket.IO server
  Future<bool> reconnect() async {
    disconnect();
    await Future.delayed(reconnectDelay);
    return await connect();
  }

  /// Setup Socket.IO event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.on('connect', (data) {
      developer.log('✅ Connected to socket server', name: 'SocketService');
      developer.log('📊 Connection data: $data', name: 'SocketService');
      isConnected.value = true;
      connectionAttempts.value = 0;
      lastConnectionError.value = '';
      
      // Emit user online status
      developer.log('📤 Emitting user_online status', name: 'SocketService');
      _socket!.emit('user_online');
    });

    _socket!.on('disconnect', (data) {
      developer.log('❌ Disconnected from socket server: $data', name: 'SocketService');
      isConnected.value = false;
    });

    _socket!.on('connect_error', (error) {
      developer.log('🔥 Connection error: $error', name: 'SocketService');
      isConnected.value = false;
      connectionAttempts.value++;
      lastConnectionError.value = error.toString();
    });

    _socket!.on('reconnect', (attemptNumber) {
      developer.log('🔄 Reconnected after $attemptNumber attempts', name: 'SocketService');
      isConnected.value = true;
      connectionAttempts.value = 0;
    });

    _socket!.on('reconnect_attempt', (attemptNumber) {
      developer.log('🔄 Reconnection attempt $attemptNumber', name: 'SocketService');
      connectionAttempts.value = attemptNumber;
    });

    _socket!.on('reconnect_failed', (_) {
      developer.log('❌ Reconnection failed after maximum attempts', name: 'SocketService');
      isConnected.value = false;
    });

    // Notification events
    _socket!.on('notification', (data) {
      try {
        developer.log('📨 SocketService - Received notification event', name: 'SocketService');
        developer.log('📊 SocketService - Raw notification data: ${data.toString()}', name: 'SocketService');
        final notification = NotificationModel.fromJson(Map<String, dynamic>.from(data));
        developer.log('📋 SocketService - Parsed notification: ${notification.toString()}', name: 'SocketService');
        _notificationController.add(notification);
        developer.log('✅ SocketService - Notification added to stream', name: 'SocketService');
      } catch (e) {
        developer.log('❌ SocketService - Error parsing notification: $e', name: 'SocketService');
        developer.log('🔍 SocketService - Raw data that failed: $data', name: 'SocketService');
      }
    });

    _socket!.on('notification_read', (data) {
      try {
        developer.log('📖 SocketService - Received notification_read event', name: 'SocketService');
        developer.log('📊 SocketService - Read event data: $data', name: 'SocketService');
        final notificationId = data['notificationId'] as int;
        developer.log('� SocketService - Notification ID marked as read: $notificationId', name: 'SocketService');
        _notificationReadController.add(notificationId);
        developer.log('✅ SocketService - Read event added to stream', name: 'SocketService');
      } catch (e) {
        developer.log('❌ SocketService - Error parsing notification read event: $e', name: 'SocketService');
      }
    });

    _socket!.on('all_notifications_read', (_) {
      developer.log('📖 SocketService - All notifications marked as read', name: 'SocketService');
      _allNotificationReadController.add(null);
      developer.log('✅ SocketService - All read event added to stream', name: 'SocketService');
    });

    // User status events
    _socket!.on('user_status', (data) {
      try {
        developer.log('👤 SocketService - User status update received', name: 'SocketService');
        developer.log('📊 SocketService - Status data: ${data.toString()}', name: 'SocketService');
        _userStatusController.add(Map<String, dynamic>.from(data));
        developer.log('✅ SocketService - User status added to stream', name: 'SocketService');
      } catch (e) {
        developer.log('❌ SocketService - Error parsing user status: $e', name: 'SocketService');
      }
    });

    // Typing indicators (for future chat features)
    _socket!.on('user_typing', (data) {
      developer.log('✍️ SocketService - User typing event: ${data.toString()}', name: 'SocketService');
    });

    _socket!.on('user_stopped_typing', (data) {
      developer.log('✋ User stopped typing: ${data.toString()}', name: 'SocketService');
    });
  }

  /// Emit typing indicator
  void emitTyping(int recipientId, String chatId) {
    developer.log('✍️ SocketService.emitTyping() - recipientId: $recipientId, chatId: $chatId', name: 'SocketService');
    if (_socket?.connected == true) {
      _socket!.emit('typing', {
        'recipientId': recipientId,
        'chatId': chatId,
      });
      developer.log('📤 SocketService.emitTyping() - Typing event emitted', name: 'SocketService');
    } else {
      developer.log('❌ SocketService.emitTyping() - Socket not connected', name: 'SocketService');
    }
  }

  /// Emit stop typing indicator
  void emitStopTyping(int recipientId, String chatId) {
    developer.log('✋ SocketService.emitStopTyping() - recipientId: $recipientId, chatId: $chatId', name: 'SocketService');
    if (_socket?.connected == true) {
      _socket!.emit('stop_typing', {
        'recipientId': recipientId,
        'chatId': chatId,
      });
      developer.log('📤 SocketService.emitStopTyping() - Stop typing event emitted', name: 'SocketService');
    } else {
      developer.log('❌ SocketService.emitStopTyping() - Socket not connected', name: 'SocketService');
    }
  }

  /// Emit custom event
  void emit(String event, dynamic data) {
    developer.log('📤 SocketService.emit() - event: $event, data: $data', name: 'SocketService');
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
      developer.log('✅ SocketService.emit() - Event emitted successfully', name: 'SocketService');
    } else {
      developer.log('❌ SocketService.emit() - Cannot emit event: Socket not connected', name: 'SocketService');
    }
  }

  /// Listen to custom events
  void on(String event, Function(dynamic) handler) {
    developer.log('👂 SocketService.on() - Setting up listener for event: $event', name: 'SocketService');
    if (_socket != null) {
      _socket!.on(event, handler);
      developer.log('✅ SocketService.on() - Listener set up for event: $event', name: 'SocketService');
    } else {
      developer.log('❌ SocketService.on() - Socket is null', name: 'SocketService');
    }
  }

  /// Remove event listener
  void off(String event) {
    developer.log('🔇 SocketService.off() - Removing listener for event: $event', name: 'SocketService');
    if (_socket != null) {
      _socket!.off(event);
      developer.log('🔇 Stopped listening to event: $event', name: 'SocketService');
    }
  }

  /// Get connection status info
  Map<String, dynamic> getConnectionInfo() {
    return {
      'isConnected': isConnected.value,
      'connectionAttempts': connectionAttempts.value,
      'lastError': lastConnectionError.value,
      'socketId': _socket?.id,
      'connected': _socket?.connected ?? false,
    };
  }

  /// Check if socket is connected
  bool get connected => _socket?.connected == true;

  /// Force reconnection if disconnected
  Future<void> ensureConnection() async {
    if (!connected) {
      developer.log('Connection lost, attempting to reconnect...', name: 'SocketService');
      await reconnect();
    }
  }
}
