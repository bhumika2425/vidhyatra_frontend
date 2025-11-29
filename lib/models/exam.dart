class Exam {
  final int examId;
  final String moduleName;
  final String moduleCode;
  final DateTime examDate;
  final String startTime;
  final String endTime;
  final int duration; // in minutes
  final String year;
  final String semester;
  final int totalStudents;
  final String status; // 'scheduled', 'published', 'completed'
  final String examType; // 'midterm', 'final', 'sessional'

  Exam({
    required this.examId,
    required this.moduleName,
    required this.moduleCode,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.year,
    required this.semester,
    required this.totalStudents,
    required this.status,
    required this.examType,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      examId: json['exam_id'] ?? 0,
      moduleName: json['module_name'] ?? '',
      moduleCode: json['module_code'] ?? '',
      examDate: DateTime.parse(json['exam_date'] ?? DateTime.now().toString()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      duration: json['duration'] ?? 0,
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
      totalStudents: json['total_students'] ?? 0,
      status: json['status'] ?? 'scheduled',
      examType: json['exam_type'] ?? 'midterm',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'module_name': moduleName,
      'module_code': moduleCode,
      'exam_date': examDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'duration': duration,
      'year': year,
      'semester': semester,
      'total_students': totalStudents,
      'status': status,
      'exam_type': examType,
    };
  }

  String get formattedDate {
    return '${examDate.day}/${examDate.month}/${examDate.year}';
  }

  String get timeRange {
    return '$startTime - $endTime';
  }
}
