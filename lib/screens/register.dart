import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String collegeId = '';
  String password = '';
  String confirmPassword = '';
  String role = 'Student'; // Default role set to Student
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Method to send registration data to the backend
  Future<void> registerStudent() async {
    final url = Uri.parse('http://10.0.2.2:3001/api/auth/register'); // Replace with your backend URL

    print('Starting registration...'); // Debug: Start of method
    print('Data to send:');
    print('Name: $name, Email: $email, College ID: $collegeId, Role: $role');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'collegeId': collegeId,
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print('Response status code: ${response.statusCode}'); // Debug: Status code

      if (response.statusCode == 201) {
        // Success response
        print('Registration successful');

        // Navigate to login page
        Navigator.pushNamed(context, '/login'); // Ensure the route name is correct
      } else {
        // Error response
        final errorResponse = jsonDecode(response.body);
        print('Registration failed: ${errorResponse['message']}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${errorResponse['message']}')),
        );
      }
    } catch (error) {
      print('Error occurred: $error'); // Debug: Catch any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during registration: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  "Register for Vidhyatra",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),

                // Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if ((value == null || value.isEmpty) && (collegeId.isEmpty)) {
                      return 'Please enter either an email or college ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // College ID Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'College ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (value) {
                    collegeId = value;
                  },
                  validator: (value) {
                    if ((value == null || value.isEmpty) && (email.isEmpty)) {
                      return 'Please enter either a college ID or email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Password Field
                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  items: ['Student', 'Teacher'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
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
                SizedBox(height: 30),

                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Form validation passed. Attempting registration...");
                        registerStudent();
                      } else {
                        print("Form validation failed.");
                      }
                    },
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Already have an account? Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
