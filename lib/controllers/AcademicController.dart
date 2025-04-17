import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_endpoints.dart';
import '../models/AcademicModel.dart';
import 'LoginController.dart'; // Assuming LoginController is located here

class AcademicController extends GetxController {
  var academicEvents = <Academic>[].obs; // Observable list to store academic events
  var isLoading = true.obs; // Observable for loading state
  var errorMessage = ''.obs; // Observable for error messages

  // Reference to LoginController to access the token
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    fetchAcademicEvents(); // Automatically fetch academic events when the controller is initialized
  }

  // Method to fetch academic events
  Future<void> fetchAcademicEvents() async {
    try {
      isLoading(true); // Set loading to true while fetching data
      errorMessage.value = ''; // Reset error message

      // Parse the URL for academic events
      Uri uri = Uri.parse(ApiEndPoints.getAcademic); // Ensure this URL is correct

      // Get the token from the LoginController
      String token = loginController.token.value; // Access the token dynamically

      // Define headers, including the Authorization header with Bearer token
      Map<String, String> headers = {
        'Authorization': 'Bearer $token', // Pass the token in the Authorization header
        'Content-Type': 'application/json',
      };

      // Debugging: Print request details
      print("Fetching academic events from: $uri");
      print("Headers: $headers");

      final response = await http.get(uri, headers: headers); // Send GET request with headers

      // Debugging: Print response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        academicEvents.value = jsonResponse.map((event) => Academic.fromJson(event)).toList();
        print("Academic events fetched successfully: ${academicEvents.length} items");
      } else {
        errorMessage.value = 'Failed to load academic events: ${response.statusCode}';
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