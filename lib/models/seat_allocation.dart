class SeatAllocation {
  final int allocationId;
  final int examId;
  final int studentId;
  final String studentName;
  final String rollNumber;
  final int classroomId;
  final String classroomName;
  final int seatNumber;
  final int rowNumber;
  final String position; // 'left', 'center', 'right'
  final DateTime createdAt;
  final bool isPublished;

  SeatAllocation({
    required this.allocationId,
    required this.examId,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.classroomId,
    required this.classroomName,
    required this.seatNumber,
    required this.rowNumber,
    required this.position,
    required this.createdAt,
    required this.isPublished,
  });

  factory SeatAllocation.fromJson(Map<String, dynamic> json) {
    return SeatAllocation(
      allocationId: json['allocation_id'] ?? 0,
      examId: json['exam_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      classroomId: json['classroom_id'] ?? 0,
      classroomName: json['classroom_name'] ?? '',
      seatNumber: json['seat_number'] ?? 0,
      rowNumber: json['row_number'] ?? 0,
      position: json['position'] ?? 'center',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      isPublished: json['is_published'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allocation_id': allocationId,
      'exam_id': examId,
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'classroom_id': classroomId,
      'classroom_name': classroomName,
      'seat_number': seatNumber,
      'row_number': rowNumber,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'is_published': isPublished,
    };
  }

  String get seatLabel {
    return 'Row $rowNumber, Seat $seatNumber';
  }

  String get fullLocation {
    return '$classroomName - $seatLabel';
  }
}
