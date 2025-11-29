import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/OnboardingController.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            _buildSkipButton(),
            
            // Page Content
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: controller.updatePageIndex,
                children: [
                  _buildWelcomePage(screenWidth, screenHeight),
                  _buildFeaturePage1(screenWidth, screenHeight),
                  _buildFeaturePage2(screenWidth, screenHeight),
                ],
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNavigation(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: Obx(() => controller.isLastPage
            ? SizedBox.shrink()
            : TextButton(
                onPressed: controller.skipToLogin,
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color(0xFF186CAC),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
      ),
    );
  }

  Widget _buildWelcomePage(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.06),
          
          // Welcome Text
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome To ',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF186CAC),
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Vidhyatra',
                  style: GoogleFonts.poppins(
                    color: Colors.deepOrange,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Tagline
          Text(
            'Simplifying College, Empowering You',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.04),
          
          // Description
          Text(
            'Your all-in-one college companion for managing academics, connecting with peers, and staying organized throughout your educational journey.',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.038,
              color: Colors.grey[500],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePage1(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          SizedBox(height: screenHeight * 0.06),
          
          // Feature Title
          Text(
            'Manage Your Academics',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Color(0xFF186CAC),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Feature Description
          Text(
            'Access your class schedules, track assignments, view exam timetables, and manage your academic calendar all in one place.',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.04),
          
          _buildFeaturePoint(Icons.calendar_today, 'Class Schedules & Routines', screenWidth),
          SizedBox(height: 12),
          _buildFeaturePoint(Icons.assignment, 'Assignment Tracking', screenWidth),
          SizedBox(height: 12),
          _buildFeaturePoint(Icons.quiz, 'Exam Seat Planning', screenWidth)
        ],
      ),
    );
  }

  Widget _buildFeaturePage2(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.06),
          
          // Feature Title
          Text(
            'Connect & Pay',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Feature Description
          Text(
            'Stay connected with your college community, manage fee payments, and get important updates instantly.',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.04),
          
          // Feature Points
          _buildFeaturePoint(Icons.forum, 'College Community', screenWidth),
          SizedBox(height: 12),
          _buildFeaturePoint(Icons.payment, 'Fee Management', screenWidth),
          SizedBox(height: 12),
          _buildFeaturePoint(Icons.notifications, 'Real-time Updates', screenWidth),
        ],
      ),
    );
  }

  Widget _buildFeaturePoint(IconData icon, String text, double screenWidth) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF186CAC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Color(0xFF186CAC),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.038,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Page Indicators
          _buildPageIndicators(),
          
          SizedBox(height: screenHeight * 0.03),
          
          // Navigation Buttons - Previous on left, Continue/Get Started centered
          Obx(() => Stack(
            children: [
              // Previous Button - positioned on the left
              if (!controller.isFirstPage)
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.previousPage();
                      pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF186CAC).withOpacity(0.1),
                        border: Border.all(
                          color: Color(0xFF186CAC).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.left_chevron,
                        color: Color(0xFF186CAC),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              
              // Main Action Button - centered
              Center(
                child: _buildMainButton(screenWidth),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: controller.currentIndex.value == index ? 24 : 8,
          decoration: BoxDecoration(
            color: controller.currentIndex.value == index
                ? Color(0xFF186CAC)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    ));
  }

  Widget _buildMainButton(double screenWidth) {
    return Obx(() => AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: controller.isLastPage ? screenWidth * 0.4 : screenWidth * 0.4,
      child: ElevatedButton(
        onPressed: controller.isLastPage
            ? controller.skipToLogin
            : () {
                controller.nextPage();
                pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF186CAC),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.isLastPage ? 'Get Started' : 'Continue',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              controller.isLastPage
                  ? CupertinoIcons.rocket_fill
                  : CupertinoIcons.right_chevron,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    ));
  }
}
