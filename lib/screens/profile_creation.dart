import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import '../controllers/LoginController.dart';

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
  String? _bio;
  String? _interest;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final LoginController loginController = Get.find<LoginController>();

  // Dropdown options
  final List<String> _yearOptions = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _semesterOptions = ['Semester 1', 'Semester 2'];

  // Color theme
  final Color primaryColor = Color(0xFF186CAC);
  final Color secondaryColor = Color(0xFF186CAC).withOpacity(0.1);
  final Color lightBlue = Color(0xFFE6F2FF);
  final Color textColor = Color(0xFF333333);

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
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
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
        ..fields['semester'] = _semester ?? ''
        ..fields['bio'] = _bio ?? ''
        ..fields['interest'] = _interest ?? '';


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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile created successfully'),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          final responseData = await response.stream.bytesToString();
          final errorData = json.decode(responseData);
          final errorMessage = errorData['message'] ?? 'Profile creation failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating profile. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userName = loginController.user.value?.name;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          'Create Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header section with profile image
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 30),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Small colored top accent
                      Container(
                        width: double.infinity,
                        color: Colors.grey[200],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            if (userName != null)
                              Text(
                                'Hello, $userName!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            SizedBox(height: 5),
                            Text(
                              'Let\'s set up your profile',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Profile image picker
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: _profileImage != null
                                    ? FileImage(File(_profileImage!.path))
                                    : null,
                                child: _profileImage == null
                                    ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: primaryColor.withOpacity(0.7),
                                )
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey[400]!,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[400],
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Form section
                Container(
                  color:Colors.grey[200],
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildInputField(
                          label: 'Nickname',
                          icon: Icons.person_outline,
                          onSaved: (value) => _fullname = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your nickname';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: _buildInputField(
                              label: 'Date of Birth',
                              icon: Icons.calendar_today_outlined,
                              controller: _dateOfBirthController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInputField(
                          label: 'Location',
                          icon: Icons.location_on_outlined,
                          onSaved: (value) => _location = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your location';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildTextAreaField(
                          label: 'Bio',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                          onSaved: (value) => _bio = value,
                          hintText: 'Tell us a bit about yourself...',
                        ),
                        SizedBox(height: 16),
                        _buildTextAreaField(
                          label: 'Interests',
                          icon: Icons.interests_outlined,
                          maxLines: 2,
                          onSaved: (value) => _interest = value,
                          hintText: 'Reading, Sports, Music, etc.',
                        ),

                        SizedBox(height: 30),
                        Text(
                          'Academic Information',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildInputField(
                          label: 'Department',
                          icon: Icons.school_outlined,
                          onSaved: (value) => _department = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your department';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Year',
                                icon: Icons.calendar_view_month_outlined,
                                value: _year,
                                items: _yearOptions,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _year = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _year = value,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Semester',
                                icon: Icons.access_time_outlined,
                                value: _semester,
                                items: _semesterOptions,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _semester = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _semester = value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'CREATE PROFILE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
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
    );
  }

  Widget _buildInputField({
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
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey[600],
        ),
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Colors.grey[600],
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required IconData icon,
    required int maxLines,
    Function(String?)? onSaved,
    String? hintText,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 0, top: 16, left: 12, right: 0),
          child: Icon(icon, color: Colors.grey[400], size: 22),
        ),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey[600],
        ),
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey[400],
        ),
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Colors.grey[600],
      ),
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
    required Function(String?)? onSaved,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey[600],
        ),
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Colors.grey[600],
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
              item,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              )
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
    );
  }}