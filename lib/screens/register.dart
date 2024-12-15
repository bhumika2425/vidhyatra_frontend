import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  String role = 'Student'; // Default role set to Student
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
          Uri.parse('http://10.0.2.2:3001/api/auth/register'),
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
          Get.snackbar('Registration Successful', 'You have been registered to the app successfully' );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          duration: Duration(seconds: 2),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Image.asset(
                                'assets/Vidhyatra.png',
                                height: 120,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Register for Vidhyatra",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Create your account",
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) => name = value,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter your full name'
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'College ID',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.school_outlined, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) => collegeId = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your college ID';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Dropdown for Role selection
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: DropdownButtonFormField<String>(
                            value: role,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            items: ['Student', 'Teacher']
                                .map((roleValue) => DropdownMenuItem<String>(
                              value: roleValue,
                              child: Text(roleValue),
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
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            obscureText: _obscurePassword,
                            onChanged: (value) => password = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(_animationController),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            obscureText: _obscureConfirmPassword,
                            onChanged: (value) => confirmPassword = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            registerStudent();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Set the background color to black
                            foregroundColor: Colors.white, // Set the text color to white
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Login here',
                                style: TextStyle( fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
