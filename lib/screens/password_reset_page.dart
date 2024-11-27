import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _newPasswordError;
  String? _confirmPasswordError;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _newPasswordError = newPassword.isEmpty ? 'Enter a new password' : null;
        _confirmPasswordError = confirmPassword.isEmpty ? 'Confirm your password' : null;
        _isLoading = false;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    try {
      print('Sending reset password request...');
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': widget.email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword, // Make sure you're sending both
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _newPasswordError = responseData['message'] ?? 'Error resetting password';
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _newPasswordError = 'Failed to reset password. Please try again.';
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
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                errorText: _newPasswordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmPasswordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
