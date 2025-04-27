import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/LostAndFoundModel.dart';
import 'LoginController.dart';

class LostFoundController extends GetxController {
  final RxList<LostFoundItem> items = <LostFoundItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final ImagePicker imagePicker = ImagePicker();
  final LoginController loginController = Get.find<LoginController>();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${loginController.token.value}',
    'Content-Type': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchLostAndFoundItems();
  }

  Future<void> fetchLostAndFoundItems() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/api/lost-and-found/fetchAll'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(response.body);
        final List<dynamic> itemsJson = data['posts'];
        items.value = itemsJson.map((json) => LostFoundItem.fromJson(json)).toList();
      } else {
        throw 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch items: $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLostFoundItem(LostFoundItem item) async {
    try {
      isLoading.value = true;

      final uri = Uri.parse('http://10.0.2.2:3001/api/lost-and-found/create');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Authorization': _headers['Authorization']!,
      });

      // Add text fields
      request.fields.addAll(
          item.toJson().map((key, value) => MapEntry(key, value.toString()))
      );

      // Add images
      for (var image in selectedImages) {
        final file = await http.MultipartFile.fromPath('images', image.path);
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        await fetchLostAndFoundItems();
        selectedImages.clear();
        Get.back();
        Get.snackbar('Success', 'Item posted successfully');
      } else {
        throw 'Failed to create post: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create item: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLostFoundItem(int id, LostFoundItem item) async {
    try {
      isLoading.value = true;

      final uri = Uri.parse('http://10.0.2.2:3001/api/lost-and-found/updateById/$id');
      final request = http.MultipartRequest('PUT', uri);

      request.headers.addAll({
        'Authorization': _headers['Authorization']!,
      });

      request.fields.addAll(
          item.toJson().map((key, value) => MapEntry(key, value.toString()))
      );

      for (var image in selectedImages) {
        final file = await http.MultipartFile.fromPath('images', image.path);
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await fetchLostAndFoundItems();
        selectedImages.clear();
        Get.back();
        Get.snackbar('Success', 'Item updated successfully');
      } else {
        throw 'Failed to update post: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    } finally {
      isLoading.value = false;
    }}

  Future<void> deleteLostFoundItem(int id) async {
    try {
      isLoading.value = true;

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3001/api/lost-and-found/deleteById/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        await fetchLostAndFoundItems();
        Get.snackbar('Success', 'Item deleted successfully');
      } else {
        throw 'Failed to delete post: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
}