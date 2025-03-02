import 'dart:convert';

class Event {
  final int eventId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String eventDate;
  final int createdBy;
  final String venue;
  final String createdAt;

  Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.eventDate,
    required this.createdBy,
    required this.venue,
    required this.createdAt,
  });

  // Convert a Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      eventDate: json['event_date'],
      createdBy: json['created_by'],
      venue: json['venue'],
      createdAt: json['createdAt'],
    );
  }

  // Convert a Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'description': description,
      'image_urls': imageUrls,
      'event_date': eventDate,
      'created_by': createdBy,
      'venue': venue,
      'createdAt': createdAt,
    };
  }
}
