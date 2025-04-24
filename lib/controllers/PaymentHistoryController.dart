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
    print('🔍 PaymentHistoryController: Initialized, calling fetchPaymentHistory');
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    final LoginController loginController = Get.find<LoginController>();
    try {
      isLoading.value = true;
      print('🔍 PaymentHistoryController: Starting fetchPaymentHistory');

      // Log the token and endpoint
      final token = loginController.token.value;
      final endpoint = '${ApiEndPoints.fetchPaymentHistory}'  ;
      print('🔍 Request URL: $endpoint');
      print('🔍 Authorization Token: ${token.isEmpty ? "Empty" : "Present"}');

      // Check if token is empty
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }

      // Log headers
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      print('🔍 Request Headers: $headers');

      // Make the HTTP request
      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      // Log response details
      print('🔍 Response Status Code: ${response.statusCode}');
      print('🔍 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🔍 Parsed JSON Data: $data');

        if (data['success']) {
          print('🔍 Processing payment history data');
          paymentHistory.value = (data['paymentHistory'] as List)
              .asMap()
              .entries
              .map((entry) {
            try {
              final item = entry.value;
              print('🔍 Parsing item ${entry.key}: $item');
              return PaymentHistoryModel.fromJson(item);
            } catch (e) {
              print('🔍 Error parsing item ${entry.key}: $e');
              throw Exception('Failed to parse payment history item: $e');
            }
          })
              .toList();
          print('🔍 Payment History Updated: ${paymentHistory.length} items');
        } else {
          errorMessage.value = data['message'] ?? 'Failed to fetch payment history';
          print('🔍 Server Error: ${errorMessage.value}');
        }
      } else if (response.statusCode == 404) {
        errorMessage.value = 'No payment history found';
        print('🔍 404 Error: No payment history found');
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
      print('🔍 Exception Caught: $e');
    } finally {
      isLoading.value = false;
      print('🔍 PaymentHistoryController: fetchPaymentHistory completed, isLoading: ${isLoading.value}');
    }
  }
}