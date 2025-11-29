import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_themes.dart';
import '../controllers/LoginController.dart';
import '../widgets/themed_button.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppThemes.secondaryBackgroundColor,
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
                          color: AppThemes.primaryTextColor,
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
                        color: AppThemes.secondaryTextColor,
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01), // 1% of screen height
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter College ID or Email',
                        hintStyle: TextStyle(
                          color: AppThemes.hintTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        filled: true,
                        fillColor: AppThemes.inputFillColor,
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
                            color: AppThemes.inputFocusedBorderColor,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppThemes.mediumGrey,
                          size: screenWidth * 0.06, // 6% of screen width
                        ),
                      ),
                      cursorColor: AppThemes.inputFocusedBorderColor,
                      onChanged: (value) => loginController.emailOrID.value = value,
                    ),
                    SizedBox(height: screenHeight * 0.015), // 1.5% of screen height
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04, // 4.5% of screen width
                        color: AppThemes.secondaryTextColor,
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01), // 1% of screen height
                    Obx(() => TextField(
                      obscureText: !loginController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                          color: AppThemes.hintTextColor,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        filled: true,
                        fillColor: AppThemes.inputFillColor,
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
                            color: AppThemes.inputFocusedBorderColor,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppThemes.mediumGrey,
                          size: screenWidth * 0.06, // 6% of screen width
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppThemes.mediumGrey,
                            size: screenWidth * 0.06, // 6% of screen width
                          ),
                          onPressed: () {
                            loginController.togglePasswordVisibility();
                          },
                        ),
                      ),
                      cursorColor: AppThemes.inputFocusedBorderColor,
                      onChanged: (value) => loginController.password.value = value,
                    )),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                
                // Keep me logged in checkbox
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: loginController.keepMeLoggedIn.value,
                      onChanged: (value) => loginController.toggleKeepMeLoggedIn(),
                      activeColor: AppThemes.darkMaroon,
                    ),
                    GestureDetector(
                      onTap: () => loginController.toggleKeepMeLoggedIn(),
                      child: Text(
                        'Keep me logged in',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04, // 4% of screen width
                          color: AppThemes.primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                )),
                
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Center(
                  child: Column(
                    children: [
                      // Modern themed login button
                      Obx(() => ThemedButton(
                        text: 'Login',
                        onPressed: loginController.isLoading.value
                            ? null
                            : () => loginController.loginUser(),
                        isLoading: loginController.isLoading.value,
                        variant: ButtonVariant.primary,
                        size: ButtonSize.large,
                        // icon: Icons.login,
                        customWidth: screenWidth * 0.4,
                        borderRadius: 15.0,
                        elevation: 3.0,
                      )),
                      SizedBox(height: screenHeight * 0.05), // 5% of screen height
                      GestureDetector(
                        onTap: () => Get.toNamed('/forgot_password'),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, // 4% of screen width
                            color: AppThemes.darkMaroon,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015), // 1.5% of screen height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04, // 4% of screen width
                              color: AppThemes.primaryTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Register Now',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04, // 4% of screen width
                                color: AppThemes.darkMaroon,
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