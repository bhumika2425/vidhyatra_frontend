import 'package:intl/intl.dart';

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
  final String? studentName;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
    this.studentName,
  });

  // Convert to a Map for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': DateFormat('HH:mm:ss').format(startTime),
      'end_time': DateFormat('HH:mm:ss').format(endTime),
      'date': DateFormat('yyyy-MM-dd').format(startTime),
      'is_booked': isBooked,
      'student_name': studentName,
    };
  }

  // Create TimeSlot from API response
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    final startTimeParts = json['start_time'].split(':');
    final endTimeParts = json['end_time'].split(':');

    return TimeSlot(
      id: json['slot_id'].toString(),
      startTime: DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      ),
      endTime: DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(endTimeParts[0]),
        int.parse(endTimeParts[1]),
      ),
      isBooked: json['is_booked'] ?? false,
      studentName: json['appointment'] != null ? json['appointment']['student']['name'] : null,
    );
  }
}

// // Model class for time slots
// class TimeSlot {
//   final String id;
//   final DateTime startTime;
//   final DateTime endTime;
//   final bool isBooked;
//   final String? studentName;
//
//   TimeSlot({
//     required this.id,
//     required this.startTime,
//     required this.endTime,
//     this.isBooked = false,
//     this.studentName,
//   });
//
//   // Convert to a Map for easier storage
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'startTime': startTime.toIso8601String(),
//       'endTime': endTime.toIso8601String(),
//       'isBooked': isBooked,
//       'studentName': studentName,
//     };
//   }
//
//   // Create TimeSlot from Map
//   factory TimeSlot.fromJson(Map<String, dynamic> json) {
//     return TimeSlot(
//       id: json['id'],
//       startTime: DateTime.parse(json['startTime']),
//       endTime: DateTime.parse(json['endTime']),
//       isBooked: json['isBooked'],
//       studentName: json['studentName'],
//     );
//   }
// }