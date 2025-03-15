import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

import '../model/event_posting_model.dart';

class EventPostingController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final LoginController loginController = Get.put(LoginController());

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); // Automatically fetch events when the controller is initialized
  }

  // Post a new event
  Future<void> postEvent(Event event) async {
    isLoading(true);
    errorMessage.value = '';
    successMessage.value = '';

    print("Starting to post event..."); // Debugging statement

    try {
      // API endpoint for posting events (replace with actual endpoint)
      Uri url = Uri.parse(ApiEndPoints.postEvents);
      // Example of headers and body
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${loginController.token.value}'
      };
      // Send the POST request
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(event.toJson()),
      );

      if (response.statusCode == 201) {
        successMessage.value = 'Event created successfully!';
        Get.snackbar('Event Posted', 'Event posted successfully');

        fetchEvents();

      } else {
        errorMessage.value = 'Failed to create event: ${response.statusCode}';
        print("Failed to create event. Status Code: ${response.statusCode}");  // Debugging statement for failure
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print("Error occurred: $e");  // Debugging statement for error
    } finally {
      isLoading(false);
      print("Post event process finished.");  // Debugging statement for completion
    }
  }

  var events = <Event>[].obs; // Observable list to store fees


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


      final response = await http.get(uri, headers: headers); // Send GET request with headers


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