import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/screens/TeacherAppointment.dart';
import 'package:vidhyatra_flutter/screens/Calendar.dart';
import 'package:vidhyatra_flutter/screens/DashboardTabs.dart';
import 'package:vidhyatra_flutter/screens/TeacherDeadlinePosting.dart';
import 'package:vidhyatra_flutter/screens/login.dart';
import '../controllers/tryController.dart';
import '../controllers/BlogController.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'blog_posting_page.dart';

class DashboardView extends GetView<DashboardController> {
  final DashboardController controller = Get.put(DashboardController());
  final BlogController blogController = Get.put(BlogController());
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Welcome, ${loginController.user.value?.name}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF186CAC),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.snackbar('Notifications', 'Coming soon!',
                  backgroundColor: Colors.deepOrange.withOpacity(0.9),
                  colorText: Colors.white);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.04),
              child: DashboardTabs(
                homeTabContent: _buildFeaturesGrid(context, constraints),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => BlogPostPage()), // Updated navigation
        backgroundColor: Color(0xFF186CAC),
        child: Icon(Icons.edit, color: Colors.white),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, BoxConstraints constraints) {
    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: constraints.maxWidth * 0.04,
      mainAxisSpacing: constraints.maxHeight * 0.03,
      childAspectRatio: constraints.maxWidth / (constraints.maxHeight * 0.65),
      children: [
        _buildFeatureCard(
          context,
          'Appointments',
          Icons.calendar_today,
          Color(0xFF186CAC),
              () => Get.to(() => TeacherAppointment()),
          'Set appointment slots for students',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Calendar',
          Icons.event,
          Colors.deepOrange,
              () => Get.to(() => Calendar()),
          'View your schedule and events',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Messages',
          Icons.message,
          Color(0xFF186CAC),
              () => Get.to(() => Calendar()), // Update to appropriate page later
          'Chat with students and colleagues',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Deadlines',
          Icons.assignment_late,
          Colors.deepOrange,
              () => Get.to(() => DeadlineHomePage()), // Update to appropriate page later
          'Manage assignment deadlines',
          constraints,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      String description,
      BoxConstraints constraints) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, color.withOpacity(0.1)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(constraints.maxWidth * 0.03),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: constraints.maxWidth * 0.12,
                  color: color,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: constraints.maxWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: constraints.maxWidth * 0.035,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Open',
                    style: GoogleFonts.poppins(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: constraints.maxWidth * 0.035,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: constraints.maxWidth * 0.04,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF186CAC),
                      Color(0xFF186CAC).withOpacity(0.8)
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: constraints.maxWidth * 0.12,
                      backgroundImage:
                      const AssetImage('assets/images/teacher_avatar.png'),
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.015),
                    Obx(() => Text(
                      loginController.user.value!.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: constraints.maxWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    Obx(() => Text(
                      loginController.user.value!.email,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: constraints.maxWidth * 0.045,
                      ),
                    )),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.person, 'My Profile', Color(0xFF186CAC),
                      () => Get.back()),
              _buildDrawerItem(Icons.settings, 'Account Settings',
                  Color(0xFF186CAC), () => Get.back()),
              _buildDrawerItem(Icons.people, 'Friends', Color(0xFF186CAC),
                      () => _showFriendsDialog(context)),
              Divider(color: Colors.grey[300]),
              _buildDrawerItem(Icons.help_outline, 'Help & Support',
                  Color(0xFF186CAC), () => Get.back()),
              _buildDrawerItem(Icons.logout, 'Logout', Colors.deepOrange, () {
                  Navigator.pop(context);
                  Get.defaultDialog(
                    title: 'Logout',
                    content: Text('Are you sure you want to logout?'),
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      // First close the dialog, then logout
                      Get.back();
                      loginController.logout();
                    },
                  );
              }),
            ],
          );
        },
      ),
    );
  }



  Widget _buildDrawerItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
      onTap: onTap,
    );
  }

  void _showFriendsDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Friends',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 16),
              Text('Pending Requests',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              SizedBox(height: 8),
              _buildFriendRequestTile('Jane Doe', 'Student', true),
              _buildFriendRequestTile('Prof. Smith', 'Teacher', true),
              SizedBox(height: 16),
              Text('Send Friend Request',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              SizedBox(height: 8),
              _buildFriendRequestTile('Emma Lee', 'Student', false),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Close',
                    style: GoogleFonts.poppins(color: Color(0xFF186CAC))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestTile(
      String name, String role, bool isRequestReceived) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF186CAC),
              child: Text(name[0],
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  Text(role,
                      style: GoogleFonts.poppins(color: Colors.grey[700])),
                ],
              ),
            ),
            if (isRequestReceived) ...[
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  Get.snackbar('Friend Request', 'Accepted $name',
                      backgroundColor: Color(0xFF186CAC),
                      colorText: Colors.white);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Get.snackbar('Friend Request', 'Rejected $name',
                      backgroundColor: Colors.deepOrange,
                      colorText: Colors.white);
                },
              ),
            ] else
              ElevatedButton(
                onPressed: () {
                  Get.snackbar('Friend Request', 'Sent to $name',
                      backgroundColor: Color(0xFF186CAC),
                      colorText: Colors.white);
                },
                child: Text('Send',
                    style: GoogleFonts.poppins(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 16)),
              ),
          ],
        ),
      ),
    );
  }
}
