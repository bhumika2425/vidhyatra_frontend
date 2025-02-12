import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNavBar extends StatelessWidget {
  final Function(int) onTap; // Callback function for navigation

  const AdminNavBar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Admin Panel",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildNavItem(Icons.dashboard, "Dashboard", 0),
          _buildNavItem(Icons.event, "Manage Events", 1),
          _buildNavItem(Icons.feedback, "User Feedback", 2),
          _buildNavItem(Icons.settings, "Settings", 3),
          _buildNavItem(Icons.settings, "Settings", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Icon(icon, color: Colors.white),
            SizedBox(width: 15),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
