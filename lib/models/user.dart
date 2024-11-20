// models/user.dart
class User {
  final int userId; // Assuming userId is of type int
  final String collegeId;
  final String name;
  final String email;
  final bool hasProfile; // Add this property

  User({required this.userId, required this.collegeId, required this.name, required this.email, this.hasProfile = false});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'], // Ensure this key matches your API response
      collegeId: json['college_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}