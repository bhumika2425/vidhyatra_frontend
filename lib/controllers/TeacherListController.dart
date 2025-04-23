// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
// import 'package:vidhyatra_flutter/controllers/LoginController.dart';
//
// class TeacherListController extends GetxController {
//   final RxBool isLoading = true.obs;
//   final RxString searchQuery = ''.obs;
//   final RxString selectedDepartment = 'All Departments'.obs;
//   final RxList<Map<String, dynamic>> teachers = <Map<String, dynamic>>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchTeachers();
//   }
//
//   // Fetch teachers from the API
//   Future<void> fetchTeachers() async {
//     final LoginController loginController = Get.find();
//     final token = loginController.token.value;
//     const baseUrl = ApiEndPoints.baseUrl;
//
//     try {
//       isLoading.value = true;
//
//       final url = Uri.parse('$baseUrl/api/appointments/teachers');
//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         final List<dynamic> teacherData = json.decode(response.body);
//         teachers.assignAll(teacherData.map((teacher) {
//           final imageIndex = teacherData.indexOf(teacher) % 5 + 1;
//           return {
//             'user_id': teacher['user_id'],
//             'name': teacher['name'],
//             'department': 'Unknown', // Placeholder, update if API provides department
//             'available': teacher['availableTimeSlots'] > 0,
//             'image': 'assets/teacher$imageIndex.png',
//             'appointmentsBooked':
//             teacher['totalTimeSlots'] - teacher['availableTimeSlots'],
//             'totalTimeSlots': teacher['totalTimeSlots'],
//           };
//         }).toList());
//       } else {
//         Get.snackbar('Error', 'Failed to fetch teachers: ${response.statusCode}');
//         teachers.clear();
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Error fetching teachers: $e');
//       teachers.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Filtered teachers list
//   List<Map<String, dynamic>> getFilteredTeachers() {
//     List<Map<String, dynamic>> filteredTeachers = teachers;
//
//     // Apply search filter
//     if (searchQuery.isNotEmpty) {
//       filteredTeachers = filteredTeachers
//           .where((teacher) => teacher['name']
//           .toString()
//           .toLowerCase()
//           .contains(searchQuery.value.toLowerCase()))
//           .toList();
//     }
//
//     // Apply department filter
//     if (selectedDepartment.value != 'All Departments') {
//       filteredTeachers = filteredTeachers
//           .where(
//               (teacher) => teacher['department'] == selectedDepartment.value)
//           .toList();
//     }
//
//     return filteredTeachers;
//   }
//
//   // Update search query
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//   }
//
//   // Update selected department
//   void updateDepartment(String department) {
//     selectedDepartment.value = department;
//   }
//
//   // Clear search
//   void clearSearch() {
//     searchQuery.value = '';
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

class TeacherListController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedDepartment = 'All Departments'.obs;
  final RxList<Map<String, dynamic>> teachers = <Map<String, dynamic>>[].obs;
  final RxBool isSearchActive = false.obs; // Added to toggle search mode

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  // Fetch teachers from the API
  Future<void> fetchTeachers() async {
    final LoginController loginController = Get.find();
    final token = loginController.token.value;
    const baseUrl = ApiEndPoints.baseUrl;

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/api/appointments/teachers');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> teacherData = json.decode(response.body);
        teachers.assignAll(teacherData.map((teacher) {
          final imageIndex = teacherData.indexOf(teacher) % 5 + 1;
          return {
            'user_id': teacher['user_id'],
            'name': teacher['name'],
            'department': 'BIT',
            'available': teacher['availableTimeSlots'] > 0,
            'image': 'assets/teacher$imageIndex.png',
            'appointmentsBooked': teacher['totalTimeSlots'] - teacher['availableTimeSlots'],
            'totalTimeSlots': teacher['totalTimeSlots'],
          };
        }).toList());
      } else {
        Get.snackbar('Error', 'Failed to fetch teachers: ${response.statusCode}');
        teachers.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching teachers: $e');
      teachers.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Filtered teachers list
  List<Map<String, dynamic>> getFilteredTeachers() {
    List<Map<String, dynamic>> filteredTeachers = teachers;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredTeachers = filteredTeachers
          .where((teacher) => teacher['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply department filter
    if (selectedDepartment.value != 'All Departments') {
      filteredTeachers = filteredTeachers
          .where((teacher) => teacher['department'] == selectedDepartment.value)
          .toList();
    }

    return filteredTeachers;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Update selected department
  void updateDepartment(String department) {
    selectedDepartment.value = department;
  }

  // Toggle search mode
  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      clearSearch();
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }
}