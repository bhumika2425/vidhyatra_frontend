// lib/controllers/feedback_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'dart:convert';
import '../models/feedback_model.dart';
import '../providers/user_provider.dart';

class FeedbackController extends GetxController {
  final feedbackList = <FeedbackModel>[].obs;
  final isLoading = false.obs;
  final isAnonymous = false.obs; // Observable for isAnonymous checkbox

  // Declare controllers and selected type
  final feedbackContentController = TextEditingController();
  String? selectedType;

  // Method to clear the form
  void clearForm() {
    feedbackContentController.clear();
    selectedType = null;
    isAnonymous.value = false;
  }

  // Submit feedback to the backend
  Future<void> submitFeedback(FeedbackModel feedback) async {
    final userProvider = Provider.of<UserProvider>(Get.context!, listen: false);
    final token = userProvider.token; // Retrieve the token
    final url = Uri.parse(ApiEndPoints.createFeedback); // Replace with your API URL

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Ensure content type is correct
        },
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode == 201) {
        isAnonymous.value = false;
        Get.back();
        Get.snackbar('Success', 'Feedback submitted successfully');
      } else {
        // Debug: Print backend error if available
        print("Failed to submit feedback: ${response.body}");
        Get.snackbar('Error', 'Failed to submit feedback: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Debug: Print the caught exception
      print("An error occurred: $e");
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }


// Fetch all feedback (admin use case)
  // Future<void> fetchFeedback() async {
  //   final url = Uri.parse('http://10.0.2.2:3001/api/feedback'); // Replace with your API URL
  //
  //   try {
  //     isLoading.value = true;
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       feedbackList.assignAll(data.map((e) => FeedbackModel.fromJson(e)).toList());
  //     } else {
  //       Get.snackbar('Error', 'Failed to fetch feedback');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'An error occurred: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
