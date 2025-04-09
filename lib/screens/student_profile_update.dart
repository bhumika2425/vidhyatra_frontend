import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
import '../controllers/LoginController.dart';

class StudentProfileUpdatePage extends StatefulWidget {
  @override
  _StudentProfileUpdatePageState createState() => _StudentProfileUpdatePageState();
}

class _StudentProfileUpdatePageState extends State<StudentProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String? _fullname;
  String? _location;
  String? _department;
  String? _year;
  String? _semester;
  XFile? _profileImage;
  String? _existingProfileImageUrl;
  bool _isImageChanged = false;
  String? _bio;
  String? _interest;
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final LoginController loginController = Get.find<LoginController>();

  // Dropdown options
  final List<String> _yearOptions = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _semesterOptions = ['Semester 1', 'Semester 2'];
  final List<String> _departmentOptions = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Business Administration',
    'Economics',
    'Physics',
    'Mathematics',
    'Biology',
    'Chemistry',
    'Other'
  ];

  // Color theme - Using a more subtle color palette
  final Color primaryColor = Color(0xFF186CAC);
  final Color secondaryColor = Colors.deepOrange;
  final Color backgroundColor = Colors.grey[100]!;
  final Color textColor = Color(0xFF333333);

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
    _departmentController.dispose();
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
      final response = await http.get(
        Uri.parse(ApiEndPoints.studentProfileUpdate),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        setState(() {
          _fullnameController.text = data['full_name'] ?? '';
          _dateOfBirthController.text = data['date_of_birth'] ?? '';
          _locationController.text = data['location'] ?? '';
          _departmentController.text = data['department'] ?? '';
          _department = data['department'];
          _year = data['year'];
          _semester = data['semester'];
          _bioController.text = data['bio'] ?? '';
          _interestController.text = data['interest'] ?? '';
          _existingProfileImageUrl = data['profile_image'];

          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile data'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile. Please try again.'),
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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
        _isImageChanged = true;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirthController.text.isNotEmpty
          ? DateTime.parse(_dateOfBirthController.text)
          : DateTime.now().subtract(Duration(days: 365 * 18)),
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
        _dateOfBirthController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final token = Get.find<LoginController>().token.value;

      final uri = Uri.parse(ApiEndPoints.studentProfileUpdate);
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['full_name'] = _fullnameController.text
        ..fields['date_of_birth'] = _dateOfBirthController.text
        ..fields['location'] = _locationController.text
        ..fields['department'] = _department ?? ''
        ..fields['year'] = _year ?? ''
        ..fields['semester'] = _semester ?? ''
        ..fields['bio'] = _bioController.text
        ..fields['interest'] = _interestController.text;

      if (_isImageChanged && _profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            _profileImage!.path,
          ),
        );
      }

      try {
        final response = await request.send();

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: secondaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate successful update
        } else {
          final responseData = await response.stream.bytesToString();
          final errorData = json.decode(responseData);
          final errorMessage = errorData['message'] ?? 'Profile update failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          'Update Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture section - Simplified and elegant
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            // Profile image
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: _isImageChanged && _profileImage != null
                                  ? FileImage(File(_profileImage!.path))
                                  : _existingProfileImageUrl != null && _existingProfileImageUrl!.isNotEmpty
                                  ? NetworkImage(_existingProfileImageUrl!) as ImageProvider
                                  : null,
                              child: (_profileImage == null && (_existingProfileImageUrl == null || _existingProfileImageUrl!.isEmpty))
                                  ? Icon(
                                Icons.person,
                                size: 50,
                                color: primaryColor.withOpacity(0.5),
                              )
                                  : null,
                            ),
                            // Camera icon overlay
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Tap to change profile picture",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      _buildSectionHeader('Personal Information', Icons.person_outline),
                      SizedBox(height: 16),

                      _buildTextField(
                        label: 'Nickname',
                        hint: 'Enter your preferred name',
                        icon: Icons.person_outline,
                        controller: _fullnameController,
                        validator: (value) => value!.isEmpty ? 'Please enter your nickname' : null,
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black), // Added style
                      ),
                      SizedBox(height: 18),

                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            label: 'Date of Birth',
                            hint: 'YYYY-MM-DD',
                            icon: Icons.calendar_today_outlined,
                            controller: _dateOfBirthController,
                            validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
                            suffix: Icon(Icons.arrow_drop_down, color: primaryColor),
                            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black), // Added style
                          ),
                        ),
                      ),
                      SizedBox(height: 18),

                      _buildTextField(
                        label: 'Location',
                        hint: 'City, Country',
                        icon: Icons.location_on_outlined,
                        controller: _locationController,
                        validator: (value) => value!.isEmpty ? 'Please enter your location' : null,
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black), // Added style
                      ),
                      SizedBox(height: 18),

                      _buildTextField(
                        label: 'Bio',
                        hint: 'Tell us a bit about yourself...',
                        icon: Icons.description_outlined,
                        controller: _bioController,
                        maxLines: 3,
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black), // Added style
                      ),
                      SizedBox(height: 18),

                      _buildTextField(
                        label: 'Interests',
                        hint: 'Reading, Sports, Music, etc.',
                        icon: Icons.interests_outlined,
                        controller: _interestController,
                        maxLines: 2,
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black), // Added style
                      ),
                      SizedBox(height: 30),

                      // Academic Information Section
                      _buildSectionHeader('Academic Information', Icons.school_outlined),
                      SizedBox(height: 16),

                      _buildDropdown(
                        label: 'Department',
                        hint: 'Select your department',
                        icon: Icons.business_outlined,
                        value: _department,
                        items: _departmentOptions,
                        onChanged: (value) => setState(() => _department = value),
                        validator: (value) => value == null ? 'Please select a department' : null,
                      ),
                      SizedBox(height: 18),

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
                              validator: (value) => value == null ? 'Required' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              label: 'Semester',
                              hint: 'Select semester',
                              icon: Icons.access_time_outlined,
                              value: _semester,
                              items: _semesterOptions,
                              onChanged: (value) => setState(() => _semester = value),
                              validator: (value) => value == null ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),

                      // Save button - Compact size, fits content
                      Center(
                        child: IntrinsicWidth(
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.save_outlined, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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

  // Modern section header with gradient underline
  Widget _buildSectionHeader(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            SizedBox(width: 8),
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
        SizedBox(height: 4),
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

  // Clean text field with floating label
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    Widget? suffix,
    TextStyle? style,
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
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: textColor,
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Sleek dropdown with minimal styling
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
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: textColor,
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
                  color: textColor,
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