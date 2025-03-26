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
          // gradient: LinearGradient(
          //   colors: [Colors.white, Color(0xFF971F20)],
          //
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          fontSize: 30,
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Color(0xFF971F20)), // Red when focused
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) => loginController.emailOrID.value = value,
                        validator: (value) => value == null || value.isEmpty ? 'Enter ID or Email' : null,
                      ),
                      SizedBox(height: 20),

                      // Password Field wrapped in Obx for observing password visibility
                      Obx(() {
                        print("🔍 Obx rebuild - isPasswordVisible: ${loginController.isPasswordVisible.value}");
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                loginController.togglePasswordVisibility();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Color(0xFF971F20)),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          obscureText: !loginController.isPasswordVisible.value, // Should be true (obscured) by default
                          onChanged: (value) => loginController.password.value = value,
                          validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                        );
                      }),
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
    );
  }
}



