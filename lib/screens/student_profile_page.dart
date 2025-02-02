import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vidhyatra_flutter/screens/student_profile_update.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';

class StudentProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the ProfileController instance
    final ProfileController profileController = Get.put(ProfileController());

    // Assuming token is fetched from the user provider or storage
    final token = Get.find<LoginController>().token.value;   // Replace this with the actual token

    // Fetch the profile data on page load
    profileController.fetchProfileData(token);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Obx(() {
        // Reactive UI: The body updates when `isLoading` or `profile` changes
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (profileController.profile.value != null) {
          final profile = profileController.profile.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: profile.profileImageUrl != null
                          ? NetworkImage(profile.profileImageUrl!)
                          : AssetImage('assets/default_profile.png')
                      as ImageProvider,
                    ),
                    SizedBox(height: 20),
                    Text(
                      profile.fullname ?? 'N/A',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Edit Profile Button
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ),
                          onPressed: () {
                            // Navigate to update profile page
                            // Get.to(() => StudentProfileUpdate());
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Edit Profile',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        // Share Profile Button
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ),
                          onPressed: () {
                            // Implement share profile functionality
                            _shareProfile();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.share, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Share Profile',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ProfileDetailRow(
                          icon: FontAwesomeIcons.calendarAlt,
                          label: 'Date of Birth',
                          value: profile.dateOfBirth != null
                              ? profile.dateOfBirth!.toLocal().toString().split(' ')[0]
                              : 'N/A',
                        ),
                        ProfileDetailRow(
                          icon: FontAwesomeIcons.mapMarkerAlt,
                          label: 'Location',
                          value: profile.location ?? 'N/A',
                        ),
                        ProfileDetailRow(
                          icon: FontAwesomeIcons.graduationCap,
                          label: 'Department',
                          value: profile.department ?? 'N/A',
                        ),
                        ProfileDetailRow(
                          icon: FontAwesomeIcons.timeline,
                          label: 'Year',
                          value: profile.year ?? 'N/A',
                        ),
                        ProfileDetailRow(
                          icon: FontAwesomeIcons.graduationCap,
                          label: 'Semester',
                          value: profile.semester ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        } else {
          return Center(child: Text('Profile not found'));
        }
      }),
    );
  }

  void _shareProfile() {
    // You can use a package like 'share' to share the profile data.
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Share Profile"),
          content: Text("Profile shared successfully!"),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF971F20)),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
