// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:vidhyatra_flutter/constants/api_endpoints.dart';
//
// import '../models/user.dart';
// import '../providers/user_provider.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   String emailOrID = '';
//   String password = '';
//   bool _obscurePassword = true;
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 600),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> loginUser() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final response = await http.post(
//           Uri.parse(ApiEndPoints.login),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             'identifier': emailOrID,
//             'password': password,
//           }),
//         );
//         if (response.statusCode == 200) {
//           print("Login successful!");
//           Get.snackbar("Logged", "You successfully logged in to the app");
//           final responseData = jsonDecode(response.body);
//           final token = responseData['token'];
//           final user = User(
//             userId: responseData['user']['user_id'],
//             collegeId: responseData['user']['college_id'] ?? '',
//             name: responseData['user']['name'] ?? '',
//             email: responseData['user']['email'] ?? '',
//           );
//           Provider.of<UserProvider>(context, listen: false).setUser(user, token);
//           Navigator.pushNamed(context, '/dashboard');
//         } else {
//           final responseData = jsonDecode(response.body);
//           _showErrorDialog(responseData['message']);
//         }
//       } catch (error) {
//         _showErrorDialog('An error occurred. Please try again.');
//       }
//     } else {
//       print("error message");
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     // Ensure the context is valid
//     showDialog(
//       context: context,
//       barrierDismissible: false,  // Optional: To prevent closing dialog on tapping outside
//       builder: (ctx) => AlertDialog(
//         title: Text('Login Error', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // Changed to black for visibility
//         content: Text(message, style: TextStyle(color: Colors.black)),  // Changed to black for visibility
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();  // Close the dialog
//             },
//             child: Text('OK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),  // Changed to blue for visibility
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Color(0xFF971F20)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 elevation: 8,
//                 color: Colors.white, // Card color changed to white
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0.8, end: 1.0),
//                           duration: Duration(seconds: 2),
//                           curve: Curves.easeInOut,
//                           builder: (context, scale, child) {
//                             return Transform.scale(
//                               scale: scale,
//                               child: Image.asset(
//                                 'assets/Vidhyatra.png',
//                                 height: 120,
//                                 // color: Colors.black, // Set logo color to black
//                               ),
//                             );
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Welcome to Vidhyatra",
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF971F20), // Text color changed to black
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Login to continue",
//                           style: TextStyle(color: Colors.black87), // Lighter black text color
//                         ),
//                         SizedBox(height: 20),
//                         SlideTransition(
//                           position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
//                               .animate(_animationController),
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               labelText: 'College ID or Email',
//                               labelStyle: TextStyle(color: Colors.black), // Label color black
//                               prefixIcon: Icon(Icons.person_outline, color: Colors.black), // Icon color black
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 borderSide: BorderSide(color: Colors.black), // Border color black
//                               ),
//                             ),
//                             style: TextStyle(color: Colors.black), // Input text color black
//                             onChanged: (value) => emailOrID = value,
//                             validator: (value) => value == null || value.isEmpty
//                                 ? 'Enter ID or Email'
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         SlideTransition(
//                           position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
//                               .animate(_animationController),
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               labelStyle: TextStyle(color: Colors.black), // Label color black
//                               prefixIcon: Icon(Icons.lock_outline, color: Colors.black), // Icon color black
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                   color: Colors.black, // Icon color black
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 borderSide: BorderSide(color: Colors.black), // Border color black
//                               ),
//                             ),
//                             style: TextStyle(color: Colors.black), // Input text color black
//                             obscureText: _obscurePassword,
//                             onChanged: (value) => password = value,
//                             validator: (value) => value == null || value.isEmpty
//                                 ? 'Enter your password'
//                                 : null,
//                           ),
//                         ),
//
//                         SizedBox(height: 20),
//
//                         // Submit Button
//                         ElevatedButton(
//                           onPressed: () {
//                             print("Login button pressed"); // Debugging statement to check if the button is pressed
//                             loginUser();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF971F20), // Set the background color to black
//                             foregroundColor: Colors.white, // Set the text color to white
//                             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text(
//                             'Login',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//
//                         SizedBox(height: 10),
//
//                         // Forgot Password Link
//                         TextButton(
//                           onPressed: () {
//                             // Navigate to Forgot Password Page (implement the route accordingly)
//                             Get.toNamed('/forgot_password');
//                           },
//                           child: Text(
//                             'Forgot Password?',
//                             style: TextStyle(
//                               color: Color(0xFF971F20), // Text color black
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 10),
//
//                         // "Don't have an account? Register here" link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Don't have an account? ",
//                                 style: TextStyle(color: Colors.black)), // Text color black
//                             GestureDetector(
//                               onTap: () {
//                                 // Navigate to Register Page
//                                 Navigator.pushNamed(context, '/register');
//                               },
//                               child: Text(
//                                 'Register here',
//                                 style: TextStyle(
//                                   color: Color(0xFF971F20), // Text color black
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/LoginController.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFF971F20)],
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/Vidhyatra.png',
                          height: 120,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome to Vidhyatra",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF971F20),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Login to continue",
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: 20),

                        // College ID or Email Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'College ID or Email',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) => loginController.emailOrID.value = value,
                          validator: (value) => value == null || value.isEmpty ? 'Enter ID or Email' : null,
                        ),
                        SizedBox(height: 20),

                        // Password Field wrapped in Obx for observing password visibility
                        Obx(() => TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.password.value.isEmpty
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                loginController.password.value =
                                loginController.password.value.isEmpty
                                    ? 'newpassword'
                                    : '';
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          obscureText: loginController.password.value.isEmpty,
                          onChanged: (value) => loginController.password.value = value,
                          validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                        )),
                        SizedBox(height: 20),

                        // Submit Button wrapped in Obx
                        Obx(() => ElevatedButton(
                          onPressed: loginController.isLoading.value
                              ? null
                              : () {
                            loginController.loginUser();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF971F20),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: loginController.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Login', style: TextStyle(fontSize: 18)),
                        )),
                        SizedBox(height: 10),

                        // Forgot Password Link
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/forgot_password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF971F20),
                              fontSize: 14,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ",
                                style: TextStyle(color: Colors.black)),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/register');
                              },
                              child: Text(
                                'Register here',
                                style: TextStyle(
                                  color: Color(0xFF971F20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
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
