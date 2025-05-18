class AcademicEvent {
  final String title;
  final String description;
  final String eventType; // 'EXAM' or 'HOLIDAY'
  final String? examType;
  final String? subject;
  final String? holidayType;
  final String startDate;
  final String endDate;
  final String? startTime;
  final int? duration;
  final String? venue;
  final String year;
  final String semester;

  AcademicEvent({
    required this.title,
    required this.description,
    required this.eventType,
    this.examType,
    this.subject,
    this.holidayType,
    required this.startDate,
    required this.endDate,
    this.startTime,
    this.duration,
    this.venue,
    required this.year,
    required this.semester,
  });

  factory AcademicEvent.fromJson(Map<String, dynamic> json) {
    return AcademicEvent(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventType: json['event_type'] ?? '',
      examType: json['exam_type'],
      subject: json['subject'],
      holidayType: json['holiday_type'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'],
      duration: json['duration'],
      venue: json['venue'],
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'event_type': eventType,
      'start_date': startDate,
      'end_date': endDate,
      'year': year,
      'semester': semester,
    };
    if (eventType == 'EXAM') {
      data.addAll({
        'exam_type': examType,
        'subject': subject,
        'start_time': startTime,
        'duration': duration,
        'venue': venue,
      });
    } else if (eventType == 'HOLIDAY') {
      data['holiday_type'] = holidayType;
    }
    return data;
  }
}