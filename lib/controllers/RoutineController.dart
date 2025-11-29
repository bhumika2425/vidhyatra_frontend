
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
// import 'dart:convert';
// import 'package:vidhyatra_flutter/controllers/LoginController.dart';
//
// import '../models/RoutineModel.dart';
//
// class RoutineController extends GetxController {
//   final LoginController loginController = Get.find<LoginController>();
//   var routineByDay = Rx<RoutineByDay?>(null);
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRoutines();
//   }
//
//   Future<void> fetchRoutines() async {
//     try {
//       isLoading(true);
//       errorMessage('');
//       final token = loginController.token.value;
//       if (token.isEmpty) {
//         errorMessage('No authentication token found');
//         isLoading(false);
//         return;
//       }
//
//       final response = await http.get(
//         Uri.parse('${ApiEndPoints.baseUrl}/api/routines/my-routine'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         routineByDay.value = RoutineByDay.fromJson(data);
//       } else {
//         errorMessage('Failed to fetch routine: ${response.statusCode}');
//       }
//     } catch (e) {
//       errorMessage('Error fetching routine: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   List<RoutineEntry> getTodayRoutine() {
//     if (routineByDay.value == null) return [];
//     final today = DateTime.now().weekday;
//     final dayName = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Sunday',
//     ][today % 7]; // Adjust for Sunday as index 6
//     return routineByDay.value!.routinesByDay[dayName] ?? [];
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
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

  Future<void> fetchRoutines() async { //Defines an asynchronous method to fetch routine data
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
          //Sends a GET request to the routine API with the token in the Authorization header
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if there's a message indicating no routine yet
        if (data['message'] != null && data['message'].toString().contains('not created yet')) {
          errorMessage(data['message']);
          routineByDay.value = null;
        } else if (data['message'] != null && data['message'].toString().contains('not available yet')) {
          errorMessage(data['message']);
          routineByDay.value = null;
        } else {
          routineByDay.value = RoutineByDay.fromJson(data);
        }
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage('Failed to fetch routine: ${errorData['message'] ?? response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error fetching routine: $e');
    } finally {
      isLoading(false);
    }
  }

  List<RoutineEntry> getTodayRoutine() {
    if (routineByDay.value == null) return [];
    
    final today = DateTime.now().weekday; // 1=Monday, 7=Sunday
    
    // Map weekday to day name
    String dayName;
    switch (today) {
      case 1:
        dayName = 'Monday';
        break;
      case 2:
        dayName = 'Tuesday';
        break;
      case 3:
        dayName = 'Wednesday';
        break;
      case 4:
        dayName = 'Thursday';
        break;
      case 5:
        dayName = 'Friday';
        break;
      case 6:
        dayName = 'Saturday';
        break;
      case 7:
        dayName = 'Sunday';
        break;
      default:
        dayName = 'Monday';
    }
    
    print('🔍 getTodayRoutine: today=$today, dayName=$dayName');
    
    return routineByDay.value!.routinesByDay[dayName] ?? [];
  }
}
