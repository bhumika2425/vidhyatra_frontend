class Classroom {
  final int classroomId;
  final String name;
  final int capacity;
  final int rows;
  final int seatsPerRow;
  final bool isAvailable;
  final String location;

  Classroom({
    required this.classroomId,
    required this.name,
    required this.capacity,
    required this.rows,
    required this.seatsPerRow,
    required this.isAvailable,
    required this.location,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classroomId: json['classroom_id'] ?? 0,
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      rows: json['rows'] ?? 0,
      seatsPerRow: json['seats_per_row'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classroom_id': classroomId,
      'name': name,
      'capacity': capacity,
      'rows': rows,
      'seats_per_row': seatsPerRow,
      'is_available': isAvailable,
      'location': location,
    };
  }
}
