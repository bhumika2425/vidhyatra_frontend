import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../admin_navbar.dart';
import '../../admin_top_narbar.dart';
import '../controller/event_posting_controller.dart';
import '../model/event_posting_model.dart';

class ManageEvent extends StatefulWidget {
  const ManageEvent({super.key});

  @override
  State<ManageEvent> createState() => _ManageEventState();
}

class _ManageEventState extends State<ManageEvent> {
  int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  final EventPostingController eventController =
      Get.find<EventPostingController>();

  void _onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Fetch events when the page is loaded
  @override
  void initState() {
    super.initState();
    eventController.fetchEvents(); // Fetch events from the server or database

    // Optionally you can reset the controllers here, too, if you want to clear them on navigating back.
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _dateController.clear();
    _startTimeController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    // You can also reset the state when the page is disposed of.
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
  }

  // Helper function to convert TimeOfDay to HH:mm format
  String _convertTo24HourFormat(TimeOfDay time) {
    final DateFormat formatter = DateFormat('HH:mm');
    final DateTime parsedTime = DateTime(0, 0, 0, time.hour, time.minute);
    return formatter.format(parsedTime);
  }

  // Function to open time picker and set the time in the controller
  Future<void> _selectStartTime() async {
    TimeOfDay selectedTime = TimeOfDay.now(); // default time is current time
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      _startTimeController.text = _convertTo24HourFormat(picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Prepare event data and create an Event instance
      Event newEvent = Event(
        title: _nameController.text,
        description: _descriptionController.text,
        venue: _locationController.text,
        eventDate: _dateController.text,
        eventStartTime: _startTimeController.text,
        createdAt: DateTime.now().toIso8601String(),
        // Set current timestamp for createdAt
        updatedAt: DateTime.now()
            .toIso8601String(), // Set current timestamp for updatedAt
      );

      // Call the postEvent method from EventController
      eventController.postEvent(newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AdminTopNavBar(),
      ),
      body: Row(
        children: [
          AdminNavBar(onTap: _onNavItemSelected),
          Expanded(
            child: Container(
              color: Color(0xFFE9EDF2), // Background color for the body
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Section (now 30% of the screen width)
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.3, // 30% of screen width
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Manage Events",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          SizedBox(height: 10),
                          _buildTextField("Name", _nameController),
                          _buildDescriptionTextField(
                              "Description", _descriptionController),
                          _buildTextField("Location", _locationController),
                          _buildTextField("Date", _dateController),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: _startTimeController,
                              readOnly: true,
                              // Makes the text field read-only
                              decoration: InputDecoration(
                                labelText: "Start Time",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a start time";
                                }
                                return null;
                              },
                              onTap:
                                  _selectStartTime, // Open time picker when tapped
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF042F6B),
                                  // Set the background color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  // Set padding
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10)), // Rounded corners
                                ),
                                child: Text(
                                  "Add New Event", // Button text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Existing Content (empty now)
                  Expanded(
                    child: Obx(() {
                      // Checking if the events are still loading
                      if (eventController.isLoading.value) {
                        return Center(
                            child:
                                CircularProgressIndicator()); // Show loading spinner
                      } else if (eventController.errorMessage.isNotEmpty) {
                        return Center(
                            child: Text(
                                'Error: ${eventController.errorMessage}')); // Show error message
                      } else if (eventController.events.isEmpty) {
                        return Center(
                            child: Text(
                                'No events available')); // Show no events message
                      } else {
                        // Display events in a ListView
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                "Events", // Title at the top
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: eventController.events.length,
                                itemBuilder: (context, index) {
                                  var event = eventController.events[index];
                                  return Card(
                                    color: Colors.white,
                                    // Set the card color to white
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Container(
                                            // width: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF053985),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 13),
                                              child: Text("${index + 1}", style: TextStyle(color: Colors.white),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text("${event.title}"),
                                            // Display event number and title
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Description: ${event.description}"),
                                                Text("Venue: ${event.venue}"),
                                                Text(
                                                    "Date: ${event.eventDate}"),
                                                Text(
                                                    "Start Time: ${event.eventStartTime}"),
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Edit button
                                                IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  onPressed: () {
                                                    // Trigger edit action
                                                    // _editEvent(event);
                                                  },
                                                ),
                                                // Delete button
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    // Trigger delete action
                                                    // _deleteEvent(event);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true, // Enable background fill
          fillColor: Colors.white, // Set the background color to white
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          filled: true, // Enable background fill
          fillColor: Colors.white, // Set the background color to white
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
