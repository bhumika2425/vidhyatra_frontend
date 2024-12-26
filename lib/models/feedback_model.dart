// lib/models/feedback_model.dart
class FeedbackModel {
  String? userId;
  String feedbackType; // 'courses', 'app_features', 'facilities'
  String feedbackContent;
  bool isAnonymous;

  FeedbackModel({
    this.userId,
    required this.feedbackType,
    required this.feedbackContent,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'feedback_type': feedbackType,
      'feedback_content': feedbackContent,
      'is_anonymous': isAnonymous,
    };
  }
}
