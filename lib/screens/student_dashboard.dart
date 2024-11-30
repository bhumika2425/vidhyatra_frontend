import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/screens/profile_creation.dart';
import '../models/blogModel.dart';
import '../providers/user_provider.dart';
import 'blog_posting_page.dart';
import 'login.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0; // Track the selected tab
  bool _isLoading = false;
  List<Blog> _blogs = []; // List to store blogs

  @override
  void initState() {
    super.initState();
    _fetchBlogs(); // Fetch blogs when the screen loads
  }

  // Function to fetch blogs
  Future<void> _fetchBlogs() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save profile: Missing token')),
      );
      return;
    }

    try {
      // Standard JSON request if no image
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/api/blog/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Log the status code and body for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> blogData =
            jsonDecode(response.body); // Decode the JSON response
        setState(() {
          _blogs = blogData.map((data) => Blog.fromJson(data)).toList();
          _isLoading = false;
        });
      } else {
        // Print the error status and response body for non-200 responses
        print('Failed to load blogs. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Print full error for debugging
      print('Error fetching blogs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              // Move text to the right by 20px
              child: Text(
                '${user?.name}',
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
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () async {
                Navigator.pop(context);
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
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                // Call the logout function
                await _logout(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          '${user?.name}', // Update greeting with fetched name
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message), // Message icon added
            onPressed: () {
              // Handle message button press
              Navigator.pushNamed(context,
                  '/messages'); // Update with the correct route for messages
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Notifications'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text('Exam Schedule Released'),
                            subtitle: Text('Check the updated exam timetable.'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.library_books),
                            title: Text('Library Books Due'),
                            subtitle: Text('Return borrowed books by Oct 25.'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.payment),
                            title: Text('Fee Payment Due'),
                            subtitle: Text(
                                'Final installment for this semester due Oct 30.'),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Logo, Name, and Location
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/college_logo.png',
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Informatics College Pokhara',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Matepani-12, Pokhara',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Text(
              'Latest Blogs',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Inside the _StudentDashboardState class, within the ListView.builder widget
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _blogs.isEmpty
                    ? Center(child: Text('No blogs available.'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _blogs.length,
                        itemBuilder: (context, index) {
                          final blog = _blogs[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Picture and Blog Poster Name (Similar to Instagram)
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20, // Profile picture size
                                        backgroundImage: NetworkImage('https://static.wikia.nocookie.net/p__/images/7/7e/Marina_design_2-3_season.png/revision/latest?cb=20200331060209&path-prefix=protagonist'), // Sample profile picture
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Sample Name', // Sample blog poster name
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8), // Space between profile and blog content

                                  SizedBox(height: 8),
                                  // Space between profile and blog content

                                  // Blog Title and Description
                                  Text(
                                    blog.blogTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    blog.blogDescription,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 16),
                                  // Space between description and buttons

                                  // Like, Comment, and Share Icons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.thumb_up),
                                        onPressed: () {
                                          // Handle Like action
                                          print('Liked the blog');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          // Handle Comment action
                                          print('Commented on the blog');
                                          // You can open a dialog or navigate to a comments page here
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () {
                                          // Handle Share action
                                          print('Shared the blog');
                                          // You can implement share functionality here
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/payment');
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BlogPostPage()), // Navigate to BlogPostPage
              );
              break;
            case 3:
              Navigator.pushNamed(context, '/calendar');
              break;
            case 4:
              Navigator.pushNamed(context, '/schedule');
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    // Show a confirmation dialog
    final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Logout'),
              content: Text('Are you sure you want to log out?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Dismiss the dialog
                  },
                ),
                TextButton(
                  child: Text('Logout'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Proceed with logout
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    // Proceed with logout if confirmed
    if (shouldLogout == true) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.clear(); // Clear user data from SharedPreferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Navigate to Login screen
      );
    }
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }
}
