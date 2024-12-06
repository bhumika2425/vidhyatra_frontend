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
          icon: Icon(Icons.close, color: Colors.red), // Cross icon
          onPressed: () {
            Get.back(); // Navigates back to the previous page
          },
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: blogController.isButtonEnabled.value
                      ? () {
                          // Call the postBlog function with the required token
                          // String token = ''; // Replace with your actual token
                          blogController.postBlog(token!);
                        }
                      : null, // Disable button when text is empty
                  style: TextButton.styleFrom(
                    backgroundColor: blogController.isButtonEnabled.value
                        ? Colors.red
                        : Colors.grey[200],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
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
                  radius: 30, // Adjust the size of the avatar
                  backgroundImage: NetworkImage(
                    'https://example.com/profile.jpg', // Replace with actual profile image URL
                  ),
                  backgroundColor: Colors.grey[200], // Fallback color
                ),
                SizedBox(width: 16), // Space between avatar and username
                Text(
                  '${user?.name}', // Update greeting with fetched name
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                      child: SizedBox(
                        height: Get.height * 0.5, // Half of the screen height using GetX
                        child: Obx(() => TextField(
                          controller: blogController.descriptionController,
                          decoration: InputDecoration(
                            labelText: blogController.labelText.value, // Dynamic label
                            alignLabelWithHint: true, // Keeps label at the top
                            border: InputBorder.none, // Removes the border
                            contentPadding: EdgeInsets.all(16), // Adds padding inside the TextField
                          ),
                          onChanged: (value) {
                            blogController.onTextFieldChange(value);
                          },
                          maxLines: null, // Allow multiple lines
                        )),
                      ),
                    ),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Blog Image (Optional)',
                            style: TextStyle(fontSize: 16)),
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
                                return Image.file(
                                  File(image.path),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                );
                              }).toList(),
                            ),
                          )
                        : Container()),
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
