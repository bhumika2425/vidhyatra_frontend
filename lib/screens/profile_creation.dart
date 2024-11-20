
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../models/profile.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';
class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _nickname;
  String? _location;
  String? _year;
  String? _semester;
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dateOfBirthController = TextEditingController();

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

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save profile: Missing token')),
        );
        return;
      }

      // Prepare form data
      final uri = Uri.parse('http://10.0.2.2:3001/api/profile/create');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['nickname'] = _nickname ?? ''
        ..fields['date_of_birth'] = _dateOfBirthController.text
        ..fields['location'] = _location ?? ''
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
          final profile = Profile.fromJson(responseJson['data']);

          Provider.of<ProfileProvider>(context, listen: false).setProfile(profile);

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
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile, ${user?.name}', style: TextStyle(color: Colors.red)),
      ),
      body: Padding(
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
                          radius: 70, // Increased size for better visibility
                          // backgroundColor: Colors.redAccent, // Background color for the avatar
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : AssetImage('assets/default_profile.png') as ImageProvider,
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
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: _removeImage,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  label: 'Nickname',
                  onSaved: (value) => _nickname = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a nickname';
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
                  label: 'Year',
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
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.blueGrey), // Label color
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}