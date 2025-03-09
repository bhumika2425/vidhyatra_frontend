import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminTopNavBar extends StatelessWidget {
  final Function() onNotificationTap; // Callback function for notification icon tap
  final Function() onProfileTap; // Callback function for profile icon tap

  const AdminTopNavBar({
    Key? key,
    required this.onNotificationTap,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the screen
      height: 60, // Set the height of the top navbar
      color: Color(0xFF042F6B), // Navbar background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 40,),
            child: Text(
              "Vidhyatra Admin", // App name on the left
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onNotificationTap, // Notification icon action
                icon: Icon(Icons.notifications, color: Colors.white),
              ),
              IconButton(
                onPressed: onProfileTap, // Profile icon action
                icon: Icon(Icons.account_circle, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
