import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/screens/AccountPage.dart';
import 'package:vidhyatra_flutter/screens/ChangePassword.dart';
import 'package:vidhyatra_flutter/screens/ClassRoutine.dart';
import 'package:vidhyatra_flutter/screens/FeesScreen.dart';
import 'package:vidhyatra_flutter/screens/FriendsScreen.dart';
import 'package:vidhyatra_flutter/screens/StudentSetting.dart';
import 'package:vidhyatra_flutter/screens/admin/admin_dashboard.dart';
import 'package:vidhyatra_flutter/screens/admin/event_management/controller/event_posting_controller.dart';
import 'package:vidhyatra_flutter/screens/admin/event_management/view/event_management.dart';
import 'package:vidhyatra_flutter/screens/blog_posting_page.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
import 'package:vidhyatra_flutter/screens/chat_page.dart';
import 'package:vidhyatra_flutter/screens/dashboard.dart';
import 'package:vidhyatra_flutter/screens/feedback_form.dart';
import 'package:vidhyatra_flutter/screens/forgot_password_page.dart';
import 'package:vidhyatra_flutter/screens/login.dart';
import 'package:vidhyatra_flutter/screens/register.dart';
import 'package:vidhyatra_flutter/screens/student_profile_page.dart';
import 'package:vidhyatra_flutter/screens/welcomePage.dart';
import 'controllers/LoginController.dart';
import 'controllers/ProfileController.dart';

void main() {
  Get.put(LoginController());
  Get.put(ProfileController()); // Ensures ProfileController is available globally
  Get.put(EventPostingController());

  runApp(VidhyatraApp());
}

class VidhyatraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vidhyatra Login',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Adjust the primary swatch if needed
        scaffoldBackgroundColor: Colors.white, // Set the scaffold background to white
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background to white
          iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
          titleTextStyle: TextStyle(
            color: Colors.black, // Set title text color to black
            fontSize: 20,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/profile', page: () => StudentProfilePage()),
        GetPage(name: '/calendar', page: () => Calendar()),
        GetPage(name: '/messages', page: () => ChatPage()),
        GetPage(name: '/student-dashboard', page: () => Dashboard()),
        GetPage(name: '/new-post', page: () => BlogPostPage()),
        GetPage(name: '/forgot_password', page: () => ForgotPasswordScreen()),
        GetPage(name: '/friends', page: () => FriendsScreen()),
        GetPage(name: '/sendFeedback', page: () => FeedbackForm()),
        GetPage(name: '/account', page: () => Accountpage()),
        GetPage(name: '/studentSetting', page: () => Studentsetting()),
        GetPage(name: '/feesScreen', page: () => FeesScreen()),
        GetPage(name: '/classSchedule', page: () => ClassRoutine()),
        GetPage(name: '/manageEvents', page: () => ManageEvent()),
        GetPage(name: '/admin-dashboard', page: () => AdminDashboard()),
        GetPage(name: '/changePassword', page: () => ChangePassword()),

      ],
    );
  }
}