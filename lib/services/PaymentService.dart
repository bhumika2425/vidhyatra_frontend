import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';

class PaymentService {
  Future<Map<String, dynamic>> initializePayment(int feeID, double feeAmount) async {
    final url = Uri.parse(ApiEndPoints.initializePaymentWithEsewa);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode({
      'feeID': feeID,
      'feeAmount': feeAmount,
    }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to initialize payment');
    }
  }
}