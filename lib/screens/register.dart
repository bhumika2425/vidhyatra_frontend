import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/constants/api_endpoints.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String collegeId = '';
  String password = '';
  String confirmPassword = '';
  String role = 'Student';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> registerStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(ApiEndPoints.register),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'collegeId': collegeId,
            'name': name,
            'email': email,
            'password': password,
            'role': role,
          }),
        );
        if (response.statusCode == 201) {
          Navigator.pushNamed(context, '/login');
          Get.snackbar('Registration Successful', 'You have been registered to the app successfully');
        } else {
          final responseData = jsonDecode(response.body);
          _showErrorDialog(responseData['message']);
        }
      } catch (error) {
        _showErrorDialog('An error occurred. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Registration Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    required double screenHeight,
    required double screenWidth,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(0xFF3D7FA4),
          width: 2,
        ),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.grey[400],
        size: screenWidth * 0.06,
      ),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenHeight * 0.002), // Reduced from 0.005 to 0.002
        SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(_animationController),
          child: TextFormField(
            decoration: _buildInputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
            cursorColor: Color(0xFF3D7FA4),
            style: GoogleFonts.poppins(color: Colors.black),
            obscureText: obscureText,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: screenHeight * 0.08),
                  // Text(
                  //   "Register for Vidhyatra",
                  //   style: GoogleFonts.poppins(
                  //     fontSize: screenWidth * 0.07,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  SizedBox(height: 80),
                  RichText(
                    text: TextSpan(
                      text: "CREATE YOUR ",  // The part of the text before "Account" (in black)
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "ACCOUNT",  // The part you want to make orange
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,  // Set to orange
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03  ),
                  _buildTextField(
                    label: 'Full Name',
                    hintText: 'Enter Full Name',
                    prefixIcon: Icons.person_outline,
                    onChanged: (value) => name = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your full name'
                        : null,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Email',
                    hintText: 'Enter Email',
                    prefixIcon: Icons.email_outlined,
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'College ID',
                    hintText: 'Enter College ID',
                    prefixIcon: Icons.school_outlined,
                    onChanged: (value) => collegeId = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your college ID';
                      }
                      return null;
                    },
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  SlideTransition(
                    position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                        .animate(_animationController),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Role',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.002), // Reduced from 0.005 to 0.002
                        DropdownButtonFormField<String>(
                          value: role,
                          decoration: _buildInputDecoration(
                            hintText: 'Select Role',
                            prefixIcon: Icons.person,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                          style: GoogleFonts.poppins(color: Colors.black),
                          items: ['Student', 'Teacher']
                              .map((roleValue) => DropdownMenuItem<String>(
                            value: roleValue,
                            child: Text(roleValue, style: GoogleFonts.poppins()),
                          ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              role = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Password',
                    hintText: 'Enter Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                        size: screenWidth * 0.06,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    obscureText: _obscurePassword,
                    onChanged: (value) => password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  // SizedBox(height: screenHeight * 0.015),
                  // _buildTextField(
                  //   label: 'Confirm Password',
                  //   hintText: 'Confirm Password',
                  //   prefixIcon: Icons.lock_outline,
                  //   suffixIcon: IconButton(
                  //     icon: Icon(
                  //       _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  //       color: Colors.grey[600],
                  //       size: screenWidth * 0.06,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         _obscureConfirmPassword = !_obscureConfirmPassword;
                  //       });
                  //     },
                  //   ),
                  //   obscureText: _obscureConfirmPassword,
                  //   onChanged: (value) => confirmPassword = value,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please confirm your password';
                  //     }
                  //     if (value != password) {
                  //       return 'Passwords do not match';
                  //     }
                  //     return null;
                  //   },
                  //   screenHeight: screenHeight,
                  //   screenWidth: screenWidth,
                  // ),
                  SizedBox(height: screenHeight * 0.03),
                  ElevatedButton(
                    onPressed: registerStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF186CAC), // Match Login button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Match Login button radius
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.05,
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login here',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}