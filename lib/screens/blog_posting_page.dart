import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/blogController.dart';
import '../providers/user_provider.dart'; // For accessing token

class BlogPostPage extends StatelessWidget {
  final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(color: Colors.red),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.red), // Close icon
          onPressed: () => Get.back(), // Navigates back
        ),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: blogController.isButtonEnabled.value
                  ? () {
                if (token != null) {
                  blogController.postBlog(token);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Token not found!')),
                  );
                }
              }
                  : null,
              style: TextButton.styleFrom(
                backgroundColor: blogController.isButtonEnabled.value
                    ? Colors.red
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Post'),
            ),
          )),
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    user?.profileImage ?? 'https://via.placeholder.com/150', // Fallback URL
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    user?.name ?? 'Guest User', // Fallback name
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Handles long names
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: SizedBox(
                        height: Get.height * 0.5,
                        child: Obx(() => TextField(
                          controller: blogController.descriptionController,
                          decoration: InputDecoration(
                            labelText: blogController.labelText.value,
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            blogController.onTextFieldChange(value);
                          },
                          maxLines: null,
                        )),
                      ),
                    ),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Blog Image (Optional)',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => blogController.pickImages(),
                          child: Text('Pick Image'),
                        ),
                      ],
                    ),
                    Obx(() => blogController.images.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: blogController.images.map((image) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        : SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
