
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/screens/profile_creation.dart';


import '../providers/user_provider.dart';
import 'login.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
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
              margin: EdgeInsets.only(left: 20.0), // Move text to the right by 20px
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
                final userProvider = Provider.of<UserProvider>(context, listen: false);

                // Send request to check if the profile exists
                final response = await http.get(
                  Uri.parse('http://10.0.2.2:3001/api/profile/exists'),
                  headers: {
                    'Authorization': 'Bearer ${userProvider.token}', // Assuming token stored in provider
                  },
                );

                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  if (data['exists']) {
                    Navigator.pushNamed(context, '/profile'); // Navigate to profile page if it exists
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
                Navigator.pushNamed(context, '/groups'); // Update with the correct route
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'), // Groups icon
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/friends'); // Update with the correct route
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
              Navigator.pushNamed(context, '/messages'); // Update with the correct route for messages
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
                            subtitle: Text('Final installment for this semester due Oct 30.'),
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
            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  icon: Icons.payment,
                  label: 'Pay Fees',
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment');
                  },
                ),
                QuickActionButton(
                  icon: Icons.schedule,
                  label: 'Schedule',
                  onPressed: () {
                    Navigator.pushNamed(context, '/schedule');
                  },
                ),
                QuickActionButton(
                  icon: Icons.message,
                  label: 'Messages',
                  onPressed: () {
                    // Navigate to Messages Page
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuickActionButton(
                  icon: Icons.calendar_today,
                  label: 'Calendar',
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            // Upcoming Deadlines / Events
            Text(
              'Upcoming Deadlines/Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Assignment Deadline: Oct 20'),
                subtitle: Text('Submit your math assignment.'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.payment),
                title: Text('Fee Payment Due: Oct 30'),
                subtitle: Text('Final installment for this semester.'),
              ),
            ),
            SizedBox(height: 30),
            // Recent Notifications
            Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Exam Schedule Released'),
                subtitle: Text('Check the updated exam timetable.'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Library Books Due'),
                subtitle: Text('Return borrowed books by Oct 25.'),
              ),
            ),
          ],
        ),
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
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    );

    // If user confirmed, log out
    if (shouldLogout == true) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.clear(); // Clear user data from SharedPreferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to Login screen
      );
    }
  }
}

// Quick Action Button Widget
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  QuickActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 40,
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }
}