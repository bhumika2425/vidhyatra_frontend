import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminTopNavBar extends StatelessWidget {

  const AdminTopNavBar({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the screen
      height: 60, // Set the height of the top navbar
      color: Color(0xFF042F6B), // Navbar background color
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
          children: [
            Row(
              children: [
                Image.asset('assets/logo.webp'),
                SizedBox(width: 20,),
                Text(
                  "VIDHYATRA", // App name on the left
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: (){}, // Notification icon action
                    icon: Icon(Icons.notifications, color:  Color(0xFF042F6B)),
                  ),
                ),
                SizedBox(width: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: (){}, // Profile icon action
                    icon: Icon(Icons.logout, color: Color(0xFF042F6B),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
