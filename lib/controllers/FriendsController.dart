import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class FriendsController extends GetxController {
  // Observable lists for users and friends
  var users = <dynamic>[].obs;
  var friends = <dynamic>[].obs;
  var displayedList = <dynamic>[].obs;

  // Observable variables for toggling view and search query
  var isViewingFriends = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Fetch users when the controller initializes
  }


  // Fetch users from the API
  Future<void> fetchUsers() async {
    // Access the token from the UserProvider
    final userProvider = Provider.of<UserProvider>(Get.context!, listen: false);
    final token = userProvider.token; // Retrieve the token

    const url = 'http://10.0.2.2:3001/api/auth/users';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add Authorization header
        },
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

  // Toggle between users and friends view
  void toggleView() {
    isViewingFriends.value = !isViewingFriends.value;
    updateDisplayedList();
  }

  // Update the displayed list based on toggle and search query
  void updateDisplayedList() {
    final list = isViewingFriends.value ? friends : users;
    displayedList.value = list
        .where((user) => user['email']
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Filter the list based on search query
  void filterList(String query) {
    searchQuery.value = query;
    updateDisplayedList();
  }
}
