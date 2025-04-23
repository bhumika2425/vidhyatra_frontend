// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
//
// class ResetPasswordPage extends StatefulWidget {
//   final String email;
//
//   ResetPasswordPage({required this.email});
//
//   @override
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }
//
// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;
//   String? _newPasswordError;
//   String? _confirmPasswordError;
//   bool _obscureNewPassword = true;
//   bool _obscureConfirmPassword = true;
//
//   Future<void> _resetPassword() async {
//     setState(() {
//       _isLoading = true;
//       _newPasswordError = null;
//       _confirmPasswordError = null;
//     });
//
//     final newPassword = _newPasswordController.text.trim();
//     final confirmPassword = _confirmPasswordController.text.trim();
//
//     if (newPassword.isEmpty || confirmPassword.isEmpty) {
//       setState(() {
//         _newPasswordError = newPassword.isEmpty ? 'Enter a new password' : null;
//         _confirmPasswordError = confirmPassword.isEmpty ? 'Confirm your password' : null;
//         _isLoading = false;
//       });
//       return;
//     }
//
//     if (newPassword != confirmPassword) {
//       setState(() {
//         _confirmPasswordError = 'Passwords do not match';
//         _isLoading = false;
//       });
//       return;
//     }
//
//     try {
//       final response = await http.post(
//         Uri.parse(ApiEndPoints.passwordReset),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': widget.email,
//           'newPassword': newPassword,
//           'confirmPassword': confirmPassword,
//         }),
//       );
//
//       final responseData = json.decode(response.body);
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'])),
//         );
//         Navigator.pushReplacementNamed(context, '/login');
//       } else {
//         setState(() {
//           _newPasswordError = responseData['message'] ?? 'Error resetting password';
//         });
//       }
//     } catch (error) {
//       setState(() {
//         _newPasswordError = 'Failed to reset password. Please try again.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.deepOrange[50],
//       appBar: AppBar(
//         title: Text(
//           'Reset Password',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: Icon(Icons.lock_reset, size: 100, color: Color(0xFF971F20)),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'Secure Your Account',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Center(
//                 child: Text(
//                   'Please create a strong new password.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//               ),
//               SizedBox(height: 30),
//               TextField(
//                 controller: _newPasswordController,
//                 obscureText: _obscureNewPassword,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   hintText: 'Enter your new password',
//                   errorText: _newPasswordError,
//                   prefixIcon: Icon(Icons.lock, color: Color(0xFF971F20)),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureNewPassword = !_obscureNewPassword;
//                       });
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: _obscureConfirmPassword,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   hintText: 'Re-enter your new password',
//                   errorText: _confirmPasswordError,
//                   prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF971F20)),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               SizedBox(
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _resetPassword,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF971F20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : Text(
//                     'Reset Password',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'Make sure your password is at least 8 characters long and includes a mix of letters, numbers, and special characters.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  ResetPasswordPage({required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF186CAC),
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Image.asset(
              'assets/chnage_pass.png',
              height: 345,
            ),
            const SizedBox(height: 40),
            Text(
              'Create a new password for your account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'New Password',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF186CAC),
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF186CAC),
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: () {
                // Handle reset logic here
              },
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
