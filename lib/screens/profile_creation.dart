import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';

import '../controllers/LoginController.dart';
import '../models/profile.dart';

class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _fullname;
  String? _location;
  String? _department;
  String? _year;
  String? _semester;
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final LoginController loginController =
  Get.find<LoginController>(); // Access user controller

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final token = Get.find<LoginController>().token.value;

      final uri = Uri.parse(ApiEndPoints.profileCreation);
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['full_name'] = _fullname ?? ''
        ..fields['date_of_birth'] = _dateOfBirthController.text
        ..fields['location'] = _location ?? ''
        ..fields['department'] = _department ?? ''
        ..fields['year'] = _year ?? ''
        ..fields['semester'] = _semester ?? '';

      if (_profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            _profileImage!.path,
          ),
        );
      }

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          final responseData = await response.stream.bytesToString();
          final responseJson = json.decode(responseData);
          // final profile = Profile.fromJson(responseJson['data']);
          //
          // Provider.of<ProfileProvider>(context, listen: false).setProfile(profile);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile created successfully')),
          );

          Navigator.pop(context);
        } else {
          final responseData = await response.stream.bytesToString();
          final errorData = json.decode(responseData);
          final errorMessage = errorData['message'] ?? 'Profile creation failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (error) {
        print('Error creating profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating profile: $error')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF971F20),
        title: Text(
          'Create Profile, ${loginController.user.value?.name}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF971F20), // Blue for the top half
              Colors.white, // White for the bottom half
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.7], // Defines the split point for the gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: _profileImage != null
                                ? FileImage(File(_profileImage!.path))
                                : AssetImage('assets/default_profile.png')
                            as ImageProvider,
                            child: _profileImage == null
                                ? Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ),
                        if (_profileImage != null)
                          Positioned(
                            right: -3,
                            top: -3,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: _removeImage,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Color(0xFFE7E3E3),
                    elevation: 15.0,
                    shadowColor: Colors.black.withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Personal Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          SizedBox(height: 30),
                          _buildTextFormField(
                            label: 'Nickname',
                            icon: Icons.person,
                            onSaved: (value) => _fullname = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: _buildTextFormField(
                                label: 'Date of Birth',
                                icon: Icons.calendar_today,
                                controller: _dateOfBirthController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your date of birth';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildTextFormField(
                            label: 'Location',
                            icon: Icons.location_on,
                            onSaved: (value) => _location = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextFormField(
                            label: 'Department',
                            icon: Icons.school,
                            onSaved: (value) => _department = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your department';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextFormField(
                            label: 'Year',
                            icon: Icons.timeline,
                            onSaved: (value) => _year = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your year';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextFormField(
                            label: 'Semester',
                            icon: Icons.grade,
                            onSaved: (value) => _semester = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your semester';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFBD0606),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: Text(
                                'Save Profile',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),  // This makes the border curved
          borderSide: BorderSide.none, // Removes the border color
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.blueGrey),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
