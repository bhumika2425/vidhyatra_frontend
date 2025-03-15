import 'package:flutter/material.dart';

import 'admin_navbar.dart';
import 'admin_top_narbar.dart';

class ManageRoutine extends StatefulWidget {
  const ManageRoutine({super.key});

  @override
  State<ManageRoutine> createState() => _ManageRoutineState();
}

class _ManageRoutineState extends State<ManageRoutine> {
  int selectedIndex = 0;

  String? selectedFaculty;
  String? selectedYear;
  String? selectedSection;
  String? selectedDay;
  String? selectedSubject;
  String? selectedTeacher;
  String? selectedRoom;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

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

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          selectedStartTime = picked;
        } else {
          selectedEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AdminTopNavBar(
        ),
      ),
      body: Container(
        color: Color(0xFFE9EDF2),
        child: Row(
          children: [
            AdminNavBar(onTap: _onNavItemSelected),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildRoutineContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Routine Management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 16),

        Row(
          children: [
            _buildStyledDropdown(
              value: selectedFaculty,
              hint: "Select Faculty",
              items: ["BBA", "BIT"],
              onChanged: (newValue) => setState(() => selectedFaculty = newValue),
            ),
            SizedBox(width: 20),
            _buildStyledDropdown(
              value: selectedYear,
              hint: "Select Year",
              items: ["1st", "2nd", "3rd"],
              onChanged: (newValue) => setState(() => selectedYear = newValue),
            ),
            SizedBox(width: 20),
            _buildStyledDropdown(
              value: selectedSection,
              hint: "Select Section",
              items: ["C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10"],
              onChanged: (newValue) => setState(() => selectedSection = newValue),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                // Handle create routine logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF042F6B),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Create Routine", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text("Enter Routine Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        Row(
          children: [
            _buildStyledDropdown(
              value: selectedDay,
              hint: "Select Day",
              items: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
              onChanged: (newValue) => setState(() => selectedDay = newValue),
            ),
            SizedBox(width: 20),
            _buildStyledDropdown(
              value: selectedSubject,
              hint: "Select Subject",
              items: ["Application Development", "Artificial Intelligence", "Data & Web Dev", "Software Dev", "Fundamentals of Computing", "Advanced Programming"],
              onChanged: (newValue) => setState(() => selectedSubject = newValue),
            ),
            SizedBox(width: 20),
            _buildStyledDropdown(
              value: selectedTeacher,
              hint: "Select Teacher",
              items: ["Prathiva Gurung", "Sandip Adhikari", "Sandeep Gurung", "Sandip Dhakal", "Amar Khanal"],
              onChanged: (newValue) => setState(() => selectedTeacher = newValue),
            ),
            SizedBox(width: 20),
            _buildStyledDropdown(
              value: selectedRoom,
              hint: "Select Room",
              items: ["Nepal-Fewa", "Nepal-Tilicho", "Nepal-Rara", "UK-BigBen", "UK-Thames"],
              onChanged: (newValue) => setState(() => selectedRoom = newValue),
            ),
            SizedBox(width: 20),
            _buildTimePicker(
              selectedTime: selectedStartTime,
              hint: "Select Start Time",
              onTap: () => _selectTime(context, true),
            ),
            SizedBox(width: 20),
            _buildTimePicker(
              selectedTime: selectedEndTime,
              hint: "Select End Time",
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Next action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF042F6B),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Next", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStyledDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(fontSize: 14, color: Colors.black)),
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontSize: 14)))).toList(),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required TimeOfDay? selectedTime,
    required String hint,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          selectedTime != null ? selectedTime.format(context) : hint,
          style: TextStyle(fontSize: 14, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
