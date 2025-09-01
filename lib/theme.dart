import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class TGColors {
  static const primary = Color(0xFF1061FF);
  static const text = Color(0xFF1B1E28);
  static const subtext = Color(0xFF8D929A);
}

ThemeData tgTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: TGColors.primary),
    useMaterial3: true,
  );

  // iOS => SF, Android => Inter (assets/fonts/)
  final fontFamily = Platform.isIOS ? null : 'Inter';

  return base.copyWith(
    // Global typography
    textTheme: base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: TGColors.text,
      displayColor: TGColors.text,
    ),

    // Inputs (kapsule)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      hintStyle: const TextStyle(color: TGColors.subtext),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TGColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    // AppBar i Card bez surface tinga (nema sivih ploha)
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: TGColors.text,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: const CardThemeData(
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
    ),

    // Osnovne boje podloge
    scaffoldBackgroundColor: Colors.white,
    dividerColor: const Color(0xFFE6E9EE),
  );
}

ThemeData tgDarkTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: TGColors.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );

  final fontFamily = Platform.isIOS ? null : 'Inter';

  return base.copyWith(
    // Typography
    textTheme: base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),

    // AppBar / Card bez tinga
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF12141A),
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: const CardThemeData(
      surfaceTintColor: Colors.transparent,
      color: Color(0xFF151922),
    ),

    // Inputs (kapsule) – tamna ispunjena
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1B1F27),
      hintStyle: TextStyle(color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TGColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Osnovne boje podloge
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    dividerColor: const Color(0xFF2A2F3A),
  );
}
