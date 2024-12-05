import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/blogModel.dart';

class BlogController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  var images = <XFile>[].obs;
  var isLoading = false.obs;
  var blogs = <Blog>[].obs;  // Observable list to store blogs

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage(); // Allows multiple image selection
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      images.addAll(pickedFiles); // Add all selected images to the list
    }
  }

  Future<void> postBlog(String token) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Title and description are required");
      return;
    }

    isLoading.value = true;
    final url = Uri.parse('http://10.0.2.2:3001/api/blog/post');

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['blog_title'] = titleController.text
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
        titleController.clear();
        descriptionController.clear();
        images.clear();
        Get.back();
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

  Future<void> getBlogs(String token) async {
    final url = Uri.parse('http://10.0.2.2:3001/api/blogs/all');  // API endpoint for getting blogs

    try {
      isLoading.value = true;
      print('Fetching blogs from: $url'); // Debugging the URL

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Check the status code of the response
      print('Response status: ${response.statusCode}'); // Debugging status code

      // If the response is successful
      if (response.statusCode == 200) {
        List<dynamic> blogList = json.decode(response.body);

        print('Response body: ${response.body}'); // Debugging response body

        if (blogList.isNotEmpty) {
          blogs.value = blogList.map((e) => Blog.fromJson(e)).toList();
          print('Blogs fetched: ${blogs.length}'); // Debugging number of blogs fetched
        } else {
          Get.snackbar("Info", "No blogs available.");
        }
      } else {
        print('Failed to fetch blogs. Status code: ${response.statusCode}'); // Debugging if request fails
        Get.snackbar("Error", "Failed to load blogs");
      }
    } catch (e) {
      print('Error fetching blogs: $e'); // Debugging error during fetch
      Get.snackbar("Error", "Error fetching blogs: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
