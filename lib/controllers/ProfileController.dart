// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../constants/api_endpoints.dart';
// import '../models/profile.dart';
//
// class ProfileController extends GetxController {
//   // Observable variables
//   var profile = Rx<Profile?>(null);  // Observable profile
//   var isLoading = true.obs;
//
//   // Fetch profile data function
//   Future<void> fetchProfileData(String token) async {
//     isLoading.value = true; // Set loading to true when fetching data
//
//     try {
//       final response = await http.get(
//         Uri.parse(ApiEndPoints.fetchProfileData),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['profile'] != null) {
//           profile.value = Profile.fromJson(data['profile']);
//         } else {
//           throw Exception('Profile data not found');
//         }
//       } else {
//         String message;
//         try {
//           final errorData = json.decode(response.body);
//           message = errorData['message'] ?? 'An error occurred';
//         } catch (e) {
//           message = 'Failed to load profile data';
//         }
//         throw Exception(message);
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoading.value = false; // Set loading to false after data is fetched
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/profile.dart';

class ProfileController extends GetxController {
  // Observable variables
  var profile = Rx<Profile?>(null);  // Observable profile
  var isLoading = true.obs;
  var isNewUser = false.obs; // Add flag to track if user is new
  var errorMessage = ''.obs; // Add error message observable

  // Fetch profile data function
  Future<void> fetchProfileData(String token) async {
    isLoading.value = true; // Set loading to true when fetching data
    errorMessage('');

    try {
      final response = await http.get(
        Uri.parse(ApiEndPoints.fetchProfileData),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['profile'] != null) {
          profile.value = Profile.fromJson(data['profile']);
          isNewUser.value = false;
        } else {
          // No profile data found - this is likely a new user
          profile.value = null;
          isNewUser.value = true;
        }
      } else if (response.statusCode == 404) {
        // User doesn't have a profile yet - this is normal for new users
        profile.value = null;
        isNewUser.value = true;
      } else {
        String message;
        try {
          final errorData = json.decode(response.body);
          message = errorData['message'] ?? 'An error occurred';
        } catch (e) {
          message = 'Failed to load profile data';
        }
        errorMessage(message);
        throw Exception(message);
      }
    } catch (e) {
      if (!e.toString().contains('404')) {
        // Only show snackbar for real errors, not for "profile not found"
        Get.snackbar("Error", "Unable to connect to the server",
            snackPosition: SnackPosition.BOTTOM);
        errorMessage('Connection issue. Please try again.');
      }
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }
}
