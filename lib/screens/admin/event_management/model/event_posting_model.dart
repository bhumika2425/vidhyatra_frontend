class Event {
  final String title;
  final String description;
  final String venue;
  final String eventDate;
  final String eventStartTime;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.title,
    required this.description,
    required this.venue,
    required this.eventDate,
    required this.eventStartTime,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to Event object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? 'No Title',  // Default value for title if null
      description: json['description'] ?? 'No Description',  // Default value for description if null
      venue: json['venue'] ?? 'Unknown Venue',  // Default value for venue if null
      eventDate: json['event_date'] ?? 'Unknown Date',  // Default value for eventDate if null
      eventStartTime: json['event_start_time'] ?? 'Unknown Time',  // Default value for eventStartTime if null
      createdAt: json['created_at'] ?? '',  // Default empty string if null
      updatedAt: json['updated_at'] ?? '',  // Default empty string if null
    );
  }

  // Convert Event object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'venue': venue,
      'event_date': eventDate,
      'event_start_time': eventStartTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
