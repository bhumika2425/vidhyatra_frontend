class Blog {
  final int blogId;
  final String blogTitle;
  final String blogDescription;
  final int userId; // Foreign key for the user

  Blog({
    required this.blogId,
    required this.blogTitle,
    required this.blogDescription,
    required this.userId,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blog_id'],
      blogTitle: json['blog_title'],
      blogDescription: json['blog_description'],
      userId: json['user_id'], // Ensure user_id is fetched correctly
    );
  }
}
