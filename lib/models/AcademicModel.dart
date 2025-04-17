class Academic {
  final int id;
  final String title;
  final String description;
  final String date;
  final String? venue;
  final String? examStartTime;
  final String? examDuration;
  final String? type;
  final String createdAt;
  final String updatedAt;

  Academic({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.venue,
    this.examStartTime,
    this.examDuration,
    this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Academic.fromJson(Map<String, dynamic> json) {
    return Academic(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['exam_date'] ?? '',
      venue: json['venue'],
      examStartTime: json['exam_start_time'],
      examDuration: json['exam_duration'],
      type: json['type'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exam_date': date,
      'venue': venue,
      'exam_start_time': examStartTime,
      'exam_duration': examDuration,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
