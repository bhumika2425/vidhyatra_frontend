import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> registerUser({
    required String collegeId,
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(ApiEndPoints.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'collegeId': collegeId,
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final responseData = jsonDecode(response.body);
      print(response.statusCode);
      String message = responseData['message'] ?? 'An error occurred';

      switch (response.statusCode) {
        case 201:
          Get.offNamed('/login');
          _showSuccessMessage('Registration Successful',
              'You have been registered successfully. Please login to continue.');
          break;

        case 400:
          if (message.contains('student ID') || message.contains('teacher ID')) {
            _showErrorMessage('Role Mismatch', message);
          } else if (message.contains('college database')) {
            _showErrorMessage('Verification Failed',
                'Your ID or email was not found in the college database. Please verify your details.');
          } else {
            _showErrorMessage('Invalid Input', message);
          }
          break;

        case 409:
          if (message.contains('Email already registered')) {
            _showErrorMessage('Email Already Exists',
                'This email is already registered. Please use a different email.');
          } else if (message.contains('College ID already registered')) {
            _showErrorMessage('College ID Already Exists',
                'This College ID is already registered. Please contact support if this is an error.');
          } else {
            _showErrorMessage('Registration Failed', message);
          }
          break;

        case 500:
          _showErrorMessage('Server Error',
              'An error occurred on our servers. Please try again later.');
          print('Server Error An error occurred on our servers. Please try again later.');
          break;

        default:
          _showErrorMessage('Registration Failed', message);
      }
    } catch (error) {
      _showErrorMessage('Connection Error',
          'Unable to connect to server. Please check your internet connection.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onPrimary,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: Get.theme.colorScheme.onPrimary),
    );
  }

  void _showErrorMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
    );
  }
}