import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/user.dart';

class ProfileProvider with ChangeNotifier {
  User? _user;
  Profile? _profile;

  User? get user => _user;
  Profile? get profile => _profile;

  Future<void> fetchProfileData(String token) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/api/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Since your API now returns only profile data,
      // check if the profile exists and create it accordingly
      if (data['profile'] != null) {
        _profile = Profile.fromJson(data['profile']);
        notifyListeners();
      } else {
        throw Exception('Profile data not found');
      }
    } else {
      String message;
      try {
        final errorData = json.decode(response.body);
        message = errorData['message'] ?? 'An error occurred'; // Extract message if available
      } catch (e) {
        message = 'Failed to load profile data'; // Fallback message
      }
      throw Exception(message);
    }
  }

  // Add this method to set the profile data
  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners(); // Notify listeners to rebuild any dependent widgets
  }
}