import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/controllers/TeacherAvailableSlotController.dart';
import 'package:vidhyatra_flutter/controllers/TeacherListController.dart';

import '../models/AppointmentModel.dart';

class AppointmentBookingController extends GetxController {
  final TextEditingController reasonController = TextEditingController();
  final RxBool isSubmitting = false.obs;
  final RxList<Appointment> studentAppointments = <Appointment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudentAppointments();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  // Fetch student's booked appointments
  Future<void> fetchStudentAppointments() async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    const baseUrl = ApiEndPoints.baseUrl;

    try {
      final url = Uri.parse('$baseUrl/api/appointments/student');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      print('Fetching Appointments URL: $url'); // Debug
      print('Fetching Headers: $headers'); // Debug

      final response = await http.get(url, headers: headers);

      print('Appointments Response Status: ${response.statusCode}'); // Debug
      print('Appointments Response Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final List<dynamic> appointmentData = json.decode(response.body);
        studentAppointments.assignAll(
          appointmentData.map((json) => Appointment.fromJson(json)).toList(),
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch appointments: ${response.statusCode}');
        studentAppointments.clear();
      }
    } catch (e) {
      print('Fetch Appointments Exception: $e'); // Debug
      Get.snackbar('Error', 'Error fetching appointments: $e');
      studentAppointments.clear();
    }
  }

  void bookAppointment({
    required Map<String, dynamic> slot,
    required BuildContext context,
    required Map<String, dynamic> teacher,
  }) async {
    final TeacherAvailableSlotsController teacherAvailableSlotsController = Get.find();
    final TeacherListController teacherListController = Get.find();
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    const baseUrl = ApiEndPoints.baseUrl;

    try {
      isSubmitting.value = true;

      final slotId = slot['slot_id'];
      if (slotId == null) {
        print('Error: slot_id is null'); // Debug
        Get.snackbar('Error', 'Invalid slot ID');
        return;
      }

      final url = Uri.parse('$baseUrl/api/appointments/book');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'slot_id': slotId,
        'reason': reasonController.text,
      });

      print('Booking Request URL: $url'); // Debug
      print('Booking Request Body: $body'); // Debug
      print('Booking Headers: $headers'); // Debug

      final response = await http.post(url, headers: headers, body: body);

      print('Booking Response Status: ${response.statusCode}'); // Debug
      print('Booking Response Body: ${response.body}'); // Debug

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Appointment booked successfully');
        teacherAvailableSlotsController.fetchAvailableSlots();
        teacherListController.fetchTeachers();
        fetchStudentAppointments();
        Navigator.pop(context); // Return to TeacherAvailableSlotsScreen
        // Navigator.pop(context);
      } else {
        Get.snackbar('Error', 'Failed to book appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Booking Exception: $e'); // Debug
      Get.snackbar('Error', 'Error booking appointment: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}