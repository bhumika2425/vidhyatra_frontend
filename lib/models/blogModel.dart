class Blog {
  final int blogId;
  final String blogTitle;
  final String blogDescription;
  final List<String> imageUrls;

  Blog({
    required this.blogId,
    required this.blogTitle,
    required this.blogDescription,
    required this.imageUrls,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blog_id'],
      blogTitle: json['blog_title'],
      blogDescription: json['blog_description'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}
