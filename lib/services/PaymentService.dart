// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
//
// import '../controllers/LoginController.dart';
//
// class PaymentService {
//   // Reference to LoginController to access the token
//   final LoginController loginController = Get.find<LoginController>();
//
//   Future<Map<String, dynamic>> initializePayment(int feeID, double feeAmount) async {
//     final url = Uri.parse(ApiEndPoints.initializePaymentWithEsewa);
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${loginController.token.value}'
//       },
//       body: json.encode({
//       'feeID': feeID,
//       'feeAmount': feeAmount,
//     }),
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to initialize payment');
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

class PaymentService {
  final LoginController loginController = Get.find<LoginController>();

  Future<Map<String, dynamic>> initializePayment(int feeID, double feeAmount) async {
    final url = Uri.parse(ApiEndPoints.initializePaymentWithEsewa);
    try {
      if (loginController.token.value.isEmpty) {
        throw Exception('No authentication token available');
      }

      final payload = {'feeID': feeID, 'feeAmount': feeAmount};
      print('Request payload: $payload');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${loginController.token.value}',
        },
        body: json.encode(payload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        String errorMessage = 'Failed to initialize payment';
        if (response.statusCode == 401) {
          errorMessage = 'Unauthorized: Invalid or expired token';
        } else if (response.statusCode == 400) {
          errorMessage = 'Bad Request: Invalid feeID or feeAmount';
        } else if (response.statusCode == 404) {
          errorMessage = 'Endpoint not found';
        }
        throw Exception('$errorMessage: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during payment initialization: $e');
      rethrow;
    }
  }
}