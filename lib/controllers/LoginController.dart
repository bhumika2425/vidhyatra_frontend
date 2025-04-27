import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidhyatra_flutter/screens/TeacherDashboard.dart';
import 'package:vidhyatra_flutter/screens/login.dart';

import '../constants/api_endpoints.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // Observable variables
  var emailOrID = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var user = Rx<User?>(null); // Rx for user object
  var token = ''.obs;
  var userId = 0.obs;
  var isPasswordVisible = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value; // Toggle the value
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

          // print(
          //     "✅ Login Successful - Token: $tokenValue, UserID: $userIdValue, Role: $userRole, isAdmin: $isAdmin");

          Get.snackbar("Success", "Logged in successfully!",
              snackPosition: SnackPosition.TOP);

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
      // print("❌ Network Error: ${e.toString()}");
      Get.snackbar("Network Error", "Please check your internet connection.",
          snackPosition: SnackPosition.TOP);
    } catch (error) {
      isLoading.value = false;
      // print("❌ Unexpected Error: ${error.toString()}");
      Get.snackbar("Error", "An error occurred. Please try again.",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> logout() async {
    try {
      // Reset observable values
      token.value = '';
      user.value = null;
      userId.value = 0;

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