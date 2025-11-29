import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

import '../constants/app_themes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true; // default ON

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: AppThemes.appBarTextColor,
          ),
        ),
        backgroundColor: AppThemes.appBarColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppThemes.darkMaroon),
            title: Text(
              'Change Password',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.toNamed('/changePassword');
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: AppThemes.darkMaroon,
            ),
            title: Text(
              'Notification',
              style: GoogleFonts.poppins(),
            ),
            trailing: Switch(
              value: isNotificationOn,
              activeColor: AppThemes.darkMaroon,
              onChanged: (value) {
                setState(() {
                  isNotificationOn = value;
                });

                if (isNotificationOn) {
                  print("Notifications Enabled");
                } else {
                  print("Notifications Disabled");
                }
              },
            ),
            onTap: () {
              setState(() {
                isNotificationOn = !isNotificationOn;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: AppThemes.darkMaroon),
            title: Text(
              'Log out',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.defaultDialog(
                title: 'Logout',
                content: Text('Are you sure you want to logout?'),
                confirm: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.red, // Yes button color
                  ),
                  onPressed: () {
                    // Get.back(); // Close the dialog
                    loginController.logout();
                  },
                  child:
                  Text('Yes', style: TextStyle(color: AppThemes.darkMaroon)),
                ),
                cancel: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.darkMaroon, // No button color
                  ),
                  onPressed: () {
                    Get.back(); // Just close the dialog
                  },
                  child: Text('No', style: TextStyle(color: AppThemes.white)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
