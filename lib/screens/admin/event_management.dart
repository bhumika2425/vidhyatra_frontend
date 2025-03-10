import 'package:flutter/material.dart';
import 'admin_navbar.dart';
import 'admin_top_narbar.dart';

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

  void _onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNotificationTap() {
    // Handle notification tap
  }

  void _onProfileTap() {
    // Handle profile tap
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      print("Event Created: ${_nameController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AdminTopNavBar(
          onNotificationTap: _onNotificationTap,
          onProfileTap: _onProfileTap,
        ),
      ),
      body: Row(
        children: [
          AdminNavBar(onTap: _onNavItemSelected),
          Expanded(
            child: Container(
              color: Color(0xFFE9EDF2),  // Background color for the body
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Section (now 30% of the screen width)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,  // 30% of screen width
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Manage Events", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          SizedBox(height: 10),
                          _buildTextField("Name", _nameController),
                          _buildDescriptionTextField("Description", _descriptionController),
                          _buildTextField("Location", _locationController),
                          _buildTextField("Date", _dateController),
                          _buildTextField("Start Time", _startTimeController),
                          SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF042F6B),  // Set the background color
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),  // Set padding
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),  // Rounded corners
                                ),
                                child: Text(
                                  "Add New Event",  // Button text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,  // White text color
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Existing Content (empty now)
                  Expanded(child: SizedBox.shrink()),
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
          filled: true,  // Enable background fill
          fillColor: Colors.white,  // Set the background color to white
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

  Widget _buildDescriptionTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          filled: true,  // Enable background fill
          fillColor: Colors.white,  // Set the background color to white
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
