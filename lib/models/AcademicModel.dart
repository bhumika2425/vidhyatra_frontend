import 'package:intl/intl.dart';

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
    // Helper to parse and normalize dates to yyyy-MM-dd
    String parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return '';
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        print('Error parsing date $dateStr: $e');
        return '';
      }
    }

    return AcademicEvent(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventType: json['eventType'] ?? '', // Use camelCase
      examType: json['examType'],
      subject: json['subject'],
      holidayType: json['holidayType'],
      startDate: parseDate(json['startDate']), // Use camelCase
      endDate: parseDate(json['endDate']), // Use camelCase
      startTime: json['startTime'],
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
      'eventType': eventType, // Use camelCase
      'startDate': startDate, // Use camelCase
      'endDate': endDate, // Use camelCase
      'year': year,
      'semester': semester,
    };
    if (eventType == 'EXAM') {
      data.addAll({
        'examType': examType,
        'subject': subject,
        'startTime': startTime,
        'duration': duration,
        'venue': venue,
      });
    } else if (eventType == 'HOLIDAY') {
      data['holidayType'] = holidayType;
    }
    return data;
  }
}