import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/models/blogModel.dart';

import '../providers/user_provider.dart';

class BlogController extends GetxController {
  final descriptionController = TextEditingController();
  RxString labelText =
      'Tell your story with us.....'.obs; // Observable for label text
  RxBool isButtonEnabled = false.obs;
  final ImagePicker picker = ImagePicker();
  var images = <XFile>[].obs;

  // Blog list observable
  var blogs = <Blog>[].obs; // Define blogs as an observable list
  var isLoading = true.obs;

  void onTextFieldChange(String value) {
    labelText.value = value.isNotEmpty ? '' : 'Tell your story with us.....';
    isButtonEnabled.value =
        value.isNotEmpty; // Enable button when text is not empty
  }

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles =
        await picker.pickMultiImage(); // Allows multiple image selection
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      images.addAll(pickedFiles); // Add all selected images to the list
    }
  }

  Future<void> postBlog(String token) async {
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Description are required");
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(ApiEndPoints.postBlogs);

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['blog_description'] = descriptionController.text;

      // Add images to the request
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Must match your multer field name
          image.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        descriptionController.clear();
        images.clear();
        Get.back();
        // Fetch blogs again after posting the new one
        fetchBlogs(token);
        Get.snackbar("Success", "Blog posted successfully!");
      } else {
        Get.snackbar("Error", "Failed to post blog");
      }
    } catch (e) {
      Get.snackbar("Error", "Error posting blog: $e");
      print('$e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch blogs
  Future<void> fetchBlogs(String token) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(ApiEndPoints.getAllBlogs ),
        headers: {
          "Authorization": 'Bearer $token', // Replace with user's token
        },
      );

      if (response.statusCode == 200) {
        final blogData = json.decode(response.body);

        // Debugging: Print the entire response data
        print("Decoded response: $blogData");

        // Check if the response is an empty list or contains the expected data
        if (blogData != null && blogData['blogs'] != null) {
          // Parse the list of blogs
          blogs.value = List<Blog>.from(
            blogData['blogs'].map((blog) => Blog.fromJson(blog)),
          );

          for (var blog in blogs) {
            print(blog.toJson());
          }
        } else {
          print("No blogs found or missing data in the response.");
          Get.snackbar("Error", "No blogs found");
        }
      } else {
        // Handle error based on response status
        Get.snackbar("Error", "Failed to fetch blogs: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Log the error and show a snackbar
      Get.snackbar("Error", "An error occurred: $e");
      print("Error: $e");
    } finally {
      // Stop the loading indicator once the response is processed
      isLoading.value = false;
    }
  }

  // @override
  // void onInit() {
  //   fetchBlogs();
  //   super.onInit();
  // }
  @override
  void onInit() {
    super.onInit();

    // Access the token using Provider.of(context) inside your widget tree
    final token = Get.context != null
        ? Provider.of<UserProvider>(Get.context!, listen: false).token
        : null;

    if (token != null) {

      fetchBlogs(token); // Pass the token to fetchBlogs
    } else {
      print("Error: Token not found");
      Get.snackbar("Error", "Token is missing. Please log in again.");
    }
  }
}
