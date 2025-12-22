import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color darkGreen = Color(0xFF2C6B6B); // Primary dark teal green
  static const Color lightGreen = Color(0xFFB4FF39); // Accent lime green
  
  // Order Type Colors
  static const Color restaurantColor = Color(0xFF808000); // Olive for Restaurant
  static const Color pickupColor = Color(0xFFBA5B18); // Blue for Pickup
  
  // Border Radius
  static const double cardBorderRadius = 12.0;
  static final BorderRadius cardRadius = BorderRadius.circular(cardBorderRadius);
  static final BorderRadius smallRadius = BorderRadius.circular(8.0);
  static final BorderRadius largeRadius = BorderRadius.circular(16.0);
  
  static const Color primaryColor = darkGreen;
  static const Color secondaryColor = lightGreen;
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
