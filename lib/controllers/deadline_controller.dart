// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
// import 'package:vidhyatra_flutter/controllers/LoginController.dart';
// import 'package:vidhyatra_flutter/models/deadline_model.dart';
//
// class DeadlineController extends GetxController {
//   var deadlines = <Deadline>[].obs;
//   var isLoading = true.obs;
//   var showAll = false.obs;
//   @override
//   void onInit() {
//     fetchDeadlines();
//     super.onInit();
//   }
//
//   Future<void> fetchDeadlines() async {
//     final LoginController loginController= Get.find();
//     try {
//       isLoading(true);
//       final response = await http.get(
//         Uri.parse('${ApiEndPoints.baseUrl}/api/deadlines'),
//         headers: {
//           'Authorization': 'Bearer ${loginController.token.value}',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         deadlines.assignAll(data.map((json) => Deadline.fromJson(json)).toList());
//       } else {
//         throw Exception('Failed to load deadlines: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch deadlines: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> markDeadlineCompleted(int id, bool isCompleted) async {
//     try {
//       final response = await http.patch(
//         Uri.parse('${ApiEndPoints.baseUrl}/api/deadlines/$id/complete'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'isCompleted': isCompleted}),
//       );
//       if (response.statusCode == 200) {
//         final deadline = deadlines.firstWhere((d) => d.id == id);
//         deadline.isCompleted = isCompleted;
//         deadlines.refresh(); // Update UI
//       } else {
//         throw Exception('Failed to update deadline: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to mark deadline: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/models/deadline_model.dart';

class DeadlineController extends GetxController {
  var deadlines = <Deadline>[].obs;
  var isLoading = true.obs;
  var showAll = false.obs;
  var errorMessage = ''.obs; // Add error message observable
  var hasError = false.obs; // Flag to track if there was an error

  @override
  void onInit() {
    fetchDeadlines();
    super.onInit();
  }

  Future<void> fetchDeadlines() async {
    final LoginController loginController = Get.find();
    try {
      isLoading(true);
      errorMessage('');
      hasError(false);

      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}/api/deadlines'),
        headers: {
          'Authorization': 'Bearer ${loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        deadlines.assignAll(data.map((json) => Deadline.fromJson(json)).toList());
      } else if (response.statusCode == 404) {
        // Not showing an error - just setting empty deadlines
        deadlines.clear();
      } else {
        hasError(true);
        errorMessage('Unable to load deadlines at this time');
      }
    } catch (e) {
      // Only show error in snackbar if it's a serious error, not just empty data
      if (e.toString().contains('404')) {
        deadlines.clear();
      } else {
        hasError(true);
        errorMessage('Connection issue. Please try again later.');
        Get.snackbar('Error', 'Failed to connect to the server',
            snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> markDeadlineCompleted(int id, bool isCompleted) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiEndPoints.baseUrl}/api/deadlines/$id/complete'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isCompleted': isCompleted}),
      );
      if (response.statusCode == 200) {
        final deadline = deadlines.firstWhere((d) => d.id == id);
        deadline.isCompleted = isCompleted;
        deadlines.refresh(); // Update UI
      } else {
        throw Exception('Failed to update deadline: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark deadline: $e');
    }
  }
}