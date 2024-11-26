import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // State for the toggle buttons
  List<bool> _isSelected = [true, false];

  // Selected date for each calendar
  DateTime _selectedAcademicDate = DateTime.now();
  DateTime _selectedEventDate = DateTime.now();

  // Initialize the focused day for each calendar
  late DateTime _focusedAcademicDay;
  late DateTime _focusedEventDay;

  // Define the first and last day for both calendars
  late DateTime _firstDay;
  late DateTime _lastDay;

  // Store the list of available years (10 years before and after the current year)
  late List<int> _years;
  late int _selectedYear;

  // Sample event data for specific dates (example)
  Map<DateTime, List<String>> _events = {
    DateTime(2024, 08, 08): ['Event 1: Bhumika bhai ko birthday'],
    DateTime(2024, 10, 11): ['Event 1: Saurabh dai ko birthday'],
    DateTime(2024, 11, 23): [
      'Event 1: Academic Workshop',
      'Event 2: Conference'
    ],
    DateTime(2024, 11, 24): ['Event 1: Sports Day'],
    DateTime(2024, 12, 1): ['Event 1: Festival'],
    // Add more events as needed
  };

  @override
  void initState() {
    super.initState();
    _focusedAcademicDay = DateTime.now();
    _focusedEventDay = DateTime.now();

    // Set the first and last days of the calendar
    _firstDay = DateTime(DateTime.now().year - 10, 1, 1); // 10 years ago
    _lastDay = DateTime(DateTime.now().year + 10, 12, 31); // 10 years from now

    // Initialize years list and selected year (10 years before to 10 years after)
    _years = List.generate(21, (index) => DateTime.now().year - 10 + index);
    _selectedYear = DateTime.now().year;
  }

  // Get events for the selected date
  List<String> _getEventsForDay(DateTime day) {
    // Ensure that the comparison takes date only (ignoring time)
    day = DateTime(day.year, day.month, day.day); // Reset time part to 00:00:00
    return _events[day] ??
        []; // Return events for the selected day, or an empty list if none exist
  }

  // Format date to show only the date part (no time)
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Adjust the format as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected: _isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                });
              },
              borderRadius: BorderRadius.circular(30),
              selectedColor: Colors.white,
              fillColor: Theme.of(context).primaryColor,
              color: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 50.0,
                minWidth: 150.0,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Academic Calendar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // You can change the font family
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Event Calendar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // You can change the font family
                    ),
                  ),
                ),
              ],
              splashColor: Colors.grey.withOpacity(0.2), // Add splash effect on tap
              highlightColor: Colors.transparent, // Remove default highlight color
              renderBorder: true, // Render the border even when the button is not selected
              borderWidth: 2.5, // Set border width
              borderColor: Colors.grey.shade300, // Set border color
            ),
          ),
          const SizedBox(height: 20),
          // Year Selection Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Selected year", style: TextStyle( fontSize: 16),),
                SizedBox(width: 10,),
                DropdownButton<int>(
                  value: _selectedYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                      _focusedAcademicDay = DateTime(_selectedYear,
                          _focusedAcademicDay.month, _focusedAcademicDay.day);
                      _focusedEventDay = DateTime(_selectedYear,
                          _focusedEventDay.month, _focusedEventDay.day);
                    });
                  },
                  items: _years.map<DropdownMenuItem<int>>((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Display the selected calendar
          Expanded(
            child: _isSelected[0]
                ? _buildAcademicCalendar() // Academic Calendar
                : _buildEventCalendar(), // Event Calendar
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicCalendar() {
    return Column(
      children: [
        Container(
          child: TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedAcademicDay,
            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedAcademicDate);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedAcademicDate = selectedDay;
                _focusedAcademicDay = focusedDay;
                // Update the event date when academic calendar is selected
                _selectedEventDate = selectedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerMargin: const EdgeInsets.only(bottom: 8),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, // Font weight for the year
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                // Custom color for today's date in Academic Calendar
                border: Border.all(
                    color: Colors.blue, width: 2), // Border for today's date
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green, // Custom color for selected date
                border: Border.all(
                    color: Colors.green, width: 2), // Border for selected date
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              // Text color for selected day
              todayTextStyle: const TextStyle(color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  fontWeight: FontWeight.w500, // Font weight for weekdays
                  color: Colors.black),
              weekendStyle: TextStyle(
                  fontWeight: FontWeight.w300, // Font weight for weekends
                  color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Selected Date: ${_formatDate(_selectedAcademicDate)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
  Widget _buildEventCalendar() {
    Timer? _tapTimer; // Timer to differentiate single and double taps
    DateTime? _tappedDate;

    return Column(
      children: [
        TableCalendar(
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedEventDay,
          selectedDayPredicate: (day) {
            return isSameDay(day, _selectedEventDate);
          },
          onDaySelected: (selectedDay, focusedDay) {
            // Handle single and double-tap logic
            if (_tapTimer != null) {
              _tapTimer!.cancel(); // Cancel the timer for double tap
              _tapTimer = null;

              // Double-tap logic: Navigate to the event details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(selectedDate: selectedDay),
                ),
              );
            } else {
              // Set up a timer for single tap
              _tappedDate = selectedDay;
              _tapTimer = Timer(const Duration(milliseconds: 300), () {
                setState(() {
                  // Single-tap logic: Show events for the selected day
                  _selectedEventDate = _tappedDate!;
                  _focusedEventDay = focusedDay;
                });
                _tapTimer = null; // Reset the timer
              });
            }
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerMargin: const EdgeInsets.only(bottom: 8),
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.green, width: 2),
            ),
            selectedTextStyle: const TextStyle(color: Colors.white),
            todayTextStyle: const TextStyle(color: Colors.white),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            weekendStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Selected Date: ${_formatDate(_selectedEventDate)}',
          style: const TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events for ${_formatDate(_selectedEventDate)}:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._getEventsForDay(_selectedEventDate)
                  .map((event) => Text(event))
                  .toList(),
              if (_getEventsForDay(_selectedEventDate).isEmpty)
                const Text('No events for this day.'),
            ],
          ),
        ),
      ],
    );
  }


}

class EventDetailsPage extends StatelessWidget {
  final DateTime selectedDate;

  // Constructor to pass the selected date
  EventDetailsPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${_formatDate(selectedDate)}'),
      ),
      body: Column(
        children: [
          // You can display the list of events for the selected day here
          // Example:
          Text('Events for ${_formatDate(selectedDate)}'),
          // Use your own logic to fetch events for the selected day
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _getEventsForDay(selectedDate), // Replace with your method
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No events for this day.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                        // Optionally, add an image for each event
                        // leading: Image.network('your_image_url'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Example method to get events for the day (replace with your logic)
  Future<List<String>> _getEventsForDay(DateTime date) async {
    // You can fetch events from a database or API
    // Here's a sample return:
    return ['Event 1', 'Event 2', 'Event 3'];
  }

  // Helper method to format the date
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}



