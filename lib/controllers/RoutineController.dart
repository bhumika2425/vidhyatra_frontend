import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'dart:convert';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

import '../models/RoutineModel.dart';

class RoutineController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  var routineByDay = Rx<RoutineByDay?>(null);
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRoutines();
  }

  Future<void> fetchRoutines() async {
    try {
      isLoading(true);
      errorMessage('');
      final token = loginController.token.value;
      if (token.isEmpty) {
        errorMessage('No authentication token found');
        isLoading(false);
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}/api/routines/my-routine'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        routineByDay.value = RoutineByDay.fromJson(data);
      } else {
        errorMessage('Failed to fetch routine: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error fetching routine: $e');
    } finally {
      isLoading(false);
    }
  }

  List<RoutineEntry> getTodayRoutine() {
    if (routineByDay.value == null) return [];
    final today = DateTime.now().weekday;
    final dayName = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Sunday',
    ][today % 7]; // Adjust for Sunday as index 6
    return routineByDay.value!.routinesByDay[dayName] ?? [];
  }
}