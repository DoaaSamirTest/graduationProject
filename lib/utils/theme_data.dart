import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFFAFAFA), // خلفية هادية شبه الصورة

  primaryColor: Color(0xFF2F6CAB), // أزرق هادي
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2F6CAB),
    secondary: Color(0xFFFDD835), // accent أصفر هادي
    background: Color(0xFFFAFAFA),
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2F6CAB),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2F6CAB),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF2F6CAB),
      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      // عناوين رئيسية
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2F6CAB),
    ),
    headlineMedium: TextStyle(
      // عناوين ثانوية
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xFF333333),
    ),
    titleMedium: TextStyle(
      // عناوين الأقسام
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF333333),
    ),
    bodyLarge: TextStyle(
      // نص رئيسي
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Color(0xFF333333),
    ),
    bodyMedium: TextStyle(
      // وصف أو تعليمات
      fontSize: 14,
      color: Color(0xFF757575),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF2F6CAB)),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF2F6CAB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF2F6CAB), width: 2),
    ),
    labelStyle: TextStyle(color: Color(0xFF2F6CAB)),
  ),
);
