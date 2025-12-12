import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF); // iOS Blue
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
