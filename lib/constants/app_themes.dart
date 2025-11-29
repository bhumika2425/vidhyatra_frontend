import 'package:flutter/material.dart';

class AppThemes {
  // Private constructor to prevent instantiation
  AppThemes._();

  // Primary color palette
  static const Color darkMaroon = Color(0xFF8B0000); // Dark maroon color
  static const Color grey = Color(0xFF6B7280); // Medium grey
  static const Color lightGrey = Color(0xFFF3F4F6); // Light grey for backgrounds
  static const Color white = Color(0xFFFFFFFF); // Pure white
  
  // Additional grey shades for better UI
  static const Color darkGrey = Color(0xFF374151); // Dark grey for text
  static const Color mediumGrey = Color(0xFF9CA3AF); // Medium grey for hints
  static const Color borderGrey = Color(0xFFD1D5DB); // Light grey for borders
  
  // Text colors
  static const Color primaryTextColor = darkGrey;
  static const Color secondaryTextColor = grey;
  static const Color hintTextColor = mediumGrey;
  
  // Background colors
  static const Color primaryBackgroundColor = white;
  static const Color secondaryBackgroundColor = lightGrey;
  
  // Button colors
  static const Color primaryButtonColor = darkMaroon;
  static const Color primaryButtonTextColor = white;
  
  // Error and success colors (keeping minimal)
  static const Color errorColor = Color(0xFFDC2626); // Red for errors
  static const Color successColor = Color(0xFF059669); // Green for success
  
  // App bar and primary elements
  static const Color appBarColor = darkMaroon;
  static const Color appBarTextColor = white;
  
  // Input field colors
  static const Color inputFillColor = white;
  static const Color inputBorderColor = borderGrey;
  static const Color inputFocusedBorderColor = darkMaroon;
  
  // Divider and separator colors
  static const Color dividerColor = borderGrey;
  
  // Card and container colors
  static const Color cardColor = white;
  static const Color cardShadowColor = Color(0x1A000000); // 10% black for subtle shadow
}
