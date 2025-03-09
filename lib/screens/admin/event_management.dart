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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Height of the top navbar
        child: AdminTopNavBar(
          onNotificationTap: _onNotificationTap,
          onProfileTap: _onProfileTap,
        ),
      ),
      body: Row(
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
    );
  }

  Widget _buildRoutineContent (){
    return Column(
      children: [
        Text("THis is event management page"),
      ],
    );
  }
}