import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vidhyatra_flutter/screens/student_profile_update.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';

class StudentProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final token = Get.find<LoginController>().token.value;
    profileController.fetchProfileData(token);
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.35;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }
        if (profileController.profile.value != null) {
          final profile = profileController.profile.value!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: profile.profileImageUrl != null
                          ? NetworkImage(profile.profileImageUrl!)
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullname ?? 'John Doe',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            profile.department ?? 'Computer Science',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Profile Content
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Details Section
                      _buildSectionTitle('Personal Details'),
                      _buildInfoCard([
                        _buildInfoRow(FontAwesomeIcons.calendar, 'Date of Birth',
                            profile.dateOfBirth?.toString() ?? '1998-05-15'),
                        _buildInfoRow(FontAwesomeIcons.mapMarkerAlt, 'Location',
                            profile.location ?? 'New York, USA'),
                        _buildInfoRow(FontAwesomeIcons.university, 'Department',
                            profile.department ?? 'Computer Science'),
                        _buildInfoRow(FontAwesomeIcons.graduationCap, 'Year',
                            profile.year ?? '3rd Year'),
                        _buildInfoRow(FontAwesomeIcons.book, 'Semester',
                            profile.semester ?? '6th Semester'),
                      ]),

                      SizedBox(height: 20),

                      // Bio Section
                      _buildSectionTitle('Bio'),
                      _buildInfoCard([
                        Text(
                          'A passionate computer science student with a keen interest in developing innovative solutions. Always eager to learn and explore new technologies.',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ]),

                      SizedBox(height: 20),

                      // Interests Section
                      _buildSectionTitle('Interests'),
                      _buildInfoCard([
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildInterestChip('Machine Learning'),
                            _buildInterestChip('Web Development'),
                            _buildInterestChip('Mobile Apps'),
                            _buildInterestChip('Artificial Intelligence'),
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              'Profile not found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    return Chip(
      label: Text(
        interest,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }
}