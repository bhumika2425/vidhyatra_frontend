class Profile {
  final int? profileId; // Make nullable since API doesn't return this
  final int userId;
  final String fullname;
  final DateTime? dateOfBirth; // Make nullable
  final String? location; // Make nullable
  final String department;
  final String year;
  final String semester;
  final String section;
  final String? profileImageUrl;
  final String? bio;
  final String? interest;
  final String? phoneNumber; // Add phone number field
  final String email; // Add email field
  final String collegeId; // Add college ID field
  final String role; // Add role field

  Profile({
    this.profileId, // Make optional
    required this.userId,
    required this.fullname,
    this.dateOfBirth, // Make optional
    this.location, // Make optional
    required this.department,
    required this.year,
    required this.semester,
    required this.section,
    this.profileImageUrl,
    this.bio,
    this.interest,
    this.phoneNumber,
    required this.email,
    required this.collegeId,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'], // Can be null
      userId: json['user_id'],
      fullname: json['full_name'] ?? json['name'], // Handle both field names
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      location: json['location'],
      department: json['department'],
      year: json['year'],
      semester: json['semester'],
      section: json['section'],
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      interest: json['interest'],
      phoneNumber: json['phone_number'],
      email: json['email'] ?? json['college_email'],
      collegeId: json['college_id'],
      role: json['role'],
    );
  }
}
