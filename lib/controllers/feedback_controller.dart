import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/feedback_model.dart';
import '../constants/api_endpoints.dart';
import 'LoginController.dart';

class FeedbackController extends GetxController {
  final feedbackList = <FeedbackModel>[].obs;
  final isLoading = false.obs;
  final isAnonymous = false.obs; // Observable for isAnonymous checkbox

  // Declare controllers and selected type
  final feedbackContentController = TextEditingController();
  String? selectedType;

  // List of available feedback types
  final List<String> feedbackTypes = ['courses',
    'app_features',
    'facilities',
    'faculty_behavior',
    'technical_support',
    'bug_report',
    'suggestions',
    'others'];

  @override
  void onInit() {
    super.onInit();
    // Any initialization code if needed
  }

  @override
  void onClose() {
    // Properly dispose controllers
    feedbackContentController.dispose();
    super.onClose();
  }

  // Method to handle type selection
  void setSelectedType(String? value) {
    selectedType = value;
    update();
  }

  // Method to toggle anonymous status
  void toggleAnonymous(bool value) {
    isAnonymous.value = value;
  }

  // Method to clear the form
  void clearForm() {
    feedbackContentController.clear();
    selectedType = null;
    isAnonymous.value = false;
    update();
  }

  // Validate form
  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  // Method to create feedback model from form data
  FeedbackModel createFeedbackModel() {
    return FeedbackModel(
      feedbackType: selectedType!,
      feedbackContent: feedbackContentController.text,
      isAnonymous: isAnonymous.value,
    );
  }

  // Submit feedback to the backend
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      isLoading.value = true;

      final token = Get
          .find<LoginController>()
          .token
          .value; // Get token from LoginController
      final url = Uri.parse(ApiEndPoints.createFeedback);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode == 201) {
        clearForm();
        Get.back();
        Get.snackbar(
            'Success',
            'Feedback submitted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white.withOpacity(0.7),
            colorText: Colors.black
        );
      } else {
        // Debug: Print backend error if available
        print("Failed to submit feedback: ${response.body}");
        Get.snackbar(
            'Error',
            'Failed to submit feedback: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white
        );
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar(
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle the form submission process
  void handleSubmit(GlobalKey<FormState> formKey) {
    if (validateForm(formKey)) {
      final feedback = createFeedbackModel();
      submitFeedback(feedback);
    }
  }
}
// Fetch all feedback (admin use case) - commented out but kept for future reference
/*
  Future<void> fetchFeedback() async {
    final url = Uri.parse('http://10.0.2.2:3001/api/feedback'); // Replace with your API URL

    try {
      isLoading.value = true;
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        feedbackList.assignAll(data.map((e) => FeedbackModel.fromJson(e)).toList());
      } else {
        Get.snackbar('Error', 'Failed to fetch feedback');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
  */


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

