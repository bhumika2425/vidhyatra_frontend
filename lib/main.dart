import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vidhyatra_flutter/screens/AccountPage.dart';
import 'package:vidhyatra_flutter/screens/ChangePassword.dart';
import 'package:vidhyatra_flutter/screens/ClassRoutine.dart';
import 'package:vidhyatra_flutter/screens/ExamDashboardScreen.dart';
import 'package:vidhyatra_flutter/screens/ExamSeatPlanningHomeScreen.dart';
import 'package:vidhyatra_flutter/screens/FeesScreen.dart';
import 'package:vidhyatra_flutter/screens/PaymentHistory.dart';
import 'package:vidhyatra_flutter/screens/SettingsScreen.dart';
import 'package:vidhyatra_flutter/screens/blog_posting_page.dart';
import 'package:vidhyatra_flutter/screens/calendar.dart';
import 'package:vidhyatra_flutter/screens/StudentDashboard.dart';
import 'package:vidhyatra_flutter/screens/feedback_form.dart';
import 'package:vidhyatra_flutter/screens/forgot_password_page.dart';
import 'package:vidhyatra_flutter/screens/login.dart';
import 'package:vidhyatra_flutter/screens/NotificationScreen.dart';
import 'package:vidhyatra_flutter/screens/onboarding_screen.dart';
import 'package:vidhyatra_flutter/screens/premium_splash_screen.dart';
import 'package:vidhyatra_flutter/screens/register.dart';
import 'package:vidhyatra_flutter/screens/student_profile_page.dart';
import 'controllers/LoginController.dart';
import 'controllers/ProfileController.dart';
import 'controllers/NotificationController.dart';
import 'controllers/AnnouncementController.dart';
import 'services/socket_service.dart';
import 'services/fcm_service.dart';
import 'services/inactivity_service.dart';


void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');

    // Initialize FCM Service
    await FCMService().initialize();
    print('✅ FCM Service initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  // Initialize controllers in the correct order
  Get.put(LoginController());
  Get.put(ProfileController());
  Get.put(SocketService()); // Initialize socket service
  Get.put(NotificationController()); // Initialize notification controller
  Get.put(AnnouncementController()); // Initialize announcement controller
  Get.put(InactivityService()); // Initialize inactivity service

  runApp(VidhyatraApp());
}

class VidhyatraApp extends StatefulWidget {
  @override
  _VidhyatraAppState createState() => _VidhyatraAppState();
}

class _VidhyatraAppState extends State<VidhyatraApp> with WidgetsBindingObserver {
  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      // Check if "Keep me logged in" is disabled
      final keepLoggedIn = _storage.read('keep_logged_in') ?? false;

      if (!keepLoggedIn) {
        print('🔒 App closing without "Keep me logged in" - clearing session');

        try {
          final loginController = Get.find<LoginController>();

          // Clear FCM token from backend
          await loginController.clearFCMTokenOnLogout();

          // Clear local storage
          await _storage.erase();

          print('✅ Session cleared successfully');
        } catch (e) {
          print('❌ Error clearing session: $e');
        }
      } else {
        print('✅ "Keep me logged in" enabled - session preserved');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactivityService = Get.find<InactivityService>();

    return GestureDetector(
      onTap: () => inactivityService.resetInactivityTimer(),
      onPanDown: (_) => inactivityService.resetInactivityTimer(),
      onScaleStart: (_) => inactivityService.resetInactivityTimer(),
      behavior: HitTestBehavior.translucent,
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
          GetPage(name: '/', page: () => PremiumSplashScreen()),
          GetPage(name: '/welcome', page: () => OnboardingScreen()),
          GetPage(name: '/login', page: () => LoginPage()),
          GetPage(name: '/register', page: () => RegisterPage()),
          GetPage(name: '/profile', page: () => StudentProfilePage()),
          GetPage(name: '/calendar', page: () => Calendar()),
          GetPage(name: '/student-dashboard', page: () => Dashboard()),
          GetPage(name: '/new-post', page: () => BlogPostPage()),
          GetPage(name: '/forgot_password', page: () => ForgotPasswordPage()),
          GetPage(name: '/sendFeedback', page: () => FeedbackForm()),
          GetPage(name: '/account', page: () => Accountpage()),
          GetPage(name: '/feesScreen', page: () => FeesScreen()),
          GetPage(name: '/classSchedule', page: () => ClassRoutine()),
          GetPage(name: '/changePassword', page: () => ChangePassword()),
          GetPage(name: '/settings', page: () => SettingsScreen()),
          GetPage(name: '/payment-history', page: () => PaymentHistoryView()),
          GetPage(name: '/notifications', page: () => NotificationScreen()),

          // Exam Seat Planning Routes
          GetPage(name: '/exam-seat-planning', page: () => ExamSeatPlanningHomeScreen()),
          GetPage(name: '/exam-dashboard', page: () => ExamDashboardScreen()),
        ],
      ),
    );
  }
}



