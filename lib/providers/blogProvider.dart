
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/providers/user_provider.dart';
import 'dart:convert';
import '../models/blogModel.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  bool _isLoading = false;

  List<Blog> get blogs => _blogs;
  bool get isLoading => _isLoading;

  Future<void> fetchBlogs(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Access UserProvider to get the token
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null) {
      print("Token not found. Please log in again.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    final url = 'http://10.0.2.2:3001/api/blog/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> blogData = json.decode(response.body);
        _blogs = blogData.map((json) => Blog.fromJson(json)).toList();
      } else {
        print('Failed to load blogs');
      }
    } catch (error) {
      print('Error fetching blogs: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}