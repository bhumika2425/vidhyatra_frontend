import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import '../controllers/ProfileController.dart';
import '../controllers/blogController.dart';

class BlogPostPage extends StatefulWidget {
  const BlogPostPage({super.key});

  @override
  State<BlogPostPage> createState() => _BlogPostingPageState();
}

class _BlogPostingPageState extends State<BlogPostPage> {
  final BlogController blogController = Get.put(BlogController());
  final ProfileController profileController = Get.find<ProfileController>();
  final LoginController loginController =
  Get.find<LoginController>(); // Access user controller

  @override
  void initState() {
    super.initState();
    if (loginController.token.value != null) {
      profileController.fetchProfileData(loginController.token.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the ProfileController
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor:Colors.grey[200],
      appBar: AppBar(
        backgroundColor:Colors.grey[200],
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            color: Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
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
                blogController.postBlog();
              }
                  : null, // Disable button when text is empty
              style: TextButton.styleFrom(
                backgroundColor: blogController.isButtonEnabled.value
                    ? Color(0xFF186CAC)
                    : Colors.grey[200],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Post',
                style: TextStyle(color: Colors.deepOrange),
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
                  backgroundImage: profileController.profile.value != null &&
                      profileController.profile.value!.profileImageUrl !=
                          null
                      ? NetworkImage(profileController.profile.value!
                      .profileImageUrl!) // Load image from URL if available
                      : AssetImage('assets/default_profile.png')
                  as ImageProvider,
                  // Fallback image
                  backgroundColor:
                  Colors.grey.shade200, // Background color if no image
                ),
                SizedBox(width: 16), // Space between avatar and username
                Text(
                  '${loginController.user.value?.name ?? 'Guest'}', // Access user name from loginController
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
                            child: Text(
                              '+ Add images',
                              style: TextStyle(
                                  color: Colors.grey[550], fontSize: 17),
                            ),
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