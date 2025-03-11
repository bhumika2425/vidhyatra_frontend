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



// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/LoginController.dart';
//
// class LoginPage extends StatelessWidget {
//   final LoginController loginController = Get.put(LoginController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Logo and Greeting Section
//             Container(
//               padding: const EdgeInsets.only(top: 100, left: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   FlutterLogo(size: 100), // Replace with your logo
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Hello!',
//                     style: TextStyle(
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF971F20)),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Welcome to Vidhyatra',
//                     style: TextStyle(fontSize: 23, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Yellow Container (60% of screen height)
//             Container(
//               margin: const EdgeInsets.only(top: 40),
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color(0xFF971F20),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Login to your account',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 40),
//
//                     // Email TextField
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'College ID or Email',
//                         labelStyle: TextStyle(color: Colors.black),
//                         prefixIcon: Icon(Icons.person_outline, color: Colors.black),
//                         // Hint text color
//                         filled: true,
//                         // Enable background color
//                         fillColor: Colors.white,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                               color: Colors
//                                   .green), // Border color when not focused
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                               color: Colors.blue), // Border color when focused
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                               color: Colors
//                                   .red), // Border color when there's an error
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black), // Input text color
//                       onChanged: (value) => loginController.emailOrID.value = value,
//                       validator: (value) => value == null || value.isEmpty ? 'Enter ID or Email' : null,
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Password TextField with Visibility Toggle
//                     Obx(
//                           () => TextFormField(
//                         // obscureText: !loginController.isPasswordVisible.value,
//                         // Toggle password visibility
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle: TextStyle(color: Colors.blue),
//                           // Label text color
//                           hintText: 'Enter your password',
//                           hintStyle: TextStyle(color: Colors.grey),
//                           // Hint text color
//                           filled: true,
//                           // Enable background color
//                           fillColor: Colors.white,
//                           // Background color
//                           prefixIcon: Icon(Icons.lock, color: Colors.blue),
//                           // Password icon
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               loginController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
//                               color: Colors.black,
//                             ),
//                             onPressed: () {
//                               loginController.isPasswordVisible.value = !loginController.isPasswordVisible.value;
//                             },
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors
//                                     .green), // Border color when not focused
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color:
//                                 Colors.blue), // Border color when focused
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Colors
//                                     .red), // Border color when there's an error
//                           ),
//                         ),
//                         style: TextStyle(color: Colors.black),
//                         obscureText: !loginController.isPasswordVisible.value,
//                         onChanged: (value) => loginController.password.value = value,
//                         validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Login Button
//                     Center(
//                       child: SizedBox(
//                         width: Get.width * 0.3,
//                         child: ElevatedButton(
//                           onPressed: loginController.isLoading.value
//                               ? null
//                               : () {
//                             loginController.loginUser();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text('Login'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.toNamed('/forgot_password');
//                         },
//                         child: const Text(
//                           'Forgot password?',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Register Prompt
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.toNamed('/register');
//                         },
//                         child: Text.rich(
//                           TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: "Don't have an account? ",
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                               TextSpan(
//                                 text: "Register here",
//                                 style: const TextStyle(color: Colors.white),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () => Get.toNamed('/register'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }