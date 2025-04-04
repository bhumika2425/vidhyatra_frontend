import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Accounts",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 23
            )
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.key_off),
            title: Text(
              "Change Password",
              style: GoogleFonts.poppins(), // Use Poppins font
            ),
            onTap: () {
              print('Navigating to Change Password');
              Get.toNamed("/changePassword");
            },
          ),
          ListTile(
            leading: Icon(Icons.feed_outlined),
            title: Text(
              "Send Feedback",
              style: GoogleFonts.poppins(), // Use Poppins font
            ),
            onTap: () {
              Get.toNamed("/sendFeedback");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Color(0xFF971F20),
            ),
            title: Text(
              "Delete Account",
              style: GoogleFonts.poppins(
                color: Color(0xFF971F20), // Use Poppins font
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Color(0xFF971F20),
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Color(0xFF971F20), // Use Poppins font
              ),
            ),
            onTap: () async {
              // Show a confirmation dialog
              bool? confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm Logout",
                      style: GoogleFonts.poppins(), // Use Poppins font
                    ),
                    content: Text(
                      "Are you sure you want to log out?",
                      style: GoogleFonts.poppins(), // Use Poppins font
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel logout
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(), // Use Poppins font
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirm logout
                        },
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(), // Use Poppins font
                        ),
                      ),
                    ],
                  );
                },
              );

              // Proceed with logout if user confirmed
              if (confirmLogout == true) {
                await Future.delayed(Duration(seconds: 1)); // Simulate a delay if needed
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
