import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/profile.dart';

class ProfileController extends GetxController {
  // Observable variables
  var profile = Rx<Profile?>(null);  // Observable profile
  var isLoading = true.obs;

  // Fetch profile data function
  Future<void> fetchProfileData(String token) async {
    isLoading.value = true; // Set loading to true when fetching data

    try {
      final response = await http.get(
        Uri.parse(ApiEndPoints.fetchProfileData),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['profile'] != null) {
          profile.value = Profile.fromJson(data['profile']);
        } else {
          throw Exception('Profile data not found');
        }
      } else {
        String message;
        try {
          final errorData = json.decode(response.body);
          message = errorData['message'] ?? 'An error occurred';
        } catch (e) {
          message = 'Failed to load profile data';
        }
        throw Exception(message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }
}
