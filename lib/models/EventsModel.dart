class Event {
  final int eventId;
  final String title;
  final String description;
  final String venue;
  final String eventDate;
  final String? eventStartTime; // Nullable in case it's not provided
  final int createdBy;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.venue,
    required this.eventDate,
    this.eventStartTime, // Optional field
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an Event object from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      venue: json['venue'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventStartTime: json['event_start_time'], // Nullable, no default value
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Convert Event object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'venue': venue,
      'event_date': eventDate,
      'event_start_time': eventStartTime, // Nullable field
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
