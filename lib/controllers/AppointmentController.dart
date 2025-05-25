import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import '../models/TimeslotModel.dart';

class AppointmentController extends GetxController {
  static const String baseUrl = '${ApiEndPoints.baseUrl}';
  var selectedDate = DateTime.now().obs;
  var dateTimeSlots = <String, List<TimeSlot>>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    fetchTimeSlots();
  }

  // Select a date and fetch slots
  void selectDate(DateTime date) {
    selectedDate.value = date;

    fetchTimeSlots();
  }

  // Fetch time slots for the selected date
  Future<void> fetchTimeSlots() async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;

    try {
      isLoading.value = true;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final url = Uri.parse('$baseUrl/api/timeSlots/teacher');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };



      final response = await http.get(url, headers: headers);


      if (response.statusCode == 200) {

        final List<dynamic> slotData = json.decode(response.body);


        if (slotData.isNotEmpty) {


          final slotsForSelectedDate = slotData
              .map((slot) => TimeSlot.fromJson(slot))
              .where((slot) => DateFormat('yyyy-MM-dd').format(slot.startTime) == formattedDate)
              .toList();

          dateTimeSlots[formattedDate] = slotsForSelectedDate;


        } else {

          dateTimeSlots[formattedDate] = [];
          Get.snackbar('Info', 'No time slots found for selected date');
        }
      } else {

        Get.snackbar('Error', 'Failed to fetch time slots: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {

      Get.snackbar('Error', 'An error occurred while fetching time slots: $e');
    } finally {
      isLoading.value = false;

    }
  }

  // Add a new time slot
  Future<void> addTimeSlot(DateTime startTime, DateTime endTime) async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    final teacherId = loginController.user.value?.userId ?? '';

    try {
      isLoading.value = true;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final slotCount = dateTimeSlots[formattedDate]?.length ?? 0;

      if (slotCount >= 10) {

        Get.snackbar('Maximum Reached', 'Maximum 10 time slots allowed per day');
        return;
      }

      final url = Uri.parse('$baseUrl/api/timeSlots/create');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = {
        'date': formattedDate,
        'start_time': DateFormat('HH:mm:ss').format(startTime),
        'end_time': DateFormat('HH:mm:ss').format(endTime),
      };



      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );


      if (response.statusCode == 201) {
        if (response.body.isEmpty) {

          Get.snackbar('Error', 'Failed to add time slot: Empty response from server');
          return;
        }

        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse == null || jsonResponse is! Map<String, dynamic>) {

          Get.snackbar('Error', 'Failed to add time slot: Invalid response format');
          return;
        }

        // Add teacherId to the response JSON since backend doesn't include teacher object
        jsonResponse['teacher_id'] = jsonResponse['teacher_id'] ?? teacherId;
        final newSlot = TimeSlot.fromJson(jsonResponse);


        dateTimeSlots.update(
          formattedDate,
              (value) => [...value, newSlot],
          ifAbsent: () => [newSlot],
        );
        Get.snackbar('Success', 'Time slot added successfully!');
      } else {
        final errorMessage = response.body.isNotEmpty
            ? (jsonDecode(response.body)['message'] ?? 'Failed to add time slot')
            : 'Failed to add time slot, possibly due to overlapping slots';

        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {

      Get.snackbar('Error', 'Error adding time slot: $e');
    } finally {
      isLoading.value = false;

    }
  }

  // Delete a time slot
  Future<void> deleteTimeSlot(String formattedDate, String id) async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/time-slots/delete/$id');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };



      final response = await http.delete(url, headers: headers);



      if (response.statusCode == 200) {

        dateTimeSlots.update(
          formattedDate,
              (slots) => slots.where((slot) => slot.id != id).toList(),
        );
        Get.snackbar('Success', 'Time slot deleted successfully!');
      } else {

        Get.snackbar('Error', 'Failed to delete time slot: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {

      Get.snackbar('Error', 'Error deleting time slot: $e');
    } finally {
      isLoading.value = false;

    }
  }
}