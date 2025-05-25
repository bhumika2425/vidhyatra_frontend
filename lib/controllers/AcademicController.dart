import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_endpoints.dart';
import '../models/AcademicModel.dart';
import 'LoginController.dart';

class AcademicController extends GetxController {
  var academicEvents = <AcademicEvent>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    fetchAcademicEvents();
  }

  Future<void> fetchAcademicEvents() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      Uri uri = Uri.parse(ApiEndPoints.getAcademic);
      String token = loginController.token.value;

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('events')) {
          List events = jsonResponse['events'];
          academicEvents.value = events.map((event) => AcademicEvent.fromJson(event)).toList();

        } else {
          errorMessage.value = 'Invalid JSON structure: Expected "events" array';

        }
      } else {
        errorMessage.value = 'Failed to load academic events: ${response.statusCode}';

      }
    } catch (e) {
      errorMessage.value = 'Error fetching academic events: $e';

    } finally {
      isLoading(false);
    }
  }
}