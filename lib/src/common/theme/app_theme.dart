import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color darkGreen = Color(0xFF2C6B6B); // Primary dark teal green
  static const Color lightGreen = Color(0xFFB4FF39); // Accent lime green
  
  static const Color primaryColor = darkGreen; // Changed from blue to dark green
  static const Color secondaryColor = Color(0xFF5856D6); // iOS Purple
  static const Color scaffoldBackgroundColor = CupertinoColors.systemGroupedBackground;
  
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    barBackgroundColor: CupertinoColors.systemGrey6.withOpacity(0.8),
    textTheme: const CupertinoTextThemeData(
      primaryColor: primaryColor,
      textStyle: TextStyle(fontFamily: '.SF Pro Text'),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.systemGrey6.withOpacity(0.8),
    textTheme: const CupertinoTextThemeData(
      primaryColor: primaryColor,
      textStyle: TextStyle(fontFamily: '.SF Pro Text'),
    ),
  );
}
