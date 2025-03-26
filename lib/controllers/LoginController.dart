import 'dart:convert';

import 'package:get/get.dart';

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
  // Login function
  Future<void> loginUser() async {
    if (emailOrID.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          snackPosition: SnackPosition.BOTTOM);
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

          print(
              "✅ Login Successful - Token: $tokenValue, UserID: $userIdValue, Role: $userRole, isAdmin: $isAdmin");

          Get.snackbar("Success", "Logged in successfully!",
              snackPosition: SnackPosition.BOTTOM);

          // Debugging role-based navigation
          if (isAdmin) {
            print("🔹 Navigating to /admin-dashboard");
            Get.toNamed('/admin-dashboard');
          } else if (userRole.toLowerCase() == 'teacher') {
            print("🔹 Navigating to /teacher-dashboard");
            Get.toNamed('/teacher-dashboard');
          } else if (userRole.toLowerCase() == 'student') {
            print("🔹 Navigating to /student-dashboard");
            Get.toNamed('/student-dashboard');
          } else {
            print("❌ Invalid Role: $userRole");
            Get.snackbar("Error", "Invalid role assigned to user.",
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          print("❌ Missing token or user data in response");
          Get.snackbar("Login Error", "Invalid response from server",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        final responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? "Invalid credentials";
        print("❌ Login failed - Server Response: $errorMessage");
        Get.snackbar(
            "Login Error", errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } on http.ClientException catch (e) {
      isLoading.value = false;
      print("❌ Network Error: ${e.toString()}");
      Get.snackbar("Network Error", "Please check your internet connection.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      isLoading.value = false;
      print("❌ Unexpected Error: ${error.toString()}");
      Get.snackbar("Error", "An error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}