
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/providers/profile_provider.dart';
import 'package:vidhyatra_flutter/providers/user_provider.dart';
import 'package:vidhyatra_flutter/screens/Friends.dart';
import 'package:vidhyatra_flutter/screens/blog_posting_page.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
import 'package:vidhyatra_flutter/screens/chat_page.dart';
import 'package:vidhyatra_flutter/screens/dashboard.dart';
import 'package:vidhyatra_flutter/screens/forgot_password_page.dart';
import 'package:vidhyatra_flutter/screens/login.dart';
import 'package:vidhyatra_flutter/screens/payment_page.dart';
import 'package:vidhyatra_flutter/screens/register.dart';
import 'package:vidhyatra_flutter/screens/student_dashboard.dart';
import 'package:vidhyatra_flutter/screens/student_profile_page.dart';
import 'package:vidhyatra_flutter/screens/weekly_routine.dart';
import 'package:vidhyatra_flutter/screens/welcomePage.dart';

void main() {
  runApp(VidhyatraApp());
}

class VidhyatraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Use MultiProvider to allow multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Provide UserProvider
        ChangeNotifierProvider(create: (context) => ProfileProvider()), // Provide ProfileProvider
      ],
      child: GetMaterialApp(
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
          GetPage(name: '/payment', page: () => PaymentPage()),
          GetPage(name: '/profile', page: () => StudentProfilePage()),
          GetPage(name: '/calendar', page: () => Calendar()),
          GetPage(name: '/messages', page: () => ChatPage()),
          GetPage(name: '/dashboard', page: () => Dashboard()),
          GetPage(name: '/new-post', page: () => BlogPostPage()),
          GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
          GetPage(name: '/friends', page: () => FriendsScreen())

        ],
        // routes: {
        //   '/': (context) => WelcomeScreen(),
        //   '/login': (context) => LoginPage(),      // Add the '/login' route here
        //   '/register': (context) => RegisterPage(),
        //   '/home': (context) => StudentDashboard(),
        //   '/dashboard': (context) => Dashboard(), // Add this line
        //   '/profile': (context) => StudentProfilePage(), // Add Profile Page route
        //   '/payment': (context) => PaymentPage(), // Add Profile Page route
        //   '/calendar': (context) => Calendar(), // Add Profile Page route
        //   '/schedule': (context) => WeeklyRoutinePage(), // Add Profile Page route
        //   '/messages': (context) => ChatPage(),
        //   '/forgot_password': (context) => ForgotPasswordScreen(), // Forgot Password Page
        //
        //   // '/reset-password': (context) => ResetPasswordPage(),
        //   // You can also add other routes here
        // },
      ),
    );
  }
}
