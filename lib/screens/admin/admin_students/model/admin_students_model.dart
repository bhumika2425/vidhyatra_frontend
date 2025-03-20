import 'dart:convert';


class User {
  final int userId;
  final String collegeId;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.collegeId,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      collegeId: json['college_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Student',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) ?? DateTime.now() : DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'college_id': collegeId,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
