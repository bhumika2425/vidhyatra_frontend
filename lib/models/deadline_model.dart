class Deadline {
  final int id;
  final String title;
  final String course;
  final DateTime deadline;
  bool isCompleted;

  Deadline({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.isCompleted,
  });

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'] == 1 || json['isCompleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}