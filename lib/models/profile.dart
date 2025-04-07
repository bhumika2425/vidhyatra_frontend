class Profile {
  final int profileId;
  final int userId;
  final String fullname;
  final DateTime dateOfBirth;
  final String location;
  final String department;
  final String year;
  final String semester;
  final String? profileImageUrl;
  final String? bio; // Add bio field
  final String? interest; // Add interest field

  Profile({
    required this.profileId,
    required this.userId,
    required this.fullname,
    required this.dateOfBirth,
    required this.location,
    required this.department,
    required this.year,
    required this.semester,
    this.profileImageUrl,
    this.bio, // Initialize bio
    this.interest, // Initialize interest
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'],
      userId: json['user_id'],
      fullname: json['full_name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      location: json['location'],
      department: json['department'],
      year: json['year'],
      semester: json['semester'],
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'], // Assign bio from the JSON response
      interest: json['interest'], // Assign interest from the JSON response
    );
  }
}
