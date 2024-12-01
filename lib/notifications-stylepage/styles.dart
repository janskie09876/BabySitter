import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFFFFDEDE); // Light pink
  static const Color secondaryColor = Color(0xFFE3838E); // Rose pink
  static const Color backgroundColor = Color(0xFFFFF4F4); // Very light pink
  static const Color textColor = Color(0xFF424242); // Dark grey
  static const Color whiteColor = Color(0xFFFFFFFF); // White

  // Padding Constants
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0); // Default padding for elements
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 15.0); // Padding for sections
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(vertical: 10.0); // Padding for fields
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0); // Padding for buttons

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: whiteColor,
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: primaryColor,
    minimumSize: Size(0, 48),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
    minimumSize: Size(0, 48),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: secondaryColor, width: 2),
    ),
  );

  static final ButtonStyle tertiaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: textColor,
    foregroundColor: primaryColor,
    minimumSize: Size(0, 48),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Text Field
  static final InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Card Style
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // App Bar Theme
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: whiteColor),
    titleTextStyle: TextStyle(
      color: whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}