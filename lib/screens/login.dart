import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/LoginController.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea( // Ensures content respects system UI (notch, status bar)
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% of screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.10), // 15% of screen height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible( // Allows text to wrap if needed
                      child: Text(
                        'ALREADY\nHAVE\nACCOUNT?',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07, // 7% of screen width
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/login_image.png',
                        height: screenHeight * 0.23, // 23% of screen height
                        width: screenWidth * 0.4, // 40% of screen width
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05), // 5% of screen height
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'College ID or Email',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04, // 4.5% of screen width
                        color: Colors.grey[600],
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01), // 1% of screen height
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter College ID or Email',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // 2% of screen height
                          horizontal: screenWidth * 0.05, // 5% of screen width
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
                          Icons.person_outline,
                          color: Colors.grey[400],
                          size: screenWidth * 0.06, // 6% of screen width
                        ),
                      ),
                      cursorColor: Color(0xFF3D7FA4),
                      onChanged: (value) => loginController.emailOrID.value = value,
                    ),
                    SizedBox(height: screenHeight * 0.015), // 1.5% of screen height
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04, // 4.5% of screen width
                        color: Colors.grey[600],
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01), // 1% of screen height
                    Obx(() => TextField(
                      obscureText: !loginController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // 2% of screen height
                          horizontal: screenWidth * 0.05, // 5% of screen width
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
                          Icons.lock_outline,
                          color: Colors.grey[400],
                          size: screenWidth * 0.06, // 6% of screen width
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey[600],
                            size: screenWidth * 0.06, // 6% of screen width
                          ),
                          onPressed: () {
                            loginController.togglePasswordVisibility();
                          },
                        ),
                      ),
                      cursorColor: Color(0xFF3D7FA4),
                      onChanged: (value) => loginController.password.value = value,
                    )),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03), // 3% of screen height
                Center(
                  child: Column(
                    children: [
                      Obx(
                            () => SizedBox(
                          width: screenWidth * 0.3, // 40% of screen width
                          child: InkWell(
                            onTap: loginController.isLoading.value
                                ? null
                                : () => loginController.loginUser(),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02, // 2% of screen height
                              ),
                              decoration: BoxDecoration(
                                color:Color(0xFF186CAC),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05, // 5% of screen width
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.015), // 1.5% of screen width
                                    // Icon(
                                    //   CupertinoIcons.right_chevron,
                                    //   color: Colors.white,
                                    //   size: screenWidth * 0.06, // 6% of screen width
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05), // 5% of screen height
                      GestureDetector(
                        onTap: () => Get.toNamed('/forgot_password'),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, // 4% of screen width
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015), // 1.5% of screen height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account? ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04, // 4% of screen width
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Register Now',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04, // 4% of screen width
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03), // 3% of screen height
                    ],
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