import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'dart:convert';
import '../models/FeesModel.dart';
import 'LoginController.dart'; // Assuming LoginController is located here

class FeeController extends GetxController {
  var fees = <Fee>[].obs; // Observable list to store fees
  var isLoading = true.obs; // Observable for loading state
  var errorMessage = ''.obs; // Observable for error messages
  Rx<Fee?> selectedFee = Rx<Fee?>(null);

  // Reference to LoginController to access the token
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    print("FeeController initialized, fetching fees...");
    fetchFees(); // Automatically fetch fees when the controller is initialized
  }

  // Method to handle fee selection
  void selectFee(Fee fee) {
    selectedFee.value = fee; // Update selected fee
  }

  // Method to fetch fees
  Future<void> fetchFees() async {
    try {
      isLoading(true); // Set loading to true while fetching data
      errorMessage.value = ''; // Reset error message

      // Parse the URL separately
      Uri uri = Uri.parse(ApiEndPoints.getAllFees); // Ensure this URL is correct

      // Get the token from the LoginController
      String token = loginController.token.value; // Access the token dynamically

      // Define headers, including the Authorization header with Bearer token
      Map<String, String> headers = {
        'Authorization': 'Bearer $token', // Pass the token in the Authorization header
        'Content-Type': 'application/json',
      };

      // Debugging: Print request details
      print("Fetching fees from: $uri");
      print("Headers: $headers");

      final response = await http.get(uri, headers: headers); // Send GET request with headers

      // Debugging: Print response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        fees.value = jsonResponse.map((fee) => Fee.fromJson(fee)).toList(); // Update the fees list
        print("Fees fetched successfully: ${fees.length} items");
      } else {
        errorMessage.value = 'Failed to load fees: ${response.statusCode}';
        print("Error: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = 'Error: $e'; // If an error occurs, show the error message
      print("Exception occurred: $e");
    } finally {
      isLoading(false); // Set loading to false when done
    }
  }
}
