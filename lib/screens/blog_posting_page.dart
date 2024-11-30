import 'dart:convert'; // For jsonEncode
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart'; // For HTTP requests

class BlogPostPage extends StatefulWidget {
  @override
  _BlogPostPageState createState() => _BlogPostPageState();
}

class _BlogPostPageState extends State<BlogPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _blogImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _blogImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _postBlog() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save profile: Missing token')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    String title = _titleController.text;
    String description = _descriptionController.text;
    final url = 'http://10.0.2.2:3001/api/blog/post';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'blog_title': title,
          'blog_description': description,
        }),
      );

      if (response.statusCode == 201) {
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _blogImage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Blog posted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to post blog.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error posting blog: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post a Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
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
                controller: _descriptionController,
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
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                ],
              ),
              if (_blogImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(_blogImage!),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _postBlog,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
