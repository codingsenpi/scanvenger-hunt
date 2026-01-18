import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme {
  static const Color pastelGreen = Color(0xFFA8D8B9);
  static const Color pastelPink = Color(0xFFFFDDE1);
  static const Color pastelBlue = Color(0xFFC0DEFF);
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF263238);
  static final ThemeData pastelLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: pastelGreen,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: pastelGreen,
      secondary: pastelPink,
      background: backgroundLight,
      surface: cardLight,
      onPrimary: textDark,
      onSecondary: textDark,
      onBackground: textDark,
      onSurface: textDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: pastelGreen.withOpacity(0.7),
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: pastelGreen.withOpacity(0.5),
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: pastelGreen,
          width: 2.5,
        ),
      ),
      labelStyle: TextStyle(color: textDark.withOpacity(0.8)),
      prefixIconColor: textDark.withOpacity(0.6),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: textDark,
      displayColor: textDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardLight,
      foregroundColor: textDark,
      elevation: 1,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: cardLight,
      shadowColor: pastelGreen.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: pastelGreen,
        foregroundColor: textDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
