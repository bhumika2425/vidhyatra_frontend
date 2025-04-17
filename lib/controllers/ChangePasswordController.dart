import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/models/ChangePasswordModel.dart';

class ChangePasswordController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Observable variables for password visibility
  RxBool currentPasswordVisible = false.obs;
  RxBool newPasswordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;

  // Toggle password visibility functions
  void toggleCurrentPasswordVisibility() {
    currentPasswordVisible.value = !currentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
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