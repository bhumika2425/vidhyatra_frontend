// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/feedback_model.dart';
// import '../constants/api_endpoints.dart';
// import 'LoginController.dart';
//
// class FeedbackController extends GetxController {
//   final feedbackList = <FeedbackModel>[].obs;
//   final isLoading = false.obs;
//   final isAnonymous = false.obs; // Observable for isAnonymous checkbox
//
//   // Declare controllers and selected type
//   final feedbackContentController = TextEditingController();
//   String? selectedType;
//
//   // List of available feedback types
//   final List<String> feedbackTypes = ['courses',
//     'app_features',
//     'facilities',
//     'faculty_behavior',
//     'technical_support',
//     'bug_report',
//     'suggestions',
//     'others'];
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Any initialization code if needed
//   }
//
//   @override
//   void onClose() {
//     // Properly dispose controllers
//     feedbackContentController.dispose();
//     super.onClose();
//   }
//
//   // Method to handle type selection
//   void setSelectedType(String? value) {
//     selectedType = value;
//     update();
//   }
//
//   // Method to toggle anonymous status
//   void toggleAnonymous(bool value) {
//     isAnonymous.value = value;
//   }
//
//   // Method to clear the form
//   void clearForm() {
//     feedbackContentController.clear();
//     selectedType = null;
//     isAnonymous.value = false;
//     update();
//   }
//
//   // Validate form
//   bool validateForm(GlobalKey<FormState> formKey) {
//     return formKey.currentState!.validate();
//   }
//
//   // Method to create feedback model from form data
//   FeedbackModel createFeedbackModel() {
//     return FeedbackModel(
//       feedbackType: selectedType!,
//       feedbackContent: feedbackContentController.text,
//       isAnonymous: isAnonymous.value,
//     );
//   }
//
//   // Submit feedback to the backend
//   Future<void> submitFeedback(FeedbackModel feedback) async {
//     try {
//       isLoading.value = true;
//
//       final token = Get
//           .find<LoginController>()
//           .token
//           .value; // Get token from LoginController
//       final url = Uri.parse(ApiEndPoints.createFeedback);
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(feedback.toJson()),
//       );
//
//       if (response.statusCode == 201) {
//         clearForm();
//         Get.back();
//         Get.snackbar(
//             'Success',
//             'Feedback submitted successfully',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.white.withOpacity(0.7),
//             colorText: Colors.black
//         );
//       } else {
//         // Debug: Print backend error if available
//         print("Failed to submit feedback: ${response.body}");
//         Get.snackbar(
//             'Error',
//             'Failed to submit feedback: ${response.statusCode}',
//             snackPosition: SnackPosition.TOP,
//
//         );
//       }
//     } catch (e) {
//       print("An error occurred: $e");
//       Get.snackbar(
//           'Error',
//           'An error occurred: $e',
//           snackPosition: SnackPosition.BOTTOM,
//
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Method to handle the form submission process
//   void handleSubmit(GlobalKey<FormState> formKey) {
//     if (validateForm(formKey)) {
//       final feedback = createFeedbackModel();
//       submitFeedback(feedback);
//     }
//   }
// }




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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as htmlParser; // Import for sanitization
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
  final List<String> feedbackTypes = [
    'courses',
    'app_features',
    'facilities',
    'faculty_behavior',
    'technical_support',
    'bug_report',
    'suggestions',
    'others'
  ];

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

// Validate character length
  bool validateCharacterLimit(String input, {int maxLength = 500}) {
    return input.length <= maxLength;
  }

  // Validate form
  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  // Method to create feedback model from form data
  FeedbackModel createFeedbackModel() {
    return FeedbackModel(
      feedbackType: selectedType!,
      feedbackContent: sanitizeInput(feedbackContentController.text),
      // Sanitize feedback content
      isAnonymous: isAnonymous.value,
    );
  }

  // Sanitize the input by escaping harmful scripts and emojis
  String sanitizeInput(String input) {
    // Remove emojis from the input
    String sanitizedInput = removeEmojis(input);
    // Escape harmful characters
    var parsed = htmlParser.parse(sanitizedInput);
    return parsed.body?.text ?? ''; // Return sanitized text
  }

  // Function to remove emojis from the input
  String removeEmojis(String input) {
    // Regular expression to match emojis
    RegExp emojiRegEx = RegExp(
      r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{2B50}\u{1F004}-\u{1F0CF}]',
      unicode: true,
    );
    return input.replaceAll(
        emojiRegEx, ''); // Replace emojis with an empty string
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
          'Invalid inputs detected, please use proper text',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle the form submission process
  void handleSubmit(GlobalKey<FormState> formKey) {
    if (validateForm(formKey)) {
      final feedbackText = feedbackContentController.text.trim();

      if (!validateCharacterLimit(feedbackText)) {
        Get.snackbar(
          'Error',
          'Feedback cannot exceed 500 characters.',
          snackPosition: SnackPosition.TOP,
        );
        return; // Stop submission if limit is exceeded
      }

      final feedback = createFeedbackModel();
      submitFeedback(feedback);
    }
  }
}