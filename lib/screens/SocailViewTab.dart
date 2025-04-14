import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/BlogController.dart';
import '../models/blogModel.dart';

class SocialTabView extends StatelessWidget {
  final BlogController blogController = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (blogController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final blogs = blogController.blogs.value;

      if (blogs == null || blogs.isEmpty) {
        return Center(
          child: Text("No blogs available", style: GoogleFonts.poppins()),
        );
      }

      final reversedBlogs = blogs.reversed.toList();

      return SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reversedBlogs.length,
          itemBuilder: (context, index) {
            final blog = reversedBlogs[index];
            return _buildBlogCard(context, blog);
          },
        ),
      );
    });
  }

  Widget _buildBlogCard(BuildContext context, Blog blog) {
    return Card(
      margin: EdgeInsets.symmetric( vertical: 8),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: blog.profileImage.isNotEmpty
                      ? NetworkImage(blog.profileImage)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.fullName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      timeago.format(blog.createdAt),
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              blog.blogDescription,
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            SizedBox(height: 8.0),
            if (blog.imageUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.imageUrls.take(2).map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: EdgeInsets.zero,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Hero(
                                          tag: imageUrl,
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Hero(
                              tag: imageUrl,
                              child: Image.network(
                                imageUrl,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (blog.imageUrls.length > 2)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "All Images",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                        ),
                                        itemCount: blog.imageUrls.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black,
                                                    insetPadding: EdgeInsets.zero,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Hero(
                                                            tag: blog.imageUrls[index],
                                                            child: Image.network(
                                                              blog.imageUrls[index],
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 20,
                                                          right: 20,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 30,
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.of(context).pop(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Hero(
                                                tag: blog.imageUrls[index],
                                                child: Image.network(
                                                  blog.imageUrls[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "+${blog.imageUrls.length - 2} more images",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 8.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => print("like clicked"),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.thumb_up_off_alt_outlined,
                            color: Colors.grey[600],
                            size: 25,
                          ),
                          SizedBox(width: 5),
                          Text(
                            blog.likes.toString(),
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => print("Comment clicked"),
                      child: Icon(
                        Icons.comment,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}