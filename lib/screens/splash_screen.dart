import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin {
  
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressValue;
  late Animation<Color?> _backgroundColor;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo Animation Controller
    _logoController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text Animation Controller  
    _textController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Progress Animation Controller
    _progressController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Background Animation Controller
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo Animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Text Animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textSlide = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Progress Animation
    _progressValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Background Color Animation
    _backgroundColor = ColorTween(
      begin: Color(0xFF186CAC).withOpacity(0.1),
      end: Color(0xFF186CAC).withOpacity(0.05),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.repeat(reverse: true);
    
    // Delay and start logo animation
    await Future.delayed(Duration(milliseconds: 300));
    _logoController.forward();
    
    // Start text animation after logo begins
    await Future.delayed(Duration(milliseconds: 800));
    _textController.forward();
    
    // Start progress animation
    await Future.delayed(Duration(milliseconds: 500));
    _progressController.forward();
    
    // Navigate after all animations complete
    await Future.delayed(Duration(milliseconds: 2500));
    _navigateToWelcome();
  }

  void _navigateToWelcome() {
    Get.offAllNamed('/welcome');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _textController, 
          _progressController,
          _backgroundController
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  _backgroundColor.value ?? Colors.white,
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  
                  // Logo Section
                  _buildLogo(screenWidth),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // App Name Section
                  _buildAppName(screenWidth),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  // Tagline Section
                  _buildTagline(screenWidth),
                  
                  Spacer(flex: 2),
                  
                  // Progress Indicator Section
                  _buildProgressIndicator(screenWidth),
                  
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo(double screenWidth) {
    return Transform.scale(
      scale: _logoScale.value,
      child: Opacity(
        opacity: _logoOpacity.value,
        child: Container(
          width: screenWidth * 0.35,
          height: screenWidth * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF186CAC).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/Vidhyatra.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppName(double screenWidth) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Text(
          'Vidhyatra',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.12,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [
                  Color(0xFF186CAC),
                  Colors.deepOrange,
                ],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildTagline(double screenWidth) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Text(
          'Simplifying College, Empowering You',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.045,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double screenWidth) {
    return Column(
      children: [
        // Custom animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _progressValue.value > (index * 0.33)
                    ? Color(0xFF186CAC)
                    : Colors.grey[300],
              ),
            );
          }),
        ),
        
        SizedBox(height: 16),
        
        // Progress bar
        Container(
          width: screenWidth * 0.6,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.grey[200],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressValue.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF186CAC),
                    Colors.deepOrange,
                  ],
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Loading text
        FadeTransition(
          opacity: _textOpacity,
          child: Text(
            'Loading...',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[500],
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
