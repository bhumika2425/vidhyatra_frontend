
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/providers/profile_provider.dart';
import 'package:vidhyatra_flutter/providers/user_provider.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
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
      child: MaterialApp(
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
        routes: {
          '/': (context) => WelcomeScreen(),
          '/login': (context) => LoginPage(),      // Add the '/login' route here
          '/register': (context) => RegisterPage(),
          '/home': (context) => StudentDashboard(),
          '/dashboard': (context) => StudentDashboard(), // Add this line
          '/profile': (context) => StudentProfilePage(), // Add Profile Page route
          '/payment': (context) => PaymentPage(), // Add Profile Page route
          '/calendar': (context) => Calendar(), // Add Profile Page route
          '/schedule': (context) => WeeklyRoutinePage(), // Add Profile Page route
          // You can also add other routes here
        },
      ),
    );
  }
}