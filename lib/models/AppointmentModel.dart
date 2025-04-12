class Appointment {
  final int appointmentId;
  final int slotId;
  final int studentId;
  final String status;
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TimeSlot timeSlot;

  Appointment({
    required this.appointmentId,
    required this.slotId,
    required this.studentId,
    required this.status,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.timeSlot,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'] as int,
      slotId: json['slot_id'] as int,
      studentId: json['student_id'] as int,
      status: json['status'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      timeSlot: TimeSlot.fromJson(json['timeSlot'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'slot_id': slotId,
      'student_id': studentId,
      'status': status,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'timeSlot': timeSlot.toJson(),
    };
  }
}

class TimeSlot {
  final int slotId;
  final int teacherId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isBooked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Teacher teacher;

  TimeSlot({
    required this.slotId,
    required this.teacherId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.createdAt,
    required this.updatedAt,
    required this.teacher,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      slotId: json['slot_id'] as int,
      teacherId: json['teacher_id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isBooked: json['is_booked'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot_id': slotId,
      'teacher_id': teacherId,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'is_booked': isBooked,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'teacher': teacher.toJson(),
    };
  }
}

class Teacher {
  final int userId;
  final String name;
  final String email;

  Teacher({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
    };
  }
}