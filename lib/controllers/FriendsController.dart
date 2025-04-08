import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import '../constants/api_endpoints.dart';
import '../models/FriendRequestModel.dart';
// import '../providers/user_provider.dart';
import 'LoginController.dart';

class FriendsController extends GetxController {
  var users = <dynamic>[].obs;
  var friends = <dynamic>[].obs;
  var displayedList = <dynamic>[].obs;
  var friendRequests = <dynamic>[].obs;
  RxString selectedButton = "friends".obs;

  var isViewingFriends = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Fetch users on init
    fetchFriendRequests(); // Fetch friend requests on init
  }

  // Fetch users from the API
  Future<void> fetchUsers() async {
    final token = Get.find<LoginController>().token.value; // Get token from LoginController

    const url = ApiEndPoints.fetchAllUsers;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        users.value = responseData['data'];
        updateDisplayedList(); // Update the displayed list
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  // Fetch pending friend requests
  Future<void> fetchFriendRequests() async {
    final token = Get.find<LoginController>().token.value; // Get token from LoginController
    final loginController = Get.find<LoginController>(); // Get LoginController instance

    if (loginController.userId.value == 0) {
      Get.snackbar("Error", "User ID is missing", snackPosition: SnackPosition.BOTTOM);
      print("[ERROR] User ID is missing in fetchFriendRequests()");
      return;
    }

    final url = '${ApiEndPoints.getFriendRequest}/${loginController.userId.value}';

    print("[DEBUG] Fetching friend requests...");
    print("[DEBUG] Request URL: $url");
    print("[DEBUG] Request Headers: {'Authorization': 'Bearer $token'}");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("[DEBUG] Response Status Code: ${response.statusCode}");
      print("[DEBUG] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('requests')) {
          friendRequests.value = responseData['requests'];
          print("[SUCCESS] Friend requests fetched successfully. Count: ${friendRequests.length}");
        } else {
          print("[WARNING] 'requests' key not found in response.");
        }

        updateDisplayedList(); // Update the displayed list
      } else {
        print("[ERROR] Failed to load friend requests. Status: ${response.statusCode}");
        print("[ERROR] Response Body: ${response.body}");
      }
    } catch (error) {
      print("[ERROR] Exception while fetching friend requests: $error");
    }
  }


  void updateDisplayedList() {
    if (selectedButton.value == "friends") {
      displayedList.value = friends;
    } else if (selectedButton.value == "pending_requests") {
      displayedList.value = friendRequests; // Show pending requests
    } else {
      displayedList.value = users; // Default to all users
    }

  // // Apply search filter with null check
  // displayedList.value = displayedList.value.where((user) {
  //   final email = user['email'];
  //   return email != null &&
  //       email.toString().toLowerCase().contains(searchQuery.value.toLowerCase());
  // }).toList();
}

  // Filter list based on search query
  void filterList(String query) {
    searchQuery.value = query;
    updateDisplayedList(); // Update displayed list after filtering
  }

  // Send a friend request to a user
  Future<void> sendFriendRequest(int senderId, int receiverId) async {
    final token = Get.find<LoginController>().token.value; // Get token from LoginController

    const url = ApiEndPoints.sendFriendRequest;

    final data = {
      'sender_id': senderId,
      'receiver_id': receiverId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print('Friend request sent successfully');
      } else {
        throw Exception('Failed to send friend request');
      }
    } catch (error) {
      print('Error sending friend request: $error');
    }
  }
}
