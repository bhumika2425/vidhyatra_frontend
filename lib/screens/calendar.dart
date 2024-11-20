
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    // _fetchEventsFromBackend(); // Fetch events when page is initialized
  }

  // Method to fetch events from the backend
  // Future<void> _fetchEventsFromBackend() async {
  //   final response = await http.get(Uri.parse('https://example.com/events')); // Replace with your API URL
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body); // Assuming your backend returns JSON data
  //     Map<DateTime, List<dynamic>> fetchedEvents = {};
  //
  //     for (var event in data) {
  //       DateTime eventDate = DateTime.parse(event['date']); // Parse the date from your backend
  //       String eventTitle = event['title']; // Get the event title
  //
  //       // Add events to the map
  //       if (fetchedEvents[eventDate] == null) {
  //         fetchedEvents[eventDate] = [eventTitle];
  //       } else {
  //         fetchedEvents[eventDate]!.add(eventTitle);
  //       }
  //     }
  //
  //     setState(() {
  //       _events = fetchedEvents; // Update the state with fetched events
  //     });
  //   } else {
  //     // Handle error
  //     throw Exception('Failed to load events');
  //   }
  // }

  // Method to return events for a specific day
  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Update focused day
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay, // Loads events for the day
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  // Builds the list of events for the selected day
  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return Center(
        child: Text('No events for the selected day'),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index]),
        );
      },
    );
  }
}