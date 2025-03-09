import 'package:flutter/material.dart';

import '../models/EventsModel.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;  // Add this line to accept event

  // Modify the constructor
  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${event.eventDate}'),
      ),
      body: Column(
        children: [
          // You can display the list of events for the selected day here
          // Example:
          Text(event.title),
          Text(event.description),
          Text(event.venue),
          Text(event.eventDate),
          Text(event.eventStartTime.toString()),
          // Use your own logic to fetch events for the selected day

        ],
      ),
    );
  }
}