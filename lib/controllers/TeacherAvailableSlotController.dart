import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

class TeacherAvailableSlotsController extends GetxController {
  final Map<String, dynamic> teacher;
  TeacherAvailableSlotsController(this.teacher);

  final RxBool isLoading = true.obs;
  final RxList<dynamic> availableSlots = <dynamic>[].obs;
  final RxList<dynamic> filteredSlots = <dynamic>[].obs;
  final RxnString errorMessage = RxnString();
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableSlots();
  }

  void fetchAvailableSlots() async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    const baseUrl = ApiEndPoints.baseUrl;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final url = Uri.parse('$baseUrl/api/timeslots/available?teacher_id=${teacher['user_id']}');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> slotsData = json.decode(response.body);
        availableSlots.assignAll(slotsData);
        filterSlotsByDate();
      } else {
        errorMessage.value = 'Failed to fetch slots: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching slots: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void filterSlotsByDate() {
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedSelectedDate = formatter.format(selectedDate.value);

    final filtered = availableSlots.where((slot) {
      return slot['date'] == formattedSelectedDate;
    }).toList();

    filteredSlots.assignAll(filtered);
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    filterSlotsByDate();
  }
}
