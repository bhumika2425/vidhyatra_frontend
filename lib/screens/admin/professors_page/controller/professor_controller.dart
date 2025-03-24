import 'dart:convert';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/screens/admin/admin_students/model/admin_students_model.dart';
import '../../../../constants/api_endpoints.dart';
import '../../../../controllers/LoginController.dart';
import 'package:http/http.dart' as http;

class ProfessorController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var professors = <User>[].obs;

  final LoginController loginController = Get.find<LoginController>(); // Use Get.find instead of Get.put

  @override
  void onInit() {
    super.onInit();
    fetchProfessor();
  }

  Future<void> fetchProfessor() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(ApiEndPoints.getProfessors);
      final token = loginController.token.value;

      print('Fetching professors from: $uri');
      print('Using token: $token');

      if (token.isEmpty) {
        errorMessage.value = 'Authentication token is missing';
        print('Error: Token is empty');
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      print('Request headers: $headers');

      final response = await http.get(uri, headers: headers);

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Decoded JSON response: $jsonResponse');

        // Check if response is a Map and contains 'data' key
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          final professorsData = jsonResponse['data'];
          print('Extracted data array: $professorsData');

          if (professorsData is List) {
            try {
              professors.value = professorsData.map((professor) {
                print('Parsing professors: $professor');
                return User.fromJson(professor as Map<String, dynamic>);
              }).toList();
              successMessage.value = 'professors fetched successfully';
              print('Successfully parsed ${professors.length} professors');
            } catch (e) {
              errorMessage.value = 'Error parsing professors data: $e';
              print('Parsing error: $e');
            }
          } else {
            errorMessage.value = 'Data field is not a list: ${professorsData.runtimeType}';
            print('Error: Expected List but got ${professorsData.runtimeType}');
          }
        } else {
          errorMessage.value = 'Invalid response format: Expected object with "data" key';
          print('Error: Unexpected response structure: ${jsonResponse.runtimeType}');
        }
      } else {
        errorMessage.value = 'Failed to load professors: ${response.statusCode} - ${response.body}';
        print('Error response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching professors: $e';
      print('Exception caught: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
      print('Fetch operation completed');
    }
  }

  // Add professors method (was referenced but not implemented)
  Future<void> addProfessor(User professor) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(ApiEndPoints.register); // Assuming this is the endpoint for adding users
      final token = loginController.token.value;

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'collegeId': professor.collegeId,
        'name': professor.name,
        'email': professor.email,
        'role': professor.role,
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchProfessor(); // Refresh the list
        successMessage.value = 'Professor added successfully';
      } else {
        errorMessage.value = 'Failed to add professor: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      errorMessage.value = 'Error adding professor: $e';
    } finally {
      isLoading.value = false;
    }
  }
}