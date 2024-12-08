import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import '../controllers/blogController.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart'; // For accessing token

class BlogPostPage extends StatefulWidget {
  const BlogPostPage({super.key});

  @override
  State<BlogPostPage> createState() => _BlogPostingPageState();
}

class _BlogPostingPageState extends State<BlogPostPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.token != null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .fetchProfileData(userProvider.token!);
    }
  }

  final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context).user;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    final profile = Provider.of<ProfileProvider>(context).profile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          'Create Post',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black), // Cross icon
          onPressed: () {
            Get.back(); // Navigates back to the previous page
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Height of the border
          child: Container(
            color: Colors.grey, // Border color
            height: 0.2, // Thickness of the border
          ),
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
                  backgroundImage: profile != null &&
                      profile.profileImageUrl != null
                      ? NetworkImage(profile.profileImageUrl!)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                  // Fallback image
                  backgroundColor:
                  Colors.grey.shade200, // Background color if no image
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
                        height: Get.height * 0.4,
                        // Half of the screen height using GetX
                        child: Obx(() => TextField(
                              controller: blogController.descriptionController,
                              decoration: InputDecoration(
                                labelText: blogController.labelText.value,
                                // Dynamic label
                                alignLabelWithHint: true,
                                // Keeps label at the top
                                border: InputBorder.none,
                                // Removes the border
                                contentPadding: EdgeInsets.all(
                                    16), // Adds padding inside the TextField
                              ),
                              onChanged: (value) {
                                blogController.onTextFieldChange(value);
                              },
                              maxLines: null, // Allow multiple lines
                            )),
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() => blogController.images.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 20),
                            child: Wrap(
                              spacing: 10, // Space between images
                              runSpacing: 10, // Space between rows
                              children: blogController.images
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index =
                                    entry.key; // Get the index of the image
                                var image = entry.value; // Get the image object
                                return SizedBox(
                                  width: (Get.width - 30) / 2,
                                  // Half of the screen width minus spacing
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        File(image.path),
                                        height: (Get.width - 30) / 2,
                                        // Maintain square aspect ratio
                                        width: (Get.width - 30) / 2,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            blogController.images.removeAt(
                                                index); // Remove the image
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : Container()),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () => blogController.pickImages(),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide.none, // Removes the border
                            ),
                            child: Text('+ Add images', style: TextStyle(color: Colors.grey[550], fontSize: 17),),
                          )
                        ],
                      ),
                    ),
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
