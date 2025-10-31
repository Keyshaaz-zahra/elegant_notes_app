import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.pink.shade50,
    colorScheme: ColorScheme.light(
      primary: Colors.pinkAccent,
      secondary: Colors.pink.shade200,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink.shade100,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: Colors.pink.shade700,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.pinkAccent),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.pink.shade800,
      displayColor: Colors.pink.shade800,
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.85),
      shadowColor: Colors.pinkAccent.withOpacity(0.25),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    colorScheme: ColorScheme.dark(
      primary: Colors.pinkAccent.shade100,
      secondary: Colors.pinkAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.2),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: Colors.pinkAccent.shade100,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.pinkAccent.shade100),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pinkAccent.shade100,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.pink.shade100,
      displayColor: Colors.pink.shade100,
    ),
    cardTheme: CardThemeData(
      color: Colors.black.withOpacity(0.4),
      shadowColor: Colors.pinkAccent.withOpacity(0.3),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
