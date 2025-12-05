import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------
// 1. CORE COLOR PALETTE DEFINITIONS
// -----------------------------------------------------------------
class MovieColors {
  // --- BASE ACCENT: NEON GREEN (Primary) ---
  static const Color greenLight = Color(0xFF2E6F40); // Vivid Green
  static const Color greenDark = Color(0xFF68BA7F);  // Neon Mint Green

  // --- BASE NEUTRAL: PURE BLACK / GREY (Secondary/Background) ---
  static const Color blackPure = Color(0xFF000000);
  static const Color blackSurface = Color(0xFF121212);
  static const Color greyDark = Color(0xFF212121);
  static const Color greyLight = Color(0xFFF5F5F5);

  // --- BASE ACCENT: ORANGE-YELLOW (Tertiary/Stars/Highlights) ---
  static const Color amberLight = Color(0xFFFFAB00); // Deep Amber
  static const Color amberDark = Color(0xFFFFD740);  // Bright Gold

  // --- VARIANT: GREEN ---
  static const Color greenLowestLight = Color(0xFFDAF4DB);
  static const Color greenLowestDark = Color(0xFF003318);

  static const Color greenLowLight = Color(0xFFA5D6A7);
  static const Color greenLowDark = Color(0xFF004D26);

  // --- VARIANT: ORANGE-YELLOW ---
  static const Color amberLowestLight = Color(0xFFFFF8E1);
  static const Color amberLowestDark = Color(0xFF3E2704);

  // --- TEXT COLORS ---
  static const Color textOnLight = Color(0xFF1A1A1A);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

// -----------------------------------------------------------------
// 2. LIGHT THEME (Material 3)
// -----------------------------------------------------------------
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // Define the Material 3 Color Scheme
  colorScheme: const ColorScheme.light(
    // PRIMARY: Green (Actions, Buttons)
    primary: MovieColors.greenLight,
    onPrimary: Colors.white,
    primaryContainer: MovieColors.greenLowestLight,
    onPrimaryContainer: MovieColors.greenLowDark,

    // SECONDARY: Black/Dark Grey (Less prominent UI)
    secondary: MovieColors.blackSurface,
    onSecondary: Colors.white,
    secondaryContainer: MovieColors.greyLight,
    onSecondaryContainer: MovieColors.blackPure,

    // TERTIARY: Orange-Yellow (Stars, Badges, Highlights)
    tertiary: MovieColors.amberLight,
    onTertiary: Colors.black,
    tertiaryContainer: MovieColors.amberLowestLight,
    onTertiaryContainer: MovieColors.amberLowestDark,

    // ERROR
    error: Color(0xFFBA1A1A),
    onError: Colors.white,

    // SURFACES
    surface: Colors.white,
    onSurface: MovieColors.textOnLight,
    surfaceContainer: MovieColors.greyLight, // Card Backgrounds
    surfaceContainerHighest: Color(0xFFE0E0E0), // Dividers/Inputs
    onSurfaceVariant: Color(0xFF424242), // Subtitles

    outline: Color(0xFF757575),
  ),

  // Font: Poppins (Modern, Clean)
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
    displayLarge: GoogleFonts.poppins(
      color: MovieColors.blackPure,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      color: MovieColors.blackPure,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: MovieColors.textOnLight,
    ),
    bodyLarge: GoogleFonts.poppins(color: MovieColors.textOnLight),
    bodyMedium: GoogleFonts.poppins(color: MovieColors.textOnLight),
  ),

  // Component Themes
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: MovieColors.blackPure,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black.withAlpha(20),
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.withAlpha(30), width: 1),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MovieColors.greenLight,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    ),
  ),

  iconTheme: const IconThemeData(color: MovieColors.blackPure),
);

// -----------------------------------------------------------------
// 3. DARK THEME (Material 3) - The "YTS" Look
// -----------------------------------------------------------------
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    // PRIMARY: Neon Green (Pop against black)
    primary: MovieColors.greenDark,
    onPrimary: MovieColors.blackPure, // Black text on neon green
    primaryContainer: MovieColors.greenLowDark,
    onPrimaryContainer: MovieColors.greenDark,

    // SECONDARY: Orange-Yellow (Used for Secondary actions in Dark Mode)
    secondary: MovieColors.amberDark,
    onSecondary: MovieColors.blackPure,
    secondaryContainer: MovieColors.amberLowestDark,
    onSecondaryContainer: MovieColors.amberDark,

    // TERTIARY: Orange-Yellow (Stars, Badges)
    tertiary: MovieColors.amberDark,
    onTertiary: MovieColors.blackPure,

    // ERROR
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),

    // SURFACES (Deep Black/Grey)
    surface: MovieColors.blackSurface, // #121212
    onSurface: MovieColors.textOnDark,
    surfaceContainer: MovieColors.greyDark, // #212121 (Cards)
    surfaceContainerHighest: Color(0xFF424242), // Dividers
    onSurfaceVariant: Color(0xFFBDBDBD), // Subtitles

    outline: Color(0xFF616161),
  ),

  // Font: Poppins (Light text)
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
    displayLarge: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.poppins(color: Color(0xFFEEEEEE)),
    bodyMedium: GoogleFonts.poppins(color: Color(0xFFE0E0E0)),
  ),

  // Component Themes
  appBarTheme: const AppBarTheme(
    backgroundColor: MovieColors.blackSurface,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
  ),

  cardTheme: CardThemeData(
    color: MovieColors.greyDark, // Slightly lighter than background
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      // Subtle neon green border for cool effect
      side: BorderSide(color: MovieColors.greenDark.withAlpha(20), width: 1),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MovieColors.greenDark,
      foregroundColor: MovieColors.blackPure,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    ),
  ),

  iconTheme: const IconThemeData(color: Colors.white),
);