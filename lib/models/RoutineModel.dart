
class RoutineConfig {
  final int configId;
  final String faculty;
  final String year;
  final String semester;
  final String section;

  RoutineConfig({
    required this.configId,
    required this.faculty,
    required this.year,
    required this.semester,
    required this.section,
  });

  factory RoutineConfig.fromJson(Map<String, dynamic> json) {
    return RoutineConfig(
      configId: json['config_id'],
      faculty: json['faculty'],
      year: json['year'],
      semester: json['semester'],
      section: json['section'],
    );
  }
}

class RoutineEntry {
  final String subject;
  final String teacher;
  final String room;
  final String startTime;
  final String endTime;

  RoutineEntry({
    required this.subject,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  factory RoutineEntry.fromJson(Map<String, dynamic> json) {
    return RoutineEntry(
      subject: json['subject'],
      teacher: json['teacher'],
      room: json['room'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class RoutineByDay {
  final RoutineConfig config;
  final Map<String, List<RoutineEntry>> routinesByDay;

  RoutineByDay({
    required this.config,
    required this.routinesByDay,
  });

  factory RoutineByDay.fromJson(Map<String, dynamic> json) {
    final Map<String, List<RoutineEntry>> routines = {};
    json['routinesByDay'].forEach((day, entries) {
      routines[day] = (entries as List)
          .map((entry) => RoutineEntry.fromJson(entry))
          .toList();
    });

    return RoutineByDay(
      config: RoutineConfig.fromJson(json['config']),
      routinesByDay: routines,
    );
  }
}