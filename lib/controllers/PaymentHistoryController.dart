import 'dart:convert';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/models/PaymentHistoryModel.dart';
import 'package:http/http.dart' as http;

class PaymentHistoryController extends GetxController {
  var isLoading = false.obs;
  var paymentHistory = <PaymentHistoryModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    final LoginController loginController = Get.find<LoginController>();
    try {
      isLoading.value = true;
      // Log the token and endpoint
      final token = loginController.token.value;
      final endpoint = '${ApiEndPoints.fetchPaymentHistory}'  ;

      // Check if token is empty
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }

      // Log headers
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Make the HTTP request
      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          paymentHistory.value = (data['paymentHistory'] as List)
              .asMap()
              .entries
              .map((entry) {
            try {
              final item = entry.value;
              return PaymentHistoryModel.fromJson(item);
            } catch (e) {
              throw Exception('Failed to parse payment history item: $e');
            }
          })
              .toList();
        } else {
          errorMessage.value = data['message'] ?? 'Failed to fetch payment history';
        }
      } else if (response.statusCode == 404) {
        errorMessage.value = 'No payment history found';
      } else {
        // Handle specific status codes
        String errorDetail = 'Failed to load payment history';
        if (response.statusCode == 401) {
          errorDetail = 'Unauthorized: Invalid or expired token';
        } else if (response.statusCode == 403) {
          errorDetail = 'Forbidden: Access denied';
        } else if (response.statusCode == 500) {
          errorDetail = 'Server error';
        }
        errorMessage.value = errorDetail;
        throw Exception('$errorDetail: Status ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error occurred while fetching payment history: $e';
    } finally {
      isLoading.value = false;
    }
  }
}