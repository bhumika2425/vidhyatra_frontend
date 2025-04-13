import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/screens/TeacherAppointment.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
import '../controllers/tryController.dart';
import '../controllers/BlogController.dart'; // Import BlogController
import 'package:timeago/timeago.dart' as timeago;

class DashboardView extends GetView<DashboardController> {
  final DashboardController controller = Get.put(DashboardController());
  final BlogController blogController =
      Get.put(BlogController()); // Add BlogController
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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
              child: _buildTabsSection(context, constraints),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context, BoxConstraints constraints) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: constraints.maxWidth * 0.04),
              unselectedLabelStyle:
                  GoogleFonts.poppins(fontSize: constraints.maxWidth * 0.035),
              labelColor: Color(0xFF186CAC),
              unselectedLabelColor: Colors.grey[700],
              indicatorColor: Colors.deepOrange,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'Social'),
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.02),
          Container(
            height: constraints.maxHeight * 0.9, // Adjust height as needed
            child: TabBarView(
              children: [
                // Home Tab Content
                _buildFeaturesGrid(context, constraints),

                // Social Tab Content
                _buildBlogsList(context, constraints),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogsList(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      if (blogController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFF186CAC),
          ),
        );
      } else if (blogController.blogs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No blogs available',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => blogController.fetchBlogs(),
                icon: Icon(Icons.refresh),
                label: Text('Refresh', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF186CAC),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return ListView.builder(
          itemCount: blogController.blogs.length,
          padding: EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final blog = blogController.blogs[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF186CAC),
                      child: blog.profileImage != null &&
                              blog.profileImage.isNotEmpty
                          ? Image.network(
                              blog.profileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person, // Fallback icon
                                  color: Colors.white,
                                  size: 24,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                  color: Colors.white,
                                );
                              },
                            )
                          : Icon(
                              Icons.person, // Default if no image URL
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                    title: Text(
                      blog.fullName ?? 'Unknown User',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      timeago.format(blog.createdAt),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // Options menu
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      blog.blogDescription ?? 'No description',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                  if (blog.imageUrls != null && blog.imageUrls!.isNotEmpty)
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: blog.imageUrls!.length,
                        itemBuilder: (context, imgIndex) {
                          return Container(
                            width: 300,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(blog.imageUrls![imgIndex]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.thumb_up_outlined, color: Colors.grey[700]),
                          label: Text(
                            'Like',
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                          ),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.comment_outlined, color: Colors.grey[700]),
                          label: Text(
                            'Comment',
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                          ),
                          onPressed: () {},
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
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
          () => Get.to(() => Calendar()),
          'Chat with students and colleagues',
          constraints,
        ),
        _buildFeatureCard(
          context,
          'Deadlines',
          Icons.assignment_late,
          Colors.deepOrange,
          () => Get.to(() => Calendar()),
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
                Get.dialog(
                  AlertDialog(
                    title: Text('Logout',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    content: Text('Are you sure you want to logout?',
                        style: GoogleFonts.poppins()),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel',
                            style:
                                GoogleFonts.poppins(color: Color(0xFF186CAC))),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          // controller.logout();
                        },
                        child: Text('Logout',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
                      ),
                    ],
                  ),
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
              // Friend Requests Section
              Text('Pending Requests',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              SizedBox(height: 8),
              _buildFriendRequestTile('Jane Doe', 'Student', true),
              _buildFriendRequestTile('Prof. Smith', 'Teacher', true),
              SizedBox(height: 16),
              // Send Friend Request Section
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
