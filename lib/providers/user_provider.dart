
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token; // Add a field to store the token

  User? get user => _user;
  String? get token => _token; // Add a getter to retrieve the token

  bool get hasProfile => _user?.hasProfile ?? false;

  void setUser(User user, String token) {
    _user = user;
    _token = token; // Store the token
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _token = null; // Clear the token on logout
    notifyListeners();
  }
}