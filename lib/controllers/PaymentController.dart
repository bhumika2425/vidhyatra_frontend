
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidhyatra_flutter/screens/PaymentProcessScreen.dart';
import 'package:vidhyatra_flutter/services/PaymentService.dart';
import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';

class PaymentController extends GetxController {
  final PaymentService paymentService;

  var isLoading = false.obs;
  var paymentData = {}.obs;
  var paidFeesData = {}.obs;


  PaymentController({required this.paymentService});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);

    print("\n🌐 Launching URL: $url");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Ensures it opens in a browser
    } else {
      print("\n❌ Could not launch $url");
    }
  }

  Future<void> payFee(int feeID, double feeAmount) async {
    isLoading(true);
    try {
      final data = await paymentService.initializePayment(feeID, feeAmount);
      print('received data: $data');
      paymentData.value = data['payment'];
      paidFeesData.value = data['paidFeesData'];

      Get.to(() => PaymentProcess());
    } catch (e) {
      print('error initializing payment: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> initiateToEsewaPayment (double amount, String transactionUuid, String signature) async {
    String url = "https://rc-epay.esewa.com.np/api/epay/main/v2/form";

    print("initiating payment");
    print("amount $amount");
    print("Transaction uuid $transactionUuid");
    print("Signature $signature");


    // Convert numeric values to integers
    int totalAmount = amount.toInt();
    int taxAmount = 0;
    int serviceCharge = 0;
    int deliveryCharge = 0;

    // Prepare the form data to send with the POST request
    final Map<String, String> formData = {
      'amount': totalAmount.toString(),
      'tax_amount': taxAmount.toString(),
      'total_amount': totalAmount.toString(),
      'transaction_uuid': transactionUuid,
      'product_code': 'EPAYTEST', // Replace with your actual product code
      'product_service_charge': serviceCharge.toString(),
      'product_delivery_charge': deliveryCharge.toString(),
      'success_url': '${ApiEndPoints.baseUrl}/api/payFees/complete-payment', // Update with actual success URL
      'failure_url': 'https://developer.esewa.com.np/failure', // Update with actual failure URL
      'signed_field_names': 'total_amount,transaction_uuid,product_code',
      'signature': signature, // Signature should be generated before this step
    };
    print("🔹 Form Data Sent:");
    formData.forEach((key, value) => print("  - $key: $value"));

    try {
      // Send POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.map((key, value) => MapEntry(key, value.toString())), // Convert all values to strings
      );
      print("\n🔹 Response Details:");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Headers: ${response.headers}");
      print("🔹 Body: ${response.body}");

      if (response.statusCode == 302) {
        // Extract redirection URL
        String? redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print("🔹 Redirecting to eSewa: $redirectUrl");
          await _launchURL(redirectUrl); // Open eSewa in a browser
        } else {
          print("❌ Error: No redirection URL found.");
        }
      } else {
        print("❌ Error: Unexpected response status.");
      }
    } catch (e) {
      print("❌ Exception Occurred: $e");
    }
  }
}