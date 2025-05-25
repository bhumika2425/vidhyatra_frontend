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

    try { //Gets the stored login token from the LoginController
      final url = Uri.parse('$baseUrl/api/appointments/student');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      //Prepares the GET request with authorization header
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) { //Makes the HTTP call
        final List<dynamic> appointmentData = json.decode(response.body);
        studentAppointments.assignAll(
          appointmentData.map((json) => Appointment.fromJson(json)).toList(),
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch appointments: ${response.statusCode}');
        studentAppointments.clear();
      }
    } catch (e) {

      Get.snackbar('Error', 'Error fetching appointments: $e');
      studentAppointments.clear();
    }
  }
  void bookAppointment({
    //Function to book an appointment for the selected slot
    required Map<String, dynamic> slot,
    required BuildContext context,
    required Map<String, dynamic> teacher,
  }) async {
    //Accesses controllers and retrieves the login token
    final TeacherAvailableSlotsController teacherAvailableSlotsController = Get.find();
    final TeacherListController teacherListController = Get.find();
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    const baseUrl = ApiEndPoints.baseUrl;

    try {
      isSubmitting.value = true;

      final slotId = slot['slot_id'];
      if (slotId == null) {
        Get.snackbar(
          'Error',
          'Invalid slot ID',

        );
        return;
      }

      // Validate reason before making the API call
      if (reasonController.text.trim().isEmpty) {
        Get.snackbar(
          'Booking Failed',
          'Please provide a reason for the appointment',

        );
        return;
      }

      final url = Uri.parse('$baseUrl/api/appointments/book');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'slot_id': slotId,
        'reason': reasonController.text.trim(),
      });

      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Appointment booked successfully',);
        //Calls methods to refresh data
        teacherAvailableSlotsController.fetchAvailableSlots();
        teacherListController.fetchTeachers();
        fetchStudentAppointments();
        Navigator.pop(context);
      } else {
        // Handle different error cases based on response message
        String errorMessage = responseData['message'] ?? 'Failed to book appointment';

        switch (errorMessage) {
          case 'Time slot not found':
            errorMessage = 'This time slot is no longer available';
            break;
          case 'This time slot is already booked':
            errorMessage = 'Sorry, this slot has already been booked by someone else';
            break;
          case 'Cannot book a time slot in the past':
            errorMessage = 'Cannot book past time slots';
            break;
          case 'Please provide a reason for the appointment':
            errorMessage = 'Please enter a reason for your appointment';
            break;
          case 'Only students can book appointments':
            errorMessage = 'Only students are allowed to book appointments';
            break;
        }

        Get.snackbar(
          'Booking Failed',
          errorMessage,

        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while booking the appointment',
      );
    } finally {
      isSubmitting.value = false;
    }
  }


  // void bookAppointment({
  //   required Map<String, dynamic> slot,
  //   required BuildContext context,
  //   required Map<String, dynamic> teacher,
  // }) async {
  //   final TeacherAvailableSlotsController teacherAvailableSlotsController = Get.find();
  //   final TeacherListController teacherListController = Get.find();
  //   final LoginController loginController = Get.find();
  //   final token = loginController.token.value;
  //   const baseUrl = ApiEndPoints.baseUrl;
  //
  //   try {
  //     isSubmitting.value = true;
  //
  //     final slotId = slot['slot_id'];
  //     if (slotId == null) {
  //
  //       Get.snackbar('Error', 'Invalid slot ID');
  //       return;
  //     }
  //
  //     final url = Uri.parse('$baseUrl/api/appointments/book');
  //     final headers = {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     };
  //     final body = json.encode({
  //       'slot_id': slotId,
  //       'reason': reasonController.text,
  //     });
  //
  //
  //
  //     final response = await http.post(url, headers: headers, body: body);
  //
  //
  //     if (response.statusCode == 201) {
  //       Get.snackbar('Success', 'Appointment booked successfully');
  //       teacherAvailableSlotsController.fetchAvailableSlots();
  //       teacherListController.fetchTeachers();
  //       fetchStudentAppointments();
  //       Navigator.pop(context); // Return to TeacherAvailableSlotsScreen
  //       // Navigator.pop(context);
  //     } else {
  //       Get.snackbar('Booking Failed', 'Failed to book appointment, please enter reason for appointment ');
  //     }
  //   } catch (e) {
  //
  //     Get.snackbar('Error', 'Error booking appointment: $e');
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
}