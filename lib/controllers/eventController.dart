import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'dart:convert';
import '../models/EventsModel.dart';
import '../models/FeesModel.dart';
import 'LoginController.dart'; // Assuming LoginController is located here

class EventController extends GetxController {
  var events = <Event>[].obs; // Observable list to store fees
  var isLoading = true.obs; // Observable for loading state
  var errorMessage = ''.obs; // Observable for error messages
  Rx<Fee?> selectedFee = Rx<Fee?>(null);

  // Reference to LoginController to access the token
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    print("EventController initialized, fetching events...");
    fetchEvents(); // Automatically fetch events when the controller is initialized
  }

  // Method to fetch fees
  Future<void> fetchEvents() async {
    try {
      isLoading(true); // Set loading to true while fetching data
      errorMessage.value = ''; // Reset error message

      // Parse the URL separately
      Uri uri = Uri.parse(ApiEndPoints.getEvents); // Ensure this URL is correct

      // Get the token from the LoginController
      String token = loginController.token.value; // Access the token dynamically

      // Define headers, including the Authorization header with Bearer token
      Map<String, String> headers = {
        'Authorization': 'Bearer $token', // Pass the token in the Authorization header
        'Content-Type': 'application/json',
      };

      // Debugging: Print request details
      print("Fetching events from: $uri");
      print("Headers: $headers");

      final response = await http.get(uri, headers: headers); // Send GET request with headers

      // Debugging: Print response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        events.value = jsonResponse.map((event) => Event.fromJson(event)).toList(); // Update the fees list
        print("Events fetched successfully: ${events.length} items");
      } else {
        errorMessage.value = 'Failed to load events: ${response.statusCode}';
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
