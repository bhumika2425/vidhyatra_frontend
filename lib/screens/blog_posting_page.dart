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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    return Scaffold(
      appBar: AppBar(title: Text('Post a Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: blogController.titleController,
                decoration: InputDecoration(
                  labelText: 'Blog Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a blog title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: blogController.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Blog Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a blog description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Blog Image (Optional)', style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: blogController.isLoading.value
                        ? null
                        : () => blogController.postBlog(token!),
                    child: blogController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Submit Blog'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
