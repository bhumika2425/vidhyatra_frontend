import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import '../constants/api_endpoints.dart';
import '../models/FriendRequestModel.dart';
import '../providers/user_provider.dart';
import 'LoginController.dart';

class FriendsController extends GetxController {
  var users = <dynamic>[].obs;
  var friends = <dynamic>[].obs;
  var displayedList = <dynamic>[].obs;
  var friendRequests = <dynamic>[].obs;

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


    const url = 'http://localhost:3001/api/friendRequest/friend-requests';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        friendRequests.value = responseData['requests'];
        updateDisplayedList(); // Update the displayed list
      } else {
        throw Exception('Failed to load friend requests');
      }
    } catch (error) {
      print('Error fetching friend requests: $error');
    }
  }

  // Update displayed list based on the current view
  void updateDisplayedList() {
    if (isViewingFriends.value) {
      displayedList.value = friends;
    } else if (friendRequests.isNotEmpty) {
      displayedList.value = friendRequests; // Show pending requests if available
    } else {
      displayedList.value = users; // Default to all users
    }

    displayedList.value = displayedList.value
        .where((user) => user['email']
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase()))
        .toList();
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
