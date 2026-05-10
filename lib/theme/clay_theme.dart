import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClayTheme {
  // Claymorphism Color Palette
  static const Color background = Color(0xFFF2EBE5);
  static const Color textDark = Color(0xFF3A3532);
  static const Color textLight = Color(0xFF7A7572);
  
  // Accents
  static const Color mintGreen = Color(0xFFA9CDB9);
  static const Color lightBlue = Color(0xFFB4D5E5);
  static const Color softPink = Color(0xFFEBC8C4);
  
  // Shadows
  static const Color shadowLight = Colors.white;
  static const Color shadowDark = Color(0xFFD6CEC6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mintGreen,
        brightness: Brightness.light,
        primary: mintGreen,
        secondary: lightBlue,
        tertiary: softPink,
        surface: background,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w800),
        displaySmall: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: textDark,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      // We override default card/input styles to match the background
      // so they can be replaced by ClayContainers
      cardTheme: CardThemeData(
        elevation: 0,
        color: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
