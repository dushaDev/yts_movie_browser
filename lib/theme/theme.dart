import 'package:flutter/material.dart';

class AppTheme {
  // --- 1. Design Constants ---
  static const double _cardBorderRadius = 16.0;
  static const String _fontFamily = 'Roboto';

  // --- 2. YTS Brand Colors ---
  static const Color _ytsGreen = Color(0xFF6AC045);
  static const Color _ytsBlue = Color(0xFF2F80ED);
  static const Color _ytsYellow = Color(0xFFF5C518);

  // YTS Dark Background #171717
  static const Color _darkBackground = Color(0xFF171717);
  static const Color _darkSurface = Color(0xFF242424);

  // --- 3. Global Text Theme ---
  static const TextTheme _baseTextTheme = TextTheme(
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // --- 4. Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.light,

    // UPDATED: 'background' is removed. Use 'surface'.
    colorScheme: ColorScheme.fromSeed(
      seedColor: _ytsGreen,
      brightness: Brightness.light,
      primary: _ytsGreen,
      onPrimary: Colors.white,
      secondary: _ytsBlue,
      tertiary: _ytsYellow,
      surface: Colors.white,
      onSurface: Colors.black,
    ),

    textTheme: _baseTextTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black,
    ),

    // UPDATED: Standard CardTheme usage
    cardTheme: CardThemeData(
      color: Colors.grey[100],
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );

  // --- 5. Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.dark,

    // UPDATED: 'background' is removed. We use 'surface' for the main BG.
    colorScheme: ColorScheme.fromSeed(
      seedColor: _ytsGreen,
      brightness: Brightness.dark,
      primary: _ytsGreen,
      onPrimary: Colors.white,
      secondary: _ytsBlue,
      tertiary: _ytsYellow,
      surface: _darkBackground, // Replaces old 'background'
      onSurface: Colors.white,
    ),

    textTheme: _baseTextTheme.apply(
      bodyColor: const Color(0xFFE0E0E0),
      displayColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
    ),

    scaffoldBackgroundColor: _darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
    ),
  );
}
