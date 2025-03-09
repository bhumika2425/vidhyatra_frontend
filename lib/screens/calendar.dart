import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:table_calendar/table_calendar.dart';
import 'package:vidhyatra_flutter/controllers/EventController.dart';

import '../models/EventsModel.dart';
import 'EventDetailsPage.dart';

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

  // Format date to show only the date part (no time)
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Adjust the format as needed
  }

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelected[0] ? 'Academic Calendar' : 'Event Calendar'),
        actions: [
          ToggleButtons(
            isSelected: _isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _isSelected.length; i++) {
                  _isSelected[i] = i == index;
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: _isSelected[1] ? Colors.green : Color(0xFF971F20),
            color: Colors.black,
            constraints: const BoxConstraints(
              minHeight: 36.0,
              minWidth: 50.0,
            ),
            children: [
              Icon(Icons.school), // Icon for Academic Calendar
              Icon(Icons.event),  // Icon for Event Calendar
            ],
            splashColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.transparent,
            renderBorder: true,
            // borderWidth: 2.0,
            // borderColor: Color(0xFF971F20),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Year Selection Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Selected year", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                        _focusedAcademicDay = DateTime(_selectedYear, _focusedAcademicDay.month, _focusedAcademicDay.day);
                        _focusedEventDay = DateTime(_selectedYear, _focusedEventDay.month, _focusedEventDay.day);
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
            // Display the selected calendar
            Expanded(
              child: _isSelected[0]
                  ? _buildAcademicCalendar() // Academic Calendar
                  : _buildEventCalendar(), // Event Calendar
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicCalendar() {
    return Column(
      children: [
        TableCalendar(
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
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xFF971F20),
              border: Border.all(
                  color: Color(0xFF971F20), width: 2),
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xFF971F20),
              border: Border.all(color: Color(0xFF971F20), width: 2),
            ),
            defaultDecoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            // Highlight event dates in red
            markerDecoration: BoxDecoration(
              color: Colors.red, // Event date color
              shape: BoxShape.circle,
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
          'Selected Date: ${_formatDate(_selectedAcademicDate)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

 
  Widget _buildEventCalendar() {
    // Timer? _tapTimer;

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
            // Trigger the dialog immediately when a single tap occurs
            _showEventDetailsDialog(selectedDay);

            // Update selected date and focused day
            setState(() {
              _selectedEventDate = selectedDay;
              _focusedEventDay = focusedDay;
            });
          // onDaySelected: (selectedDay, focusedDay) {
          //   if (_tapTimer != null) {
          //     _tapTimer!.cancel();
          //     _tapTimer = null;
          //     // Show a dialog box with event details when a date is selected
          //     _showEventDetailsDialog(selectedDay);
          //   } else {
          //     _tapTimer = Timer(const Duration(milliseconds: 300), () {
          //       setState(() {
          //         _selectedEventDate = selectedDay;
          //         _focusedEventDay = focusedDay;
          //       });
          //       _tapTimer = null;
          //     });
          //   }
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
            // Default decoration for calendar days
            defaultDecoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            // Highlight event dates in red
            markerDecoration: BoxDecoration(
              color: Colors.red, // Event date color
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            weekendStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
          ),
          // Function to mark the days with events
          eventLoader: (day) {
            // Filter events to find out if the day has events
            List<Event> eventsForDay = eventController.events.where((event) {
              DateTime eventDate = DateTime.parse(event.eventDate); // Assuming eventDate is in string format
              return isSameDay(eventDate, day); // Check if the event date matches the selected day
            }).toList();

            // Return the events for this day
            return eventsForDay.isNotEmpty ? [''] : []; // If there are events, mark the day
          },
        ),
        const SizedBox(height: 20),
        Text("Upcoming Events", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        SizedBox(height: 10,),
        Obx(() {
          // Check if events are still loading
          if (eventController.isLoading.value) {
            return CircularProgressIndicator(); // Show a loading spinner while fetching data
          } else if (eventController.errorMessage.value.isNotEmpty) {
            return Text(
              eventController.errorMessage.value,
              style: TextStyle(color: Colors.red),
            ); // Show error message if something goes wrong
          } else {
            // Filter events to show only upcoming events (events after today's date)
            List<Event> upcomingEvents = eventController.events.where((event) {
              DateTime eventDate = DateTime.parse(event.eventDate); // Assuming eventDate is in string format
              return eventDate.isAfter(DateTime.now()); // Check if the event is after today's date
            }).toList();

            if (upcomingEvents.isEmpty) {
              return Text('No upcoming events.');
            } else {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: upcomingEvents.length,
                  itemBuilder: (context, index) {
                    Event event = upcomingEvents[index];
                    return Card( // Use a card for better UI presentation
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.description),
                            Text('Date: ${event.eventDate}'), // Time is optional, hence nullable
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(EventDetailsPage(event: event,));
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }
        }),
      ],
    );
  }

  void _showEventDetailsDialog(DateTime selectedDay) {
    // Filter events for the selected day
    List<Event> eventsForSelectedDay = eventController.events.where((event) {
      DateTime eventDate = DateTime.parse(event.eventDate); // Assuming eventDate is in string format
      return isSameDay(eventDate, selectedDay); // Check if the event is on the selected date
    }).toList();

    // Show a dialog with the events for the selected day
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: Get.height * 0.35,
            width: Get.height * 0.35,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Events on ${selectedDay.toLocal()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: eventsForSelectedDay.isEmpty
                          ? [
                        Text(
                          'No events for this date.',
                          style: TextStyle(fontSize: 16),
                        )
                      ]
                          : eventsForSelectedDay.map((event) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text('Description: ${event.description}'),
                              SizedBox(height: 8),
                              Text('Venue: ${event.venue}'),
                              SizedBox(height: 8),
                              Text('Start Time: ${event.eventStartTime ?? 'TBA'}'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
