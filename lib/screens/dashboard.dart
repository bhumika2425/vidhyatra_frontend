import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/blogController.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';
import '../models/blogModel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    blogController.fetchBlogs();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Vidhyatra",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
        ),
        actions: [
          SizedBox(width: 10),
          Icon(Icons.notifications),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              final token = Get.find<LoginController>().token.value;
              final response = await http.get(
                Uri.parse(ApiEndPoints.checkIfProfileExist),
                headers: {'Authorization': 'Bearer $token'},
              );

              if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                if (data['exists']) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Create Profile', style: GoogleFonts.poppins()),
                        content: Text(
                          'You have not created a profile yet. Would you like to create one now?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel', style: GoogleFonts.poppins()),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text('Create Profile', style: GoogleFonts.poppins()),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileCreationPage()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                print('Error checking profile existence');
              }
            },
            child: CircleAvatar(
              backgroundImage: profileController.profile.value != null &&
                  profileController.profile.value!.profileImageUrl != null
                  ? NetworkImage(profileController.profile.value!.profileImageUrl!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
              backgroundColor: Colors.grey.shade400,
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                'Navigation',
                style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Account', style: GoogleFonts.poppins()),
              onTap: () => Get.toNamed('/account'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends', style: GoogleFonts.poppins()),
              onTap: () => Get.toNamed('/friends'),
            ),
            ListTile(
              leading: Icon(Icons.book_online),
              title: Text('Assignments', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pushNamed(context, '/assignments'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: GoogleFonts.poppins()),
              onTap: () => Get.toNamed("/studentSetting"),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Timeline Section (Non-scrollable)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Today's Timeline",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTimelineCard("04-4:30PM", "Room Rara", "CS1234 - Artificial Intelligence",
                    "ONGOING CLASS", Colors.green),
                _buildTimelineCard("04:40-5:00PM", "Room Everest", "CS2345 - Data Science",
                    "UPCOMING CLASS", Colors.orange),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Latest Blogs Section (Scrollable)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Latest Blogs",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (blogController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final blogs = blogController.blogs.value;

                    if (blogs == null || blogs.isEmpty) {
                      return Center(
                        child: Text("No blogs available", style: GoogleFonts.poppins()),
                      );
                    }

                    final reversedBlogs = blogs.reversed.toList();

                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reversedBlogs.length,
                        itemBuilder: (context, index) {
                          final blog = reversedBlogs[index];
                          return _buildBlogCard(blog);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: SizedBox(
          height: 70,
          child: BottomAppBar(
            color: Colors.grey[200],
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(Icons.schedule_outlined), onPressed: () => Get.toNamed('/classSchedule')),
                IconButton(icon: Icon(Icons.payment), onPressed: () => Get.toNamed('/feesScreen')),
                SizedBox(width: 40),
                IconButton(icon: Icon(Icons.calendar_month), onPressed: () => Get.toNamed('/calendar')),
                IconButton(icon: Icon(Icons.chat), onPressed: () => Get.toNamed('/messages')),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/new-post'),
        backgroundColor: Color(0xFF186CAC),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTimelineCard(String time, String location, String course, String status, Color statusColor) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF186CAC), Color(0xFF186CAC)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.time, size: 15, color: Colors.white),
                  SizedBox(width: 5),
                  Text(time, style: GoogleFonts.poppins(color: Colors.white)),
                  SizedBox(width: 15),
                  Icon(Icons.room_outlined, size: 15, color: Colors.white),
                  SizedBox(width: 5),
                  Text(location, style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
              SizedBox(height: 5),
              Text(course, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              SizedBox(height: 5),
              Text(status, style: GoogleFonts.poppins(color: statusColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard(Blog blog) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: blog.profileImage.isNotEmpty
                      ? NetworkImage(blog.profileImage)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(blog.fullName,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text(blog.createdAt,
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12.0)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(blog.blogDescription, style: GoogleFonts.poppins(fontSize: 15)),
            SizedBox(height: 8.0),
            if (blog.imageUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.imageUrls.take(2).map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: EdgeInsets.zero,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Hero(
                                          tag: imageUrl,
                                          child: Image.network(imageUrl, fit: BoxFit.contain),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: IconButton(
                                          icon: Icon(Icons.close, color: Colors.white, size: 30),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Hero(
                              tag: imageUrl,
                              child: Image.network(imageUrl, height: 150, width: 150, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (blog.imageUrls.length > 2)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("All Images",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                        ),
                                        itemCount: blog.imageUrls.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black,
                                                    insetPadding: EdgeInsets.zero,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Hero(
                                                            tag: blog.imageUrls[index],
                                                            child: Image.network(
                                                                blog.imageUrls[index], fit: BoxFit.contain),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 20,
                                                          right: 20,
                                                          child: IconButton(
                                                            icon: Icon(Icons.close,
                                                                color: Colors.white, size: 30),
                                                            onPressed: () =>
                                                                Navigator.of(context).pop(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Hero(
                                                tag: blog.imageUrls[index],
                                                child: Image.network(blog.imageUrls[index], fit: BoxFit.cover),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("+${blog.imageUrls.length - 2} more images",
                          style: GoogleFonts.poppins()),
                    ),
                ],
              ),
            SizedBox(height: 8.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => print("like clicked"),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.thumb_up_off_alt_outlined, color: Colors.grey[600], size: 25),
                          SizedBox(width: 5),
                          Text(blog.likes.toString(),
                              style: GoogleFonts.poppins(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => print("Comment clicked"),
                      child: Icon(Icons.comment, color: Colors.grey[600], size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}