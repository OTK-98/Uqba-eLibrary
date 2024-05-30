import 'package:flutter/material.dart';

import 'colors.dart';

var lightTheme = ThemeData(
  useMaterial3: true,

  //  ❤️  Color style Define
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: backgroudColor,
    secondary: secondryColor,
    onSecondary: backgroudColor,
    error: Colors.red,
    onError: fontColor,
    background: backgroudColor,
    onBackground: fontColor,
    surface: backgroudColor,
    onSurface: fontColor,
    onPrimaryContainer: secondLebelColor,
  ),

  // ❤️  Text Style Define
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      fontFamily: "Amiri",
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
        fontFamily: "Amiri",
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: lebelColor),
    labelMedium: TextStyle(
        fontFamily: "Amiri",
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: lebelColor),
    labelSmall: TextStyle(
        fontFamily: "Amiri",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: lebelColor),
  ),
);

// ======================== Dark Theme =========================

var darkTheme = ThemeData(
  useMaterial3: true,

  //  ❤️  Color style Define
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF15202B), // لون Dim
    onPrimary: Colors.white, // لون النص على اللون Dim
    secondary: Color(0xFF00E676), // لون ثانوي
    onSecondary: Colors.black, // لون النص على اللون الثانوي
    error: Colors.red,
    onError: Colors.white, // لون النص على الخطأ
    background: Color(0xFF121212), // لون الخلفية الداكنة
    onBackground: Colors.white, // لون النص على الخلفية
    surface: Color(0xFF121212), // لون السطح
    onSurface: Colors.white, // لون النص على السطح
    onPrimaryContainer: Colors.grey, // لون النص على الخلفية الداكنة
  ),

  // ❤️  Text Style Define
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: "Amiri",
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontFamily: "Amiri",
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  ),
);
