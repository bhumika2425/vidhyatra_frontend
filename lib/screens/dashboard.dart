import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/controllers/IconController.dart';
import 'package:vidhyatra_flutter/screens/profile_creation.dart';

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

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.token != null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .fetchProfileData(userProvider.token!);
    }
  }


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Set Drawer icon color to white
        ),
        backgroundColor: Color(0xFFE41F1F),
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
                  // Assuming token stored in provider
                },
              );

              if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                if (data['exists']) {
                  Navigator.pushNamed(context,
                      '/profile'); // Navigate to profile page if it exists
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
                              Navigator.of(context).pop(); // Close dialog
                            },
                          ),
                          TextButton(
                            child: Text('Create Profile'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
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
                // Handle error (optional)
                print('Error checking profile existence');
              }
            },
            child: CircleAvatar(
              backgroundImage: profile != null &&
                      profile.profileImageUrl != null
                  ? NetworkImage(profile.profileImageUrl!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
              // Fallback image
              backgroundColor:
                  Colors.grey.shade200, // Background color if no image
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
              // Move text to the right by 20px
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
                // Add your navigation logic here
                Navigator.pushNamed(context, '/paymentHistory');
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Groups'), // Friends icon
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/groups'); // Update with the correct route
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'), // Groups icon
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/friends'); // Update with the correct route
              },
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.dark_mode),
                ),
                Text('Dark mode'),
                SizedBox(
                  width: 10,
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value; // Update the toggle state
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
                // Example logout logic
                await Future.delayed(Duration(seconds: 1));
                Get.offAllNamed('/login'); // Navigate back to login page
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(
              height: 20,
            ),
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
                  _buildBlogCard(
                      "Username2",
                      "Blog 2",
                      "Artificial Intelligence (AI) is transforming education, from personalized learning experiences to automated grading systems. This blog explores how AI is reshaping classrooms, enhancing student engagement, and helping educators focus more on teaching by automating administrative tasks. Dive into the possibilities of AI-powered tools and their impact on the future of learning.",
                      "2024/02/02"),
                ],
              ),
            ),
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
                  Get.offAllNamed('/dashboard'); // Navigate to Dashboard
                }),
            IconButton(
                icon: Icon(Icons.payment),
                onPressed: () {
                  Get.toNamed('/payment'); // Navigate to Payments page
                }),
            SizedBox(width: 40), // Space for FAB
            IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  Get.toNamed('/calendar'); // Navigate to Calendar page
                }),
            IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Get.toNamed('/messages'); // Navigate to Chat page
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/new-post');
        },
        backgroundColor: Color(0xFFE41F1F),
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

  Widget _buildBlogCard(
      String username, String title, String description, String date) {
    final IconController iconColorController = Get.put(IconController());

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(date, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(description),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: iconColorController.isRed.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: iconColorController.toggleColor,
                  ),
                ),
                IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
