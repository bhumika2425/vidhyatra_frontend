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

  final LoginController loginController = Get
      .find(); // Fetch the LoginController

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
    if (descriptionController.text.trim().isEmpty) {
      print("Empty blog detected - showing snack bar");
      Get.snackbar("Error", "Blog post cannot be empty");
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
        ..headers['Authorization'] = 'Bearer ${loginController.token.value}'
        ..fields['blog_description'] = descriptionController.text;

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
        ));
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        descriptionController.clear();
        images.clear();
        Get.back();
        fetchBlogs();
        Get.snackbar("Success", "Blog posted successfully!");
      } else {
        Get.snackbar("Error", "Failed to post blog: $respStr");
      }
    } catch (e) {
      Get.snackbar("Error", "Error posting blog: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBlogs() async {
    if (loginController.token.value.isEmpty) {
      // print('fetchBlogs: Token is empty');
      Get.snackbar("Error", "You need to log in first.");
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse(ApiEndPoints.getAllBlogs);
      final headers = {
        "Authorization": 'Bearer ${loginController.token.value}',
      };

      // print('Fetching blogs from: $url');
      // print('Headers: $headers');
      // print('Token: ${loginController.token.value}');

      final response = await http.get(url, headers: headers);

      // print('Response status: ${response.statusCode}');
      // print('Response headers: ${response.headers}');
      // print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // print('Decoding JSON response...');
        final blogData = json.decode(response.body);

        // print('Decoded response: $blogData');

        if (blogData != null && blogData['blogs'] != null) {
          // print('Found ${blogData['blogs'].length} blogs in response');
          blogs.value = List<Blog>.from(
            blogData['blogs'].map((blog) {
              // print('Parsing blog: $blog');
              return Blog.fromJson(blog);
            }),
          );
          // print('Successfully parsed ${blogs.length} blogs');
        } else {
          // print('No blogs found in response or data is null');
          Get.snackbar("Error", "No blogs found");
        }
      } else {
        // print('Failed to fetch blogs - Status: ${response.statusCode}');
        Get.snackbar("Error",
            "Failed to fetch blogs: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // print('Exception in fetchBlogs: $e');
      Get.snackbar("Error", "An error occurred while fetching blogs: $e");
    } finally {
      isLoading.value = false;
      // print('fetchBlogs completed, isLoading: ${isLoading.value}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // print('BlogController initialized, fetching blogs...');
    fetchBlogs();
  }
}