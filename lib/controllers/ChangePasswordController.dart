import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

class ChangePasswordController extends GetxController {
  final LoginController loginController = Get.find<LoginController>(); // Access token from LoginController
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "New password and confirmation do not match");
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.changePassword),
        headers: {
          'Authorization': 'Bearer ${loginController.token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password changed successfully");
        Get.back(); // Close the screen
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Failed to change password");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}