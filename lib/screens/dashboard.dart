import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/controllers/IconController.dart';
import 'package:vidhyatra_flutter/controllers/blogController.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';
import '../models/blogModel.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isDarkMode = false; // Track the current theme mode
  final IconController iconController = Get.put(IconController());
  final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    // Access the token from the UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;
    blogController.fetchBlogs(token!);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Set Drawer icon color to white
        ),
        backgroundColor: Color(0xFF971F20),
        title: Text("Vidhyatra", style: TextStyle(color: Colors.white)),
        actions: [
          SizedBox(width: 10),
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);

              // Send request to check if the profile exists
              final response = await http.get(
                Uri.parse('http://10.0.2.2:3001/api/profile/exists'),
                headers: {
                  'Authorization': 'Bearer ${userProvider.token}',
                },
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
                        title: Text('Create Profile'),
                        content: Text(
                            'You have not created a profile yet. Would you like to create one now?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Create Profile'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileCreationPage()),
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
              backgroundImage: profile != null &&
                      profile.profileImageUrl != null
                  ? NetworkImage(profile.profileImageUrl!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
              backgroundColor: Colors.grey.shade200,
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Drawer Items
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Payment history'),
              onTap: () {
                Navigator.pushNamed(context, '/paymentHistory');
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Groups'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/groups');
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/friends');
              },
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.dark_mode),
                ),
                Text('Dark mode'),
                SizedBox(width: 10),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    if (isDarkMode) {
                      Get.changeTheme(ThemeData.dark());
                    } else {
                      Get.changeTheme(ThemeData.light());
                    }
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await Future.delayed(Duration(seconds: 1));
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Timeline Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Today's Timeline",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTimelineCard(
                      "04-4:30PM",
                      "Room Rara",
                      "CS1234 - Artificial Intelligence",
                      "ONGOING CLASS",
                      Colors.green),
                  _buildTimelineCard("04:40-5:00PM", "Room Everest",
                      "CS2345 - Data Science", "UPCOMING CLASS", Colors.orange),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Latest Blogs Section with grey background
            Container(
              color: Colors.grey[200], // Light grey background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Latest Blogs",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(() {
                    if (blogController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final blogs = blogController.blogs.value;

                    if (blogs == null || blogs.isEmpty) {
                      return Center(child: Text("No blogs available"));
                    }

                    // Reverse the list of blogs to display the most recent one at the top
                    final reversedBlogs = blogs.reversed.toList();

                    // Display the list of blogs
                    return ListView.builder(
                      shrinkWrap: true,
                      // Prevents infinite height issues
                      physics: NeverScrollableScrollPhysics(),
                      // Prevents nested scrolling
                      itemCount: reversedBlogs.length,
                      itemBuilder: (context, index) {
                        final blog = reversedBlogs[index];
                        return _buildBlogCard(blog);
                      },
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.offAllNamed('/dashboard');
                }),
            IconButton(
                icon: Icon(Icons.payment),
                onPressed: () {
                  Get.toNamed('/payment');
                }),
            SizedBox(width: 40), // Space for FAB
            IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  Get.toNamed('/calendar');
                }),
            IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Get.toNamed('/messages');
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/new-post');
        },
        backgroundColor: Color(0xFF971F20),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTimelineCard(String time, String location, String course,
      String status, Color statusColor) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.time, // Time icon from CupertinoIcons
                  size: 15, // Adjust the size here (default is 24.0)
                  color: Colors.grey, // Adjust the color here
                ),
                SizedBox(
                  width: 5,
                ),
                Text(time, style: TextStyle(color: Colors.grey)),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.room_outlined, // Time icon from CupertinoIcons
                  size: 15, // Adjust the size here (default is 24.0)
                  color: Colors.grey, // Adjust the color here
                ),
                SizedBox(
                  width: 5,
                ),
                Text(location, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(course, style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 5,
            ),
            Text(status, style: TextStyle(color: statusColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard(Blog blog) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0, // Size of the avatar
                  backgroundImage: NetworkImage('https://www.example.com/default-avatar.png'), // Replace with user's profile image
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anonymous', // Fallback if the username is null
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      'created at: 2024/10/12', // Fallback if the username is null
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // Blog Description
            Text(
              blog.blogDescription,
              style: TextStyle(fontSize: 16,),
            ),
            SizedBox(height: 8.0),

            // Blog Images
            if (blog.imageUrls.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: blog.imageUrls.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        imageUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),

            SizedBox(height: 8.0),

            // Blog Author
            Text(
              "Author ID: ${blog.userId}",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            // Add Comment and Share buttons at the bottom
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle comment action
                        print("like clicked");
                        // You can navigate to the comment section or open a modal for commenting
                      },
                      child: Icon(Icons.thumb_up_off_alt_outlined, color: Colors.grey[600],),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle comment action
                        print("Comment clicked");
                        // You can navigate to the comment section or open a modal for commenting
                      },
                      child: Icon(Icons.comment, color: Colors.grey[600],),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle share action
                    print("Share clicked");
                    // You can implement the sharing logic here
                  },
                  child: Icon(Icons.share, color: Colors.grey[600],),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
