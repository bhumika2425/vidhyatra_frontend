import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/screens/password_reset_page.dart';

class EnterOtpPage extends StatefulWidget {
  final String email; // Receive email from the previous page

  EnterOtpPage({required this.email});

  @override
  _EnterOtpPageState createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  // final _otpController = TextEditingController();
  final _otpControllers = List.generate(
      6, (_) => TextEditingController()); // Create 6 controllers for OTP
  bool _isLoading = false;
  String? _errorMessage;

  // Function to automatically move to the next OTP input field when a digit is entered
  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Collect OTP from the 6 individual fields
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter the full OTP';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email, 'otp': otp}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // OTP verification successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: widget.email),
          ),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Invalid OTP';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to verify OTP. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please enter the OTP sent to ${widget.email}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) => _onOtpChanged(value, index),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child:
                  _isLoading ? CircularProgressIndicator() : Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
