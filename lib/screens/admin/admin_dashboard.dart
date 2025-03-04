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
  final AdminDashboardController controller = Get.put(
      AdminDashboardController());
  int selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNotificationTap() {
    // Handle notification tap
  }

  void _onProfileTap() {
    // Handle profile tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Height of the top navbar
        child: AdminTopNavBar(
          onNotificationTap: _onNotificationTap,
          onProfileTap: _onProfileTap,
        ),
      ),
      body: Row(
        children: [
          AdminNavBar(onTap: _onNavItemSelected),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildDashboardContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Obx(() =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                    "Total Users", controller.totalUsers.value.toString(),
                    Colors.blue),
                _buildStatCard(
                    "Total Events", controller.totalEvents.value.toString(),
                    Colors.green),
                _buildStatCard(
                    "Feedbacks", controller.totalFeedbacks.value.toString(),
                    Colors.orange),
              ],
            )),
        SizedBox(height: 30),
        Text("Recent Events",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Obx(() =>
            Column(
              children: controller.recentEvents
                  .map((event) =>
                  ListTile(
                    title: Text(event),
                    leading: Icon(Icons.event, color: Colors.blueGrey),
                  ))
                  .toList(),
            )),
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
          Text(value, style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

}
