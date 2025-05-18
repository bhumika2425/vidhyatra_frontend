import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constants/api_endpoints.dart';
import '../controllers/LoginController.dart';
import '../controllers/ProfileController.dart';

class StudentProfileUpdatePage extends StatefulWidget {
  const StudentProfileUpdatePage({super.key});

  @override
  _StudentProfileUpdatePageState createState() => _StudentProfileUpdatePageState();
}

class _StudentProfileUpdatePageState extends State<StudentProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  String? _department;
  String? _year;
  String? _semester;
  String? _section;
  XFile? _profileImage;
  String? _existingProfileImageUrl;
  bool _isImageChanged = false;
  bool _isLoading = true;

  final List<String> _yearOptions = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _semesterOptions = ['Semester 1', 'Semester 2'];
  final List<String> _departmentOptions = ['BBA', 'BIT'];
  final List<String> _sectionOptions = ['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10'];

  final Color primaryColor = const Color(0xFF186CAC);
  final Color secondaryColor = Colors.deepOrange;
  final Color backgroundColor = Colors.grey[200]!;
  final Color textColor = const Color(0xFF333333);

  // Get the ProfileController
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _dateOfBirthController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = Get.find<LoginController>().token.value;

      if (token.isEmpty) {
        Get.snackbar(
          "Error",
          "Please log in to view profile",
          snackPosition: SnackPosition.TOP,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse(ApiEndPoints.fetchProfileData);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['profile'];

        setState(() {
          _fullnameController.text = data['full_name']?.toString() ?? '';
          _dateOfBirthController.text = data['date_of_birth']?.toString() ?? '';
          _locationController.text = data['location']?.toString() ?? '';
          _bioController.text = data['bio']?.toString() ?? '';
          _interestController.text = data['interest']?.toString() ?? '';

          _department = _departmentOptions.contains(data['department'])
              ? data['department']
              : null;
          _year = _yearOptions.contains(data['year']) ? data['year'] : null;
          _semester = _semesterOptions.contains(data['semester'])
              ? data['semester']
              : null;
          _section = _sectionOptions.contains(data['section'])
              ? data['section']
              : null;

          _existingProfileImageUrl = data['profileImageUrl']?.toString();
          _isLoading = false;
        });
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Failed to load profile';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
          _isImageChanged = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateOfBirthController.text.isNotEmpty
            ? DateTime.tryParse(_dateOfBirthController.text) ?? DateTime.now().subtract(const Duration(days: 365 * 18))
            : DateTime.now().subtract(const Duration(days: 365 * 18)),
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
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedDate != null) {
        setState(() {
          _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting date: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final token = Get.find<LoginController>().token.value;

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please log in to update profile'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final uri = Uri.parse(ApiEndPoints.studentProfileUpdate);

      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['full_name'] = _fullnameController.text
        ..fields['date_of_birth'] = _dateOfBirthController.text
        ..fields['location'] = _locationController.text
        ..fields['department'] = _department ?? ''
        ..fields['year'] = _year ?? ''
        ..fields['semester'] = _semester ?? ''
        ..fields['section'] = _section ?? ''
        ..fields['bio'] = _bioController.text
        ..fields['interest'] = _interestController.text;

      if (_isImageChanged && _profileImage != null) {
        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profileImage',
              _profileImage!.path,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      try {
        final response = await request.send().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Update request timed out');
          },
        );
        final responseBody = await response.stream.bytesToString();

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          // Refresh the profile data in the profileController
          final token = Get.find<LoginController>().token.value;
          await profileController.fetchProfileData(token);

          Get.back(result: true);
          // Replace ScaffoldMessenger with Get.snackbar
          Get.snackbar(
            'Success',
            'Profile updated successfully',
          );
          // // Return to previous screen

        } else {
          final responseData = jsonDecode(responseBody);
          final errorMessage = responseData['message'] ?? 'Profile update failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: $errorMessage'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Update Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 3,
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: _isImageChanged && _profileImage != null
                                  ? FileImage(File(_profileImage!.path))
                                  : _existingProfileImageUrl != null && _existingProfileImageUrl!.isNotEmpty
                                  ? NetworkImage(_existingProfileImageUrl!) as ImageProvider
                                  : null,
                              child: (_profileImage == null &&
                                  (_existingProfileImageUrl == null || _existingProfileImageUrl!.isEmpty))
                                  ? Icon(
                                Icons.person,
                                size: 50,
                                color: primaryColor.withOpacity(0.5),
                              )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tap to change profile picture",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Personal Information', Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Nickname',
                        hint: 'Enter your preferred name',
                        icon: Icons.person_outline,
                        controller: _fullnameController,
                        validator: (value) => value!.isEmpty ? 'Please enter your nickname' : null,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            label: 'Date of Birth',
                            hint: 'YYYY-MM-DD',
                            icon: Icons.calendar_today_outlined,
                            controller: _dateOfBirthController,
                            validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
                            suffix: const Icon(Icons.arrow_drop_down, color: Color(0xFF186CAC)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Location',
                        hint: 'City, Country',
                        icon: Icons.location_on_outlined,
                        controller: _locationController,
                        validator: (value) => value!.isEmpty ? 'Please enter your location' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Bio',
                        hint: 'Tell us a bit about yourself...',
                        icon: Icons.description_outlined,
                        controller: _bioController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Interests',
                        hint: 'Reading, Sports, Music, etc.',
                        icon: Icons.interests_outlined,
                        controller: _interestController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 18),
                      _buildSectionHeader('Academic Information', Icons.school_outlined),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        label: 'Department',
                        hint: 'Select your department',
                        icon: Icons.business_outlined,
                        value: _department,
                        items: _departmentOptions,
                        onChanged: (value) => setState(() => _department = value),
                        validator: (value) => value == null ? 'Please select a department' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Year',
                              hint: 'Select year',
                              icon: Icons.calendar_view_month_outlined,
                              value: _year,
                              items: _yearOptions,
                              onChanged: (value) => setState(() => _year = value),
                              validator: (value) => value == null ? 'Please select a year' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              label: 'Semester',
                              hint: 'Select semester',
                              icon: Icons.access_time_outlined,
                              value: _semester,
                              items: _semesterOptions,
                              onChanged: (value) => setState(() => _semester = value),
                              validator: (value) => value == null ? 'Please select a semester' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        label: 'Section',
                        hint: 'Select section',
                        icon: Icons.group_outlined,
                        value: _section,
                        items: _sectionOptions,
                        onChanged: (value) => setState(() => _section = value),
                        validator: (value) => value == null ? 'Please select a section' : null,
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: IntrinsicWidth(
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Save Changes',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor.withOpacity(0.5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
          dropdownColor: Colors.white,
          elevation: 2,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}