import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import 'package:vidhyatra_flutter/models/blogModel.dart';

import 'LoginController.dart'; // Add import

class BlogController extends GetxController {
  final descriptionController = TextEditingController();
  RxString labelText = 'Share your thoughts'.obs;
  RxBool isButtonEnabled = false.obs;
  final ImagePicker picker = ImagePicker();
  var images = <XFile>[].obs;

  var blogs = <Blog>[].obs;
  var isLoading = true.obs;

  // BlogController initialization
  final LoginController loginController = Get.find(); // Fetch the LoginController

  void onTextFieldChange(String value) {
    labelText.value = value.isNotEmpty ? '' : 'Share your thoughts';
    isButtonEnabled.value = value.isNotEmpty;
  }

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      images.addAll(pickedFiles);
    }
  }

  Future<void> postBlog() async {
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Description is required");
      return;
    }

    if (loginController.token.value.isEmpty) {
      Get.snackbar("Error", "You need to log in first.");
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(ApiEndPoints.postBlogs);

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${loginController.token.value}' // Use token from LoginController
        ..fields['blog_description'] = descriptionController.text;

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
        ));
      }

      var response = await request.send();

// Read the response body as string
      final respStr = await response.stream.bytesToString();
      print("Response status: ${response.statusCode}");
      print("Response body: $respStr");

      if (response.statusCode == 201) {
        descriptionController.clear();
        images.clear();
        Get.back();
        fetchBlogs(); // Fetch blogs again after posting the new one
        Get.snackbar("Success", "Blog posted successfully!");
      } else {
        Get.snackbar("Error", "Failed to post blog: $respStr");
      }

    } catch (e) {
      Get.snackbar("Error", "Error posting blog: $e");
      print('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBlogs() async {
    if (loginController.token.value.isEmpty) {
      Get.snackbar("Error", "You need to log in first.");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(ApiEndPoints.getAllBlogs),
        headers: {
          "Authorization": 'Bearer ${loginController.token.value}', // Use token from LoginController
        },
      );

      if (response.statusCode == 200) {
        final blogData = json.decode(response.body);

        if (blogData != null && blogData['blogs'] != null) {
          blogs.value = List<Blog>.from(
            blogData['blogs'].map((blog) => Blog.fromJson(blog)),
          );
        } else {
          Get.snackbar("Error", "No blogs found");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch blogs: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBlogs(); // Fetch blogs on init
  }
}
