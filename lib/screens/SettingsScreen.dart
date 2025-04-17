import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.white, // assuming your app bar uses white text
          ),
        ),
        backgroundColor: const Color(0xFF186CAC),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Color(0xFF186CAC)),
            title: Text(
              'Change Password',
              style: GoogleFonts.poppins(),
            ),

            onTap: () {
              Get.toNamed('/changePassword');
              // Get.to(() => const ChangePasswordScreen());
            },
          ),
          // Add more settings items as needed
        ],
      ),
    );
  }
}
