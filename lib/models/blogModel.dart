// blog_model.dart
import 'dart:convert';

class Blog {
  final int blogId;
  final String blogDescription;
  final List<String> imageUrls;
  final int userId;
  final String createdAt;
  final String profileImage;
  final String fullName;
  final int likes;

  Blog({
    required this.blogId,
    required this.blogDescription,
    required this.imageUrls,
    required this.userId,
    required this.createdAt,
    required this.profileImage,
    required this.fullName,
    required this.likes
  });

  // Convert a Blog from JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blog_id'],
      blogDescription: json['blog_description'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      userId: json['user_id'],
      createdAt: json['createdAt'],
      profileImage: json['profileImageUrl'] ?? '',
      fullName: json['full_name'] ?? '',
      likes: json['likes']

    );
  }

  // Convert a Blog to JSON
  Map<String, dynamic> toJson() {
    return {
      'blog_id': blogId,
      'blog_description': blogDescription,
      'image_urls': imageUrls,
      'user_id': userId,
      'createdAt': createdAt,
      'profileImageUrl': profileImage,
      'full_name': fullName,
      'likes': likes
    };
  }
}
