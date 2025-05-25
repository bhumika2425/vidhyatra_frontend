// import 'package:intl/intl.dart';
//
// class TimeSlot {
//   final String id;
//   final DateTime startTime;
//   final DateTime endTime;
//   final bool isBooked;
//   final Student? student;  // Changed from studentName to student object
//   final Teacher teacher;
//
//   TimeSlot({
//     required this.id,
//     required this.startTime,
//     required this.endTime,
//     this.isBooked = false,
//     this.student,
//     required this.teacher,
//   });
//
//   // Convert to a Map for API requests
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'start_time': DateFormat('HH:mm:ss').format(startTime),
//       'end_time': DateFormat('HH:mm:ss').format(endTime),
//       'date': DateFormat('yyyy-MM-dd').format(startTime),
//       'is_booked': isBooked,
//       'student': student?.toJson(),
//       'teacher': teacher.toJson(),
//     };
//   }
//
//   // Create TimeSlot from API response
//   factory TimeSlot.fromJson(Map<String, dynamic> json) {
//     final date = DateTime.parse(json['date']);
//     final startTimeParts = json['start_time'].split(':');
//     final endTimeParts = json['end_time'].split(':');
//
//     return TimeSlot(
//       id: json['slot_id'].toString(),
//       startTime: DateTime(
//         date.year,
//         date.month,
//         date.day,
//         int.parse(startTimeParts[0]),
//         int.parse(startTimeParts[1]),
//       ),
//       endTime: DateTime(
//         date.year,
//         date.month,
//         date.day,
//         int.parse(endTimeParts[0]),
//         int.parse(endTimeParts[1]),
//       ),
//       isBooked: json['is_booked'] ?? false,
//       student: json['student'] != null ? Student.fromJson(json['student']) : null,
//       teacher: Teacher.fromJson(json['teacher']),
//     );
//   }
// }
//
// // Add Student class to handle student information
// class Student {
//   final String id;
//   final String name;
//   final String email;
//
//   Student({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user_id': id,
//       'name': name,
//       'email': email,
//     };
//   }
//
//   factory Student.fromJson(Map<String, dynamic> json) {
//     return Student(
//       id: json['user_id'].toString(),
//       name: json['name'],
//       email: json['email'],
//     );
//   }
// }
//
// // Add Teacher class to handle teacher information
// class Teacher {
//   final String id;
//   final String name;
//   final String email;
//
//   Teacher({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user_id': id,
//       'name': name,
//       'email': email,
//     };
//   }
//
//   factory Teacher.fromJson(Map<String, dynamic> json) {
//     return Teacher(
//       id: json['user_id'].toString(),
//       name: json['name'],
//       email: json['email'],
//     );
//   }
// }

import 'package:intl/intl.dart';

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
  final Student? student;
  final String teacherId; // Changed from Teacher to teacherId

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
    this.student,
    required this.teacherId,
  });

  // Convert to a Map for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': DateFormat('HH:mm:ss').format(startTime),
      'end_time': DateFormat('HH:mm:ss').format(endTime),
      'date': DateFormat('yyyy-MM-dd').format(startTime),
      'is_booked': isBooked,
      'student': student?.toJson(),
      'teacher_id': teacherId,
    };
  }

  // Create TimeSlot from API response
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String?;
    final startTimeStr = json['start_time'] as String?;
    final endTimeStr = json['end_time'] as String?;
    final teacherId = json['teacher_id']?.toString();

    if (dateStr == null || startTimeStr == null || endTimeStr == null || teacherId == null) {
      throw FormatException('Missing required fields in TimeSlot JSON: $json');
    }

    final date = DateTime.parse(dateStr);
    final startTimeParts = startTimeStr.split(':');
    final endTimeParts = endTimeStr.split(':');

    if (startTimeParts.length < 2 || endTimeParts.length < 2) {
      throw FormatException('Invalid time format in TimeSlot JSON: start_time=$startTimeStr, end_time=$endTimeStr');
    }

    return TimeSlot(
      id: (json['slot_id'] ?? '').toString(),
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
      isBooked: json['is_booked'] as bool? ?? false,
      student: json['student'] != null ? Student.fromJson(json['student'] as Map<String, dynamic>) : null,
      teacherId: teacherId,
    );
  }
}

// Student class (unchanged)
class Student {
  final String id;
  final String name;
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['user_id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}