import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../constants/api_endpoints.dart';

class AnnouncementModel {
  final int announcementId;
  final String title;
  final String description;
  final String? imageUrl;
  final String buttonText;
  final bool isPaused;
  final DateTime createdAt;

  AnnouncementModel({
    required this.announcementId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.buttonText,
    required this.isPaused,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      announcementId: json['announcement_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      buttonText: json['button_text'] ?? 'Got it',
      isPaused: json['is_paused'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AnnouncementController extends GetxController {
  final _storage = GetStorage();
  
  // Observable state
  var announcements = <AnnouncementModel>[].obs;
  var isLoading = false.obs;
  var hasCheckedAnnouncements = false.obs;
  var currentAnnouncementIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch on init - we'll do it when needed
  }

  /// Fetch active announcements (for students)
  Future<void> fetchActiveAnnouncements() async {
    try {
      isLoading.value = true;
      
      final token = _storage.read('token');
      if (token == null) {
        print('❌ No token found');
        return;
      }

      print('📡 Fetching active announcements...');
      
      final response = await http.get(
        Uri.parse(ApiEndPoints.getActiveAnnouncements),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          final List<dynamic> announcementData = data['data'];
          announcements.value = announcementData
              .map((json) => AnnouncementModel.fromJson(json))
              .toList();
          
          print('✅ Fetched ${announcements.length} active announcements');
        } else {
          print('❌ API returned success: false');
        }
      } else {
        print('❌ Failed to fetch announcements: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetching announcements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if there are new announcements and show them
  Future<bool> checkAndShowAnnouncements() async {
    await fetchActiveAnnouncements();
    
    if (announcements.isEmpty) {
      hasCheckedAnnouncements.value = true;
      return false;
    }

    // Check if we've already shown these announcements in this session
    final lastShownId = _storage.read('last_shown_announcement_id');
    final latestAnnouncementId = announcements.first.announcementId;

    if (lastShownId != null && lastShownId == latestAnnouncementId) {
      // Already shown in this session
      hasCheckedAnnouncements.value = true;
      return false;
    }

    // There are new announcements to show
    currentAnnouncementIndex.value = 0;
    hasCheckedAnnouncements.value = true;
    return true;
  }

  /// Mark current announcement as seen and move to next
  void markCurrentAsSeenAndNext() {
    if (announcements.isEmpty) return;

    // Store the last shown announcement ID
    _storage.write(
      'last_shown_announcement_id',
      announcements[currentAnnouncementIndex.value].announcementId,
    );

    // Move to next announcement
    if (currentAnnouncementIndex.value < announcements.length - 1) {
      currentAnnouncementIndex.value++;
    } else {
      // All announcements shown
      currentAnnouncementIndex.value = 0;
    }
  }

  /// Get current announcement
  AnnouncementModel? get currentAnnouncement {
    if (announcements.isEmpty) return null;
    if (currentAnnouncementIndex.value >= announcements.length) return null;
    return announcements[currentAnnouncementIndex.value];
  }

  /// Check if this is the last announcement
  bool get isLastAnnouncement {
    return currentAnnouncementIndex.value >= announcements.length - 1;
  }

  /// Reset announcement check status (for new login)
  void resetAnnouncementCheck() {
    hasCheckedAnnouncements.value = false;
    currentAnnouncementIndex.value = 0;
    announcements.clear();
  }
}
