import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/models/blogModel.dart';

class BlogController extends GetxController {
  final descriptionController = TextEditingController();
  RxString labelText =
      'Tell your story with us.....'.obs; // Observable for label text
  RxBool isButtonEnabled = false.obs;
  final ImagePicker picker = ImagePicker();
  var images = <XFile>[].obs;

  // Blog list observable
  var blogs = <Blog>[].obs; // Corrected the type to a list of blogs
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
    final url = Uri.parse('http://10.0.2.2:3001/api/blog/post');

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

      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/api/blog/all'), headers: {
        "Authorization": 'Bearer $token' // Replace with user's token
      });
      print("${response.body}");

      if (response.statusCode == 200) {
        final blogData = json.decode(response.body);

        if (blogData['blogs'] != null) {
          blogs.value = (blogData['blogs'] as List)
              .map((blogJson) => Blog.fromJson(blogJson))
              .toList();
        } else {
          Get.snackbar("Error", "No blogs found.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch blogs: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      print("$e");
    } finally {
      isLoading.value = false;
    }
  }
// @override
// void onInit() {
//   fetchBlogs();
//   super.onInit();
// }
}
