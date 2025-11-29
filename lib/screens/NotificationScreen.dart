import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/app_themes.dart';
import '../controllers/NotificationController.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.find<NotificationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.refreshNotifications();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      notificationController.loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.secondaryBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: AppThemes.appBarTextColor,
            fontSize: 19,
          ),
        ),
        backgroundColor: AppThemes.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppThemes.appBarTextColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        actions: [
          Obx(() => notificationController.hasUnreadNotifications
              ? IconButton(
                  icon: Icon(Icons.visibility_outlined, color: AppThemes.appBarTextColor),
                  onPressed: () {
                    notificationController.markAllAsRead();
                  },
                  tooltip: 'Mark all as read',
                )
              : SizedBox()),
        ],
      ),
      body: Obx(() => _buildNotificationsList()),
    );
  }

  Widget _buildNotificationsList() {
    if (notificationController.isLoading.value && notificationController.notifications.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppThemes.darkMaroon),
      );
    }

    if (notificationController.notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none_outlined,
                size: 80,
                color: AppThemes.mediumGrey,
              ),
              SizedBox(height: 20),
              Text(
                'No Notifications Yet',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.primaryTextColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'You\'ll see notifications here when you receive them',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppThemes.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppThemes.darkMaroon,
      onRefresh: () => notificationController.refreshNotifications(),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        itemCount: notificationController.notifications.length + 
                  (notificationController.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notificationController.notifications.length) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: AppThemes.darkMaroon),
              ),
            );
          }

          final notification = notificationController.notifications[index];
          return _buildNotificationTile(notification);
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? AppThemes.cardColor : AppThemes.darkMaroon.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? AppThemes.borderGrey : AppThemes.darkMaroon.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.cardShadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (notification.id != null && !notification.isRead) {
              notificationController.markAsRead(notification.id!);
            }
            _showNotificationDetails(notification);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getTypeColor(notification.type),
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.poppins(
                                fontWeight: notification.isRead 
                                    ? FontWeight.w500 
                                    : FontWeight.w600,
                                fontSize: 15,
                                color: AppThemes.primaryTextColor,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppThemes.darkMaroon,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: GoogleFonts.poppins(
                          color: AppThemes.secondaryTextColor,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppThemes.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'BLOG_POST':
        return Color(0xFF3B82F6); // Blue
      case 'FRIEND_REQUEST':
        return Color(0xFF8B5CF6); // Purple
      case 'EVENT_REMINDER':
        return Color(0xFFF59E0B); // Amber
      case 'FEE_REMINDER':
        return Color(0xFFEF4444); // Red
      case 'DEADLINE_ALERT':
        return AppThemes.errorColor;
      case 'APPOINTMENT_CONFIRMATION':
        return AppThemes.successColor;
      case 'ACADEMIC_UPDATE':
        return AppThemes.darkMaroon;
      case 'SYSTEM_ANNOUNCEMENT':
      case 'ANNOUNCEMENT':
        return Color(0xFF06B6D4); // Cyan
      case 'LOST_AND_FOUND':
        return Color(0xFF10B981); // Emerald
      default:
        return AppThemes.darkMaroon;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'BLOG_POST':
        return Icons.article_outlined;
      case 'FRIEND_REQUEST':
        return Icons.person_add_outlined;
      case 'EVENT_REMINDER':
        return Icons.event_outlined;
      case 'FEE_REMINDER':
        return Icons.payment_outlined;
      case 'DEADLINE_ALERT':
        return Icons.warning_amber_outlined;
      case 'APPOINTMENT_CONFIRMATION':
        return Icons.check_circle_outline;
      case 'ACADEMIC_UPDATE':
        return Icons.school_outlined;
      case 'SYSTEM_ANNOUNCEMENT':
      case 'ANNOUNCEMENT':
        return Icons.campaign_outlined;
      case 'LOST_AND_FOUND':
        return Icons.find_in_page_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppThemes.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getTypeColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getTypeColor(notification.type),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppThemes.primaryTextColor,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppThemes.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: AppThemes.dividerColor),
              SizedBox(height: 16),
              _buildDetailRow('Type', notification.type),
              SizedBox(height: 8),
              _buildDetailRow('Priority', notification.priority),
              SizedBox(height: 8),
              _buildDetailRow(
                'Time',
                DateFormat('MMM dd, yyyy HH:mm').format(notification.timestamp),
              ),
              if (notification.data != null) ...[
                SizedBox(height: 8),
                Text(
                  'Additional Data:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppThemes.primaryTextColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.data.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppThemes.secondaryTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: AppThemes.darkMaroon,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppThemes.primaryTextColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppThemes.secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
