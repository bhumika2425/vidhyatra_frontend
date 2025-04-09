import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final imageHeight = screenHeight * 0.3; // Slightly reduced for better balance

    return Scaffold(
      backgroundColor: Colors.grey[200], // Updated background color
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF186CAC), // Match dashboard's AppBar color
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Get.to(() => StudentProfileUpdatePage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF186CAC)),
          );
        }
        if (profileController.profile.value != null) {
          final profile = profileController.profile.value!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header - MODIFIED to remove gradient
                Stack(
                  children: [
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: profile.profileImageUrl != null
                              ? NetworkImage(profile.profileImageUrl!)
                              : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: imageHeight,
                      // Removed the gradient here
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullname ?? 'John Doe',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF186CAC),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              profile.department ?? 'Computer Science',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Profile Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bio Section
                      _buildSectionTitle('Bio'),
                      _buildInfoCard([
                        Text(
                          profile.bio ?? 'Describe Yourself',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey[800],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Personal Details Section
                      _buildSectionTitle('Personal Details'),
                      _buildInfoCard([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildInfoRow(
                                FontAwesomeIcons.calendar,
                                'Date of Birth',
                                profile.dateOfBirth != null
                                    ? DateFormat('yyyy-MM-dd')
                                    .format(profile.dateOfBirth!)
                                    : '1998-05-15',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoRow(
                                FontAwesomeIcons.mapMarkerAlt,
                                'Location',
                                profile.location ?? 'New York, USA',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildInfoRow(
                                FontAwesomeIcons.graduationCap,
                                'Year',
                                profile.year ?? '3rd Year',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoRow(
                                FontAwesomeIcons.book,
                                'Semester',
                                profile.semester ?? '6th Semester',
                              ),
                            ),
                          ],
                        ),
                      ]),

                      const SizedBox(height: 20),

                      // Interests Section - MODIFIED to remove chips
                      _buildSectionTitle('Interests'),
                      _buildInfoCard([
                        profile.interest != null
                            ? Text(
                          profile.interest!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        )
                            : Text(
                          'Let others know you',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
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
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Use primary blue for section titles
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 20,
            color: const Color(0xFF186CAC), // Use primary blue for icons
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Removed the _buildInterestChip method as it's no longer needed
}