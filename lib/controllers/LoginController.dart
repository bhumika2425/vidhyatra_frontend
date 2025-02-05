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

  // Login function
  Future<void> loginUser() async {
    if (emailOrID.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': emailOrID.value,
          'password': password.value,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final tokenValue = responseData['token'];
        final userIdValue = responseData['user']['user_id'];
        final userData = User.fromJson(responseData['user']);

        // Storing user and token in state
        user.value = userData;
        token.value = tokenValue;
        userId.value = userIdValue;

        // Example: You can use a persistent storage solution for long-term storage.
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('token', tokenValue);


        Get.snackbar("Logged In", "You have successfully logged in!", snackPosition: SnackPosition.BOTTOM);
        Get.toNamed('/dashboard'); // Navigate to dashboard
      } else {
        final responseData = jsonDecode(response.body);
        Get.snackbar("Login Error", responseData['message'], snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar("Error", 'An error occurred. Please try again.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
