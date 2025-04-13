import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import '../models/TimeslotModel.dart';

class AppointmentController extends GetxController {
  static const String baseUrl = '${ApiEndPoints.baseUrl}'; // Replace with your backend URL
  var selectedDate = DateTime.now().obs;
  var dateTimeSlots = <String, List<TimeSlot>>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('AppointmentController initialized, fetching time slots...');
    fetchTimeSlots();
  }

  // Select a date and fetch slots
  void selectDate(DateTime date) {
    selectedDate.value = date;
    print('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
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
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      };

      print('Fetching time slots from: $url');
      print('Headers: $headers');
      print('Token: ${token}');

      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Decoding JSON response...');
        final List<dynamic> slotData = json.decode(response.body);

        print('Decoded response: $slotData');

        if (slotData.isNotEmpty) {
          print('Found ${slotData.length} time slots in response');

          final slotsForSelectedDate = slotData
              .map((slot) => TimeSlot.fromJson(slot))
              .where((slot) =>
          DateFormat('yyyy-MM-dd').format(slot.startTime) == formattedDate)
              .toList();

          dateTimeSlots[formattedDate] = slotsForSelectedDate;

          print('Filtered and stored ${slotsForSelectedDate.length} slots for $formattedDate');
        } else {
          print('No time slots found for $formattedDate');
          dateTimeSlots[formattedDate] = [];
          Get.snackbar('Info', 'No time slots found for selected date');
        }


      } else {
        print('Failed to fetch time slots - Status: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch time slots: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception in fetchTimeSlots: $e');
      Get.snackbar('Error', 'An error occurred while fetching time slots: $e');
    } finally {
      isLoading.value = false;
      print('fetchTimeSlots completed, isLoading: ${isLoading.value}');
    }
  }

  // Add a new time slot
  Future<void> addTimeSlot(DateTime startTime, DateTime endTime) async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;

    try {
      isLoading.value = true;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final slotCount = dateTimeSlots[formattedDate]?.length ?? 0;

      if (slotCount >= 10) {
        print('addTimeSlot: Maximum 10 slots reached for $formattedDate');
        Get.snackbar('Maximum Reached', 'Maximum 10 time slots allowed per day');
        return;
      }

      final url = Uri.parse('$baseUrl/api/timeSlots/create');
      final headers = {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      };
      final body = {
        'date': formattedDate,
        'start_time': DateFormat('HH:mm:ss').format(startTime),
        'end_time': DateFormat('HH:mm:ss').format(endTime),
      };

      print('Posting time slot to: $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Decoding JSON response...');
        final newSlot = TimeSlot.fromJson(jsonDecode(response.body));
        print('New slot added: ${newSlot.toJson()}');

        dateTimeSlots.update(
          formattedDate,
              (value) => [...value, newSlot],
          ifAbsent: () => [newSlot],
        );
        Get.snackbar('Success', 'Time slot added successfully!');
      } else {
        print('Failed to add time slot - Status: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to add time slot: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception in addTimeSlot: $e');
      Get.snackbar('Error', 'Error adding time slot: $e');
    } finally {
      isLoading.value = false;
      print('addTimeSlot completed, isLoading: ${isLoading.value}');
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
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      };

      print('Deleting time slot at: $url');
      print('Headers: $headers');
      print('Token: ${token}');

      final response = await http.delete(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Time slot $id deleted successfully');
        dateTimeSlots.update(
          formattedDate,
              (slots) => slots.where((slot) => slot.id != id).toList(),
        );
        Get.snackbar('Success', 'Time slot deleted successfully!');
      } else {
        print('Failed to delete time slot - Status: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to delete time slot: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception in deleteTimeSlot: $e');
      Get.snackbar('Error', 'Error deleting time slot: $e');
    } finally {
      isLoading.value = false;
      print('deleteTimeSlot completed, isLoading: ${isLoading.value}');
    }
  }
}