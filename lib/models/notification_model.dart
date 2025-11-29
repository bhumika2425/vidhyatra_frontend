class NotificationModel {
  final int? id;
  final String title;
  final String message;
  final String type;
  final String priority;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;
  final DateTime? expiresAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    required this.type,
    this.priority = 'MEDIUM',
    this.data,
    required this.timestamp,
    this.isRead = false,
    this.expiresAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? json['notification_id'] as int?,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String? ?? 'MEDIUM',
      data: json['data'] != null 
          ? (json['data'] is String 
              ? null // If it's a string "null", treat as null
              : json['data'] as Map<String, dynamic>?)
          : null,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.parse(json['created_at'] as String),
      isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? false,
      expiresAt: json['expires_at'] != null && json['expires_at'] != 'null'
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'priority': priority,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    String? priority,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
    DateTime? expiresAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  // Helper method to get notification icon based on type
  String getIconAsset() {
    switch (type) {
      case 'BLOG_POST':
        return 'assets/img.png';
      case 'FRIEND_REQUEST':
        return 'assets/default_profile.png';
      case 'EVENT_REMINDER':
        return 'assets/img_1.png';
      case 'FEE_REMINDER':
        return 'assets/img_2.png';
      case 'DEADLINE_ALERT':
        return 'assets/lock_icon.png';
      case 'APPOINTMENT_CONFIRMATION':
        return 'assets/college_logo.png';
      case 'ACADEMIC_UPDATE':
        return 'assets/Vidhyatra.png';
      case 'SYSTEM_ANNOUNCEMENT':
        return 'assets/logo.webp';
      case 'LOST_AND_FOUND':
        return 'assets/yayGirl.png';
      default:
        return 'assets/college_logo.png';
    }
  }

  // Helper method to get notification color based on priority
  String getPriorityColor() {
    switch (priority) {
      case 'LOW':
        return '#4CAF50'; // Green
      case 'MEDIUM':
        return '#2196F3'; // Blue
      case 'HIGH':
        return '#FF9800'; // Orange
      case 'URGENT':
        return '#F44336'; // Red
      default:
        return '#2196F3'; // Blue
    }
  }

  // Helper method to check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, priority: $priority, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NotificationModel &&
      other.id == id &&
      other.title == title &&
      other.message == message &&
      other.type == type &&
      other.priority == priority &&
      other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      message.hashCode ^
      type.hashCode ^
      priority.hashCode ^
      isRead.hashCode;
  }
}
