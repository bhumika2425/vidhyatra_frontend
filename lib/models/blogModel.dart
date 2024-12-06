class Blog {
  final int blogId;
  final String blogDescription;
  final List<String> imageUrls;

  Blog({
    required this.blogId,
    required this.blogDescription,
    required this.imageUrls,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blog_id'],
      blogDescription: json['blog_description'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}
