import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'dart:math' as math;
import '../controllers/LoginController.dart';

class PremiumSplashScreen extends StatefulWidget {
  @override
  _PremiumSplashScreenState createState() => _PremiumSplashScreenState();
}

class _PremiumSplashScreenState extends State<PremiumSplashScreen> 
    with TickerProviderStateMixin {
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressValue;
  late Animation<double> _pulseAnimation;
  
  List<Particle> particles = [];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeParticles();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Main Animation Controller
    _mainController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Particle Animation Controller  
    _particleController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    // Pulse Animation Controller
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo Animations with advanced curves
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    _logoRotation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.0, 0.4, curve: Curves.easeOutBack),
    ));

    // Text Animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.3, 0.6, curve: Curves.easeInOut),
    ));

    _textSlide = Tween<Offset>(
      begin: Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.3, 0.6, curve: Curves.easeOutCubic),
    ));

    // Progress Animation
    _progressValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));

    // Pulse Animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeParticles() {
    for (int i = 0; i < 30; i++) {
      particles.add(Particle());
    }
  }

  void _startAnimationSequence() async {
    // Start particle animation
    _particleController.repeat();
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
    
    // Start main animation
    _mainController.forward();
    
    // Check for existing login while animation plays
    await Future.delayed(Duration(milliseconds: 2000));
    
    try {
      final loginController = Get.find<LoginController>();
      final isLoggedIn = await loginController.checkExistingLogin();
      
      if (isLoggedIn) {
        print('✅ Auto-login successful - navigating to dashboard');
        _navigateToDashboard(loginController.user.value);
      } else {
        print('⚠️ No existing session - showing welcome screen');
        await Future.delayed(Duration(milliseconds: 1500));
        _navigateToWelcome();
      }
    } catch (e) {
      print('❌ Error during auto-login: $e');
      await Future.delayed(Duration(milliseconds: 1500));
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    Get.offAllNamed('/welcome');
  }
  
  void _navigateToDashboard(user) {
    if (user != null) {
      // Get stored user data to check role
      final storage = GetStorage();
      final storedUser = storage.read('user');
      
      if (storedUser != null) {
        final isAdmin = storedUser['isAdmin'] ?? false;
        final role = (storedUser['role'] ?? 'Student').toString().toLowerCase();
        
        print('📍 Navigating based on role: $role, isAdmin: $isAdmin');
        
        if (isAdmin) {
          Get.offAllNamed('/admin-dashboard');
        } else if (role == 'teacher') {
          Get.offAllNamed('/teacher-dashboard');
        } else {
          Get.offAllNamed('/student-dashboard');
        }
      } else {
        // Default to student dashboard if no role data
        Get.offAllNamed('/student-dashboard');
      }
    } else {
      _navigateToWelcome();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _particleController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF186CAC).withOpacity(0.1),
                  Colors.white,
                  Color(0xFF186CAC).withOpacity(0.05),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated particles background
                ...particles.map((particle) => _buildParticle(particle, screenWidth, screenHeight)),
                
                // Main content
                SafeArea(
                  child: Stack(
                    children: [
                      // Centered app name (main focus)
                      Center(
                        child: _buildGradientAppName(screenWidth),
                      ),
                      
                      // Progress indicator positioned at bottom as overlay
                      Positioned(
                        bottom: screenHeight * 0.08,
                        left: 0,
                        right: 0,
                        child: _buildAdvancedProgressIndicator(screenWidth),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticle(Particle particle, double screenWidth, double screenHeight) {
    final animationValue = _particleController.value;
    final x = screenWidth * (particle.x + animationValue * particle.speedX) % 1.0;
    final y = screenHeight * (particle.y + animationValue * particle.speedY) % 1.0;
    
    return Positioned(
      left: x,
      top: y,
      child: Opacity(
        opacity: particle.opacity * (1.0 - animationValue % 1.0),
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                particle.color.withOpacity(0.8),
                particle.color.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedLogo(double screenWidth) {
    return Transform.rotate(
      angle: _logoRotation.value,
      child: Transform.scale(
        scale: _logoScale.value * _pulseAnimation.value,
        child: Opacity(
          opacity: _logoOpacity.value,
          child: Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF186CAC).withOpacity(0.4),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/Vidhyatra.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientAppName(double screenWidth) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Color(0xFF186CAC),
              Colors.deepOrange,
              Color(0xFF186CAC),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            'Vidhyatra',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedProgressIndicator(double screenWidth) {
    return Column(
      children: [
        // Circular progress indicator
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: _progressValue.value,
                strokeWidth: 3,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(Color(0xFF186CAC), Colors.deepOrange, _progressValue.value)!,
                ),
              ),
            ),
            Text(
              '${(_progressValue.value * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF186CAC),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20),
        
        // Loading text with typewriter effect
        FadeTransition(
          opacity: _textOpacity,
          child: Text(
            'Initializing your journey...',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double speedX;
  late double speedY;
  late double size;
  late Color color;
  late double opacity;

  Particle() {
    final random = math.Random();
    x = random.nextDouble();
    y = random.nextDouble();
    speedX = (random.nextDouble() - 0.5) * 0.2;
    speedY = (random.nextDouble() - 0.5) * 0.2;
    size = random.nextDouble() * 4 + 2;
    opacity = random.nextDouble() * 0.6 + 0.2;
    
    // Random colors from your brand palette
    final colors = [
      Color(0xFF186CAC),
      Colors.deepOrange,
      Colors.grey[300]!,
    ];
    color = colors[random.nextInt(colors.length)];
  }
}
