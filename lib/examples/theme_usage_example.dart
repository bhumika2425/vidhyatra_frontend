// Example of how to use AppThemes constants throughout the app

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_themes.dart';

// Example widget showing how to use the theme constants
class ExampleThemedWidget extends StatelessWidget {
  const ExampleThemedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.secondaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.appBarColor,
        title: Text(
          'Themed Example',
          style: GoogleFonts.poppins(
            color: AppThemes.appBarTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppThemes.appBarTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemes.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.cardShadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Primary Text',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppThemes.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secondary text with consistent theming',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppThemes.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Example input field
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter some text',
                hintStyle: TextStyle(color: AppThemes.hintTextColor),
                filled: true,
                fillColor: AppThemes.inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppThemes.inputBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppThemes.inputFocusedBorderColor, width: 2),
                ),
              ),
              style: GoogleFonts.poppins(
                color: AppThemes.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Example buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryButtonColor,
                    foregroundColor: AppThemes.primaryButtonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Primary Button',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppThemes.darkMaroon,
                    side: BorderSide(color: AppThemes.darkMaroon),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Outlined Button',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Example divider
            Divider(color: AppThemes.dividerColor),
            
            const SizedBox(height: 20),
            
            // Example success/error messages
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppThemes.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppThemes.successColor),
              ),
              child: Text(
                'Success message using theme colors',
                style: GoogleFonts.poppins(
                  color: AppThemes.successColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 
How to use AppThemes constants:

1. Colors:
   - AppThemes.darkMaroon (primary brand color)
   - AppThemes.grey (secondary color)  
   - AppThemes.white (backgrounds, text on dark)
   - AppThemes.lightGrey (light backgrounds)

2. Text Colors:
   - AppThemes.primaryTextColor (main text)
   - AppThemes.secondaryTextColor (secondary text)
   - AppThemes.hintTextColor (hints, placeholders)

3. Background Colors:
   - AppThemes.primaryBackgroundColor (main background)
   - AppThemes.secondaryBackgroundColor (secondary background)

4. UI Element Colors:
   - AppThemes.appBarColor (app bars)
   - AppThemes.appBarTextColor (app bar text)
   - AppThemes.primaryButtonColor (primary buttons)
   - AppThemes.primaryButtonTextColor (primary button text)
   - AppThemes.inputFillColor (input backgrounds)
   - AppThemes.inputBorderColor (input borders)
   - AppThemes.inputFocusedBorderColor (focused input borders)
   - AppThemes.cardColor (card backgrounds)
   - AppThemes.dividerColor (dividers, borders)

5. Status Colors:
   - AppThemes.errorColor (errors)
   - AppThemes.successColor (success messages)

Benefits:
- Consistent theming across the entire app
- Easy to change colors globally by modifying constants
- Better maintainability
- Dark maroon, grey, and white color scheme as requested
*/
