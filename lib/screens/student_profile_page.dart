import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/screens/student_profile_update.dart';
import '../constants/app_themes.dart';
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
      backgroundColor: AppThemes.secondaryBackgroundColor, // Updated background color
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppThemes.appBarTextColor),
        title: Text(
          'Your Profile',
          style: GoogleFonts.poppins(
            // fontWeight: FontWeight.bold,
            fontSize: 19,
            color: AppThemes.appBarTextColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppThemes.appBarColor, // Match dashboard's AppBar color
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppThemes.appBarTextColor),
            onPressed: () {
              Get.to(() => StudentProfileUpdatePage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppThemes.darkMaroon),
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
                              profile.fullname.isNotEmpty ? profile.fullname : 'John Doe',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppThemes.darkMaroon,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  profile.department,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: AppThemes.darkMaroon,
                                  ),
                                ),
                              ],
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
                      _buildModernSectionTitle('About', Icons.person_outline),
                      _buildModernBioCard(profile.bio),
                      const SizedBox(height: 24),

                      // Academic Information Section
                      _buildModernSectionTitle('Academic Information', Icons.school_outlined),
                      _buildAcademicInfoCard(profile),
                      const SizedBox(height: 24),

                      // Personal Information Section
                      _buildModernSectionTitle('Personal Information', Icons.info_outline),
                      _buildPersonalInfoCard(profile),
                      const SizedBox(height: 24),

                      // Interests Section
                      _buildModernSectionTitle('Interests & Hobbies', Icons.favorite_outline),
                      _buildInterestsCard(profile.interest),
                      const SizedBox(height: 20),
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

  // Modern Section Title with Icon
  Widget _buildModernSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemes.darkMaroon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppThemes.darkMaroon,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppThemes.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // Modern Bio Card
  Widget _buildModernBioCard(String? bio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.lightGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkMaroon.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: bio != null && bio.isNotEmpty
          ? Text(
              bio,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.6,
                color: AppThemes.secondaryTextColor,
              ),
            )
          : Text(
              'Tell others about yourself...',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppThemes.hintTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }

  // Academic Information Card
  Widget _buildAcademicInfoCard(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.lightGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkMaroon.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernInfoItem(
                  Icons.badge_outlined,
                  'College ID',
                  profile.collegeId?.toString() ?? 'Not specified',
                ),
              ),

            ],
          ),
          const SizedBox(height: 16),
          _buildModernInfoItem(
            Icons.email_outlined,
            'College Email',
            profile.email ?? 'Not provided',
            isFullWidth: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernInfoItem(
                  Icons.calendar_today_outlined,
                  'Year',
                  profile.year ?? 'Not specified',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernInfoItem(
                  Icons.book_outlined,
                  'Semester',
                  profile.semester ?? 'Not specified',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernInfoItem(
                  Icons.group_outlined,
                  'Section',
                  profile.section ?? 'Not specified',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernInfoItem(
                  Icons.school_outlined,
                  'Department',
                  profile.department ?? 'Not specified',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Personal Information Card
  Widget _buildPersonalInfoCard(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.lightGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkMaroon.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernInfoItem(
                  Icons.phone_outlined,
                  'Phone',
                  profile.phoneNumber ?? 'Not provided',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernInfoItem(
                  Icons.cake_outlined,
                  'Birthday',
                  profile.dateOfBirth != null
                      ? DateFormat('MMM dd, yyyy').format(profile.dateOfBirth!)
                      : 'Not provided',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildModernInfoItem(
            Icons.location_on_outlined,
            'Location',
            profile.location ?? 'Not provided',
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  // Interests Card
  Widget _buildInterestsCard(String? interests) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.lightGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkMaroon.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: interests != null && interests.isNotEmpty
          ? Text(
              interests,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.6,
                color: AppThemes.secondaryTextColor,
              ),
            )
          : Text(
              'Share your interests and hobbies...',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppThemes.hintTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }

  // Modern Info Item
  Widget _buildModernInfoItem(
    IconData icon,
    String label,
    String value, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppThemes.darkMaroon,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppThemes.darkMaroon,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppThemes.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
