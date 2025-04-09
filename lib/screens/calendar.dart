import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Added Google Fonts
import 'package:intl/intl.dart';
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
    _years = List.generate(21, (index) => DateTime.now().year - 2 + index);
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _isSelected[0] ? Color(0xFF186CAC) : Colors.deepOrange,
        elevation: 0,
        title: Text(
          _isSelected[0] ? 'Academic Calendar' : 'Event Calendar',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ToggleButtons(
              isSelected: _isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: _isSelected[1] ? Colors.deepOrange : Color(0xFF186CAC),
              color: Colors.white,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 56.0,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.school),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.event),
                ),
              ],
              splashColor: Colors.grey.withOpacity(0.2),
              highlightColor: Colors.transparent,
              renderBorder: true,
              borderWidth: 1.0,
              borderColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Year Selection Card
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Year",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isSelected[0] ? Color(0xFF186CAC).withOpacity(0.1) : Colors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isSelected[0] ? Color(0xFF186CAC).withOpacity(0.3) : Colors.deepOrange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedYear,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: _isSelected[0] ? Color(0xFF186CAC) : Colors.deepOrange,
                        ),
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
                            child: Text(
                              year.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
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
              headerMargin: const EdgeInsets.only(bottom: 16),
              titleTextStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF186CAC),
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF186CAC)),
              rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF186CAC)),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF186CAC),
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              // Highlight event dates in red
              markerDecoration: BoxDecoration(
                color: Colors.deepOrange, // Event date color
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              defaultTextStyle: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              weekendTextStyle: GoogleFonts.poppins(
                color: Colors.black54,
              ),
              outsideTextStyle: GoogleFonts.poppins(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              weekendStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.deepOrange,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFF186CAC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF186CAC).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Selected Date: ${_formatDate(_selectedAcademicDate)}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Color(0xFF186CAC),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCalendar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: TableCalendar(
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
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerMargin: const EdgeInsets.only(bottom: 16),
              titleTextStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.deepOrange,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.deepOrange),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.deepOrange),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              // Default decoration for calendar days
              defaultDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              // Highlight event dates in red
              markerDecoration: BoxDecoration(
                color: Colors.deepOrange, // Event date color
                shape: BoxShape.circle,
              ),
              defaultTextStyle: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              weekendTextStyle: GoogleFonts.poppins(
                color: Colors.black54,
              ),
              outsideTextStyle: GoogleFonts.poppins(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              weekendStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.deepOrange,
              ),
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
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 5.0, bottom: 5.0), // Adjust as needed
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upcoming Events",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 19,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),

        Expanded(
          child: Obx(() {
            // Check if events are still loading
            if (eventController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              ); // Show a loading spinner while fetching data
            } else if (eventController.errorMessage.value.isNotEmpty) {
              return Center(
                child: Text(
                  eventController.errorMessage.value,
                  style: GoogleFonts.poppins(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ); // Show error message if something goes wrong
            } else {
              // Filter events to show only upcoming events (events after today's date)
              List<Event> upcomingEvents = eventController.events.where((event) {
                DateTime eventDate = DateTime.parse(event.eventDate); // Assuming eventDate is in string format
                return eventDate.isAfter(DateTime.now()); // Check if the event is after today's date
              }).toList();

              if (upcomingEvents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No upcoming events',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: upcomingEvents.length,
                  itemBuilder: (context, index) {
                    Event event = upcomingEvents[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        title: Text(
                          event.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              event.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Date: ${event.eventDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.deepOrange,
                          ),
                        ),
                        onTap: () {
                          Get.to(EventDetailsPage(event: event));
                        },
                      ),
                    );
                  },
                );
              }
            }
          }),
        ),
      ],
    );
  }

  void _showEventDetailsDialog(DateTime selectedDay) {
    // Filter events for the selected day
    List<Event> eventsForSelectedDay = eventController.events.where((event) {
      DateTime eventDate = DateTime.parse(event.eventDate); // Assuming eventDate is in string format
      return isSameDay(eventDate, selectedDay); // Check if the event is on the selected date
    }).toList();

    // Format the selected date for display
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(selectedDay);

    // Show a dialog with the events for the selected day
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: Get.height * 0.5,
            width: Get.width * 0.8,
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Events on ${formattedDate}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 24,
                ),
                Expanded(
                  child: eventsForSelectedDay.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No events for this date.',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: eventsForSelectedDay.map((event) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 12),
                              _buildEventDetailRow(
                                Icons.description,
                                'Description:',
                                event.description,
                              ),
                              SizedBox(height: 8),
                              _buildEventDetailRow(
                                Icons.location_on,
                                'Venue:',
                                event.venue,
                              ),
                              SizedBox(height: 8),
                              _buildEventDetailRow(
                                Icons.access_time,
                                'Start Time:',
                                event.eventStartTime ?? 'TBA',
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.deepOrange,
        ),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}