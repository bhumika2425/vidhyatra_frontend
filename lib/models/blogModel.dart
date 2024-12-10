// blog_model.dart
import 'dart:convert';

class Blog {
  final int blogId;

  final String blogDescription;
  final List<String> imageUrls;
  final int userId;

  Blog({
    required this.blogId,
    required this.blogDescription,
    required this.imageUrls,
    required this.userId,
  });

  // Convert a Blog from JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blog_id'],
      blogDescription: json['blog_description'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      userId: json['user_id'],
    );
  }

  // Convert a Blog to JSON
  Map<String, dynamic> toJson() {
    return {
      'blog_id': blogId,

      'blog_description': blogDescription,
      'image_urls': imageUrls,
      'user_id': userId,
    };
  }
}
