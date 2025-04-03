import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/screens/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false; // State to track loading

  void _onGetStarted() {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      Get.to(LoginPage(),
          transition: Transition.fadeIn, duration: Duration(milliseconds: 600));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/yayGirl.png'), // Your background image
            fit: BoxFit.cover, // Makes the image cover the entire screen
            alignment: Alignment.center, // Keeps the image centered
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 130, left: 20, right: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome To ',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF186CAC),
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Vidhyatra',
                            style: GoogleFonts.poppins(
                              color: Colors.deepOrange,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Simplifying College, Empowering You',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Button with CircularProgressIndicator
                    SizedBox(
                      width: 160,
                      child: InkWell(
                        onTap: _isLoading ? null : _onGetStarted,
                        // Disable button when loading
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFF186CAC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(CupertinoIcons.right_chevron,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
