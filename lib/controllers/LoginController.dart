import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidhyatra_flutter/screens/TeacherDashboard.dart';
import 'package:vidhyatra_flutter/screens/login.dart';
import 'package:vidhyatra_flutter/controllers/NotificationController.dart';
import 'package:vidhyatra_flutter/services/fcm_service.dart';

import '../constants/api_endpoints.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // Storage
  final GetStorage _storage = GetStorage();
  
  // Observable variables
  var emailOrID = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var user = Rx<User?>(null); // Rx for user object
  var token = ''.obs;
  var userId = 0.obs;
  var isPasswordVisible = false.obs;
  var keepMeLoggedIn = false.obs; // NEW: Keep me logged in checkbox

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value; // Toggle the value
  }

  // Toggle keep me logged in
  void toggleKeepMeLoggedIn() {
    keepMeLoggedIn.value = !keepMeLoggedIn.value;
  }

  // Check if user is already logged in (called on app startup)
  Future<bool> checkExistingLogin() async {
    try {
      print('🔍 Checking for existing login session...');
      
      // Check if "Keep me logged in" was enabled
      final keepLoggedIn = _storage.read('keep_logged_in') ?? false;
      
      if (!keepLoggedIn) {
        print('⚠️ Keep me logged in was disabled - clearing session');
        await _storage.erase();
        return false;
      }
      
      final storedToken = _storage.read('token');
      final storedUserId = _storage.read('user_id');
      final storedUser = _storage.read('user');
      
      if (storedToken != null && storedUserId != null && storedUser != null) {
        print('✅ Found existing session for user ID: $storedUserId');
        
        // Restore session
        token.value = storedToken;
        userId.value = storedUserId;
        user.value = User.fromJson(storedUser);
        
        print('👤 Restored user: ${user.value?.collegeId}');
        
        // Reconnect socket
        try {
          final notificationController = Get.find<NotificationController>();
          await notificationController.connectSocket();
          print('✅ Socket reconnected successfully');
        } catch (e) {
          print('⚠️ Failed to reconnect socket: $e');
        }
        
        // Re-register FCM token
        try {
          print("📱 Re-registering FCM token after app restart...");
          final fcmService = FCMService();
          final fcmToken = await fcmService.getNewToken();
          if (fcmToken != null) {
            final success = await fcmService.sendTokenToBackend(fcmToken);
            if (success) {
              print("✅ FCM token re-registered successfully");
            } else {
              print("⚠️ FCM token sent but backend responded with error");
            }
          } else {
            print("⚠️ No FCM token available - push notifications disabled");
          }
        } catch (e) {
          print("⚠️ Failed to re-register FCM token: $e");
        }
        
        return true;
      }
      
      print('⚠️ No existing session found');
      return false;
    } catch (e) {
      print('❌ Error checking existing login: $e');
      return false;
    }
  }

  // // After successful login, store the token
  // Future<void> storeAuthToken(String tokenValue) async {
  //   await storage.write(key: 'auth_token', value: tokenValue);
  // }
  // Login function
  Future<void> loginUser() async {
    if (emailOrID.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Added this line
        },
        body: jsonEncode({
          'identifier': emailOrID.value,
          // Ensure this key matches the backend API
          'password': password.value,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('token') &&
            responseData.containsKey('user')) {
          final tokenValue = responseData['token'];
          final userIdValue = responseData['user']['user_id'];
          final userRole = responseData['user']['role']; // Extract role
          final isAdmin = responseData['user']['isAdmin'] ??
              false; // Check isAdmin flag
          final userData = User.fromJson(responseData['user']);

          // Store user details
          user.value = userData;
          token.value = tokenValue;
          userId.value = userIdValue;
          
          // Store session data
          if (keepMeLoggedIn.value) {
            // Persistent storage - survives app restart
            _storage.write('token', tokenValue);
            _storage.write('user_id', userIdValue);
            _storage.write('user', responseData['user']);
            _storage.write('keep_logged_in', true);
            print("✅ Session saved persistently (Keep me logged in: ON)");
          } else {
            // Temporary storage - only for FCM during this session
            _storage.write('token', tokenValue);
            _storage.write('user_id', userIdValue);
            _storage.write('keep_logged_in', false);
            print("✅ Session saved temporarily (Keep me logged in: OFF)");
          }

          // print(
          //     "✅ Login Successful - Token: $tokenValue, UserID: $userIdValue, Role: $userRole, isAdmin: $isAdmin");

          Get.snackbar("Success", "Logged in successfully!",
              snackPosition: SnackPosition.TOP);

          // Connect to socket after successful login
          try {
            final notificationController = Get.find<NotificationController>();
            await notificationController.connectSocket();
          } catch (e) {
            print("⚠️ Failed to connect socket: $e");
          }

          // Register FCM token after successful login
          try {
            print("📱 Registering FCM token...");
            final fcmService = FCMService();
            final fcmToken = await fcmService.getNewToken();
            if (fcmToken != null) {
              final success = await fcmService.sendTokenToBackend(fcmToken);
              if (success) {
                print("✅ FCM token registered successfully");
              } else {
                print("⚠️ FCM token sent but backend responded with error");
              }
            } else {
              print("⚠️ No FCM token available - push notifications disabled");
              print("💡 This is normal on emulators without Google Play Services");
            }
          } catch (e) {
            print("⚠️ Failed to register FCM token: $e");
            print("💡 App will continue without push notifications");
          }

          // Debugging role-based navigation
          if (isAdmin) {

            Get.toNamed('/admin-dashboard');
          } else if (userRole.toLowerCase() == 'teacher') {

            Get.to(DashboardView());
          } else if (userRole.toLowerCase() == 'student') {

            Get.toNamed('/student-dashboard');
          } else {
            // print("❌ Invalid Role: $userRole");
            Get.snackbar("Error", "Invalid role assigned to user.",
                snackPosition: SnackPosition.TOP);
          }
        } else {
          // print("❌ Missing token or user data in response");
          Get.snackbar("Login Error", "Invalid response from server",
              snackPosition: SnackPosition.TOP);
        }
      } else {
        final responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? "Invalid credentials";
        // print("❌ Login failed - Server Response: $errorMessage");
        Get.snackbar(
            "Login Error", errorMessage, snackPosition: SnackPosition.TOP);
      }
    } on http.ClientException catch (e) {
      isLoading.value = false;
      print("❌ Network Error: ${e.toString()}");
      Get.snackbar("Network Error", "Please check your internet connection.",
          snackPosition: SnackPosition.TOP);
    } catch (error) {
      isLoading.value = false;
      // print("❌ Unexpected Error: ${error.toString()}");
      Get.snackbar("Error", "An error occurred. Please try again.",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> clearFCMTokenOnLogout() async {
    try {
      print("🔴 Clearing FCM token on app close...");
      final fcmService = FCMService();
      await fcmService.clearToken();
      print("✅ FCM token cleared successfully");
    } catch (e) {
      print("⚠️ Failed to clear FCM token: $e");
    }
  }

  Future<void> logout() async {
    try {
      // Clear FCM token before logout
      try {
        print("🔴 Clearing FCM token on logout...");
        final fcmService = FCMService();
        await fcmService.clearToken();
        print("✅ FCM token cleared successfully");
      } catch (e) {
        print("⚠️ Failed to clear FCM token: $e");
      }

      // Disconnect socket before logout
      try {
        final notificationController = Get.find<NotificationController>();
        notificationController.disconnectSocket();
      } catch (e) {
        print("⚠️ Failed to disconnect socket: $e");
      }

      // Reset observable values
      token.value = '';
      user.value = null;
      userId.value = 0;
      
      // Clear GetStorage
      _storage.erase();
      print("✅ Storage cleared");

      // Show success snackbar
      Get.snackbar(
        "Success",
        "Logged out successfully!",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );

      Get.offAllNamed('/login', arguments: {'loggedOut': true});
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout properly. Please try again.',

      );
    }
  }

}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class LoginController extends GetxController {
//   var email = ''.obs;
//   var password = ''.obs;
//
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//
//   @override
//   void onInit() {
//     super.onInit();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//
//     // Sync TextEditingController with observables
//     emailController.addListener(() {
//       email.value = emailController.text;
//     });
//     passwordController.addListener(() {
//       password.value = passwordController.text;
//     });
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
//
//   void login() {
//     // Add your login logic here
//     print("Email: ${email.value}, Password: ${password.value}");
//   }
// }