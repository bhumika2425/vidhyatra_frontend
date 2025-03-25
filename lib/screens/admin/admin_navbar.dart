import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/screens/admin/ManageRoutine.dart';
import 'package:vidhyatra_flutter/screens/admin/admin_dashboard.dart';
import 'package:vidhyatra_flutter/screens/admin/admin_students/view/admin_students_page.dart';
import 'package:vidhyatra_flutter/screens/admin/event_management/view/event_management.dart';
import 'package:vidhyatra_flutter/screens/admin/fees_page/view/fees_page.dart';
import 'package:vidhyatra_flutter/screens/admin/professors_page/view/professor_page.dart';
// import 'package:vidhyatra_flutter/screens/admin/event_management.dart';

class AdminNavBar extends StatelessWidget {
  final Function(int) onTap; // Callback function for navigation

  const AdminNavBar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Color(0xFF053985),
        border: Border(
          top: BorderSide(
            color: Colors.white,  // You can change the color
            width: 3,            // You can set the width of the border
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _buildNavItem(Icons.dashboard, "Dashboard", 0),
                _buildNavItem(Icons.event, "Manage Events", 1),
                _buildNavItem(Icons.feedback, "User Feedback", 2),
                _buildNavItem(Icons.account_box_rounded, "Professors", 3),
                _buildNavItem(Icons.supervisor_account_rounded, "Students", 4),
                _buildNavItem(Icons.money, "Fees", 5),
                _buildNavItem(Icons.schedule_outlined, "Manage Routine", 6),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50)
                  ),
                ),
                SizedBox(width: 15),
                Text('Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return InkWell(
      onTap: () {
        onTap(index); // Call the onTap callback
        _navigateToPage(index); // Navigate to the respective page
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 15),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.to(() => AdminDashboard()); // Navigate to Dashboard page
        break;
      case 1:
        Get.to(() => ManageEvent()); // Navigate to Event Management page
        break;
      case 2:
        // Get.to(() => FeedbackPage()); // Navigate to Feedback page
        break;
      case 3:
        Get.to(() => ProfessorsPage()); // Navigate to Professors page
        break;
      case 4:
        Get.to(() => AdminStudentsPage()); // Navigate to Students page
        break;
      // case 5:
      //   Get.to(() => FeesPage()); // Navigate to Fees page
      //   break;
      case 6:
      Get.to(() => ManageRoutine()); // Navigate to Manage routine page
        break;
      default:
        // Get.to(() => DashboardPage()); // Default fallback to Dashboard
    }
  }
}
