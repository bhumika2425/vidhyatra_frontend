//Dashboard
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/AdminController.dart';
import 'admin_navbar.dart';
import 'admin_top_narbar.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminDashboardController controller =
      Get.put(AdminDashboardController());
  int selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Height of the top navbar
        child: AdminTopNavBar(),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Row(
          children: [
            AdminNavBar(onTap: _onNavItemSelected),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                child: _buildDashboardContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // First container with fixed height
        Container(
          width: double.infinity,
          height: screenHeight / 3.45, // 1/3 of the screen height
          child: Row(
            children: [
              // First item covering 25% of the container
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      // First item in the column
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Students',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text('3025',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.grey[600]))
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Second item in the column
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Unpaid Fees',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text('101',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.grey[600]))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second item covering 25% of the container
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      // First item in the column
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Teachers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text('10',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.grey[600]))
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Second item in the column
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Posts/Notice',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text('7',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.grey[600]))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Third item covering 50% of the container
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                        child: Text('Students Graph',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Second container with fixed height
        Container(
          width: double.infinity,
          height: screenHeight / 3.45, // 1/3 of the screen height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Distribute items evenly within the Row
            children: [
              // First item - 50% width of the container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    color: Colors.red,
                    child: Center(
                        child: Text('Teacher\'s list',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
              // Second item - 50% width of the container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    color: Colors.green,
                    child: Center(
                        child: Text('Student\'s list',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Third container with fixed height
        Container(
          width: double.infinity,
          height: screenHeight / 3.1, // 1/3 of the screen height
          color: Colors.grey[400],
          child: Column(
            children: [
              Container(
                height: 30, // Set the height as per your requirement
                color: Colors.blue[900], // Dark blue color (use Color(0xFF053985) for your specific dark blue shade)
                child: Center(
                  child: Text(
                    'Monthly Calendar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
