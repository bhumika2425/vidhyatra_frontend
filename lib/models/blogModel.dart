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

  factory Blog.fromJson(Map<String, dynamic> json) {
    // Safely parsing the imageUrls field and ensuring it's always a list
    List<String> images = [];
    if (json['image_urls'] != null) {
      if (json['image_urls'] is List) {
        images = List<String>.from(json['image_urls']);
      } else if (json['image_urls'] is String) {
        // Handle if the 'image_urls' is unexpectedly a single string instead of a list
        images.add(json['image_urls']);
      }
    }

    // Ensure that description is a string, even if it's null
    String description = json['blog_description'] ?? '';

    return Blog(
      blogId: json['blog_id'] ?? 0, // Default value if missing
      blogDescription: description,
      imageUrls: images,
      userId: json['user_id'] ?? 0, // Default value if missing
    );
  }
}


// class Blog {
//   final int blogId;
//   final String blogDescription;
//   final List<String> imageUrls;
//
//   Blog({
//     required this.blogId,
//     required this.blogDescription,
//     required this.imageUrls,
//   });
//
//   factory Blog.fromJson(Map<String, dynamic> json) {
//     return Blog(
//       blogId: json['blog_id'],
//       blogDescription: json['blog_description'],
//       imageUrls: json['image_urls'] != null
//           ? (json['image_urls'] is String
//           ? List<String>.from(jsonDecode(json['image_urls']))
//           : List<String>.from(json['image_urls']))
//           : [],
//     );
//   }
// }
