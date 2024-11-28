import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EnterOtpPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      print('Response body: ${response.body}'); // Log response body

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // OTP sent successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtpPage(email: email),
          ),
        );
      } else {
        // Error response
        setState(() {
          _errorMessage = responseData['message'] ?? 'An error occurred';
        });
      }
    } catch (error) {
      print('Error: $error'); // Log the error for debugging
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add the image
            Image.asset(
              'assets/forgot_password.png',
              height: screenHeight * 0.35,  // 35% of the screen height
              width: screenWidth * 0.9,     // 90% of the screen width
              fit: BoxFit.contain,
            ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}