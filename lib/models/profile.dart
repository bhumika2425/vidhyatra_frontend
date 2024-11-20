class Profile {
  final int profileId;
  final int userId;
  final String nickname;
  final DateTime dateOfBirth;
  final String location;
  final String year;
  final String semester;
  final String? profileImageUrl;

  Profile({
    required this.profileId,
    required this.userId,
    required this.nickname,
    required this.dateOfBirth,
    required this.location,
    required this.year,
    required this.semester,
    this.profileImageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'],
      userId: json['user_id'],
      nickname: json['nickname'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      location: json['location'],
      year: json['year'],
      semester: json['semester'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}