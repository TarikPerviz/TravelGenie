import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class TGColors {
  static const primary = Color(0xFF1061FF); // tvoj plavi
  static const text = Color(0xFF1B1E28);
  static const subtext = Color(0xFF8D929A);
}

ThemeData tgTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: TGColors.primary),
    useMaterial3: true,
  );

  // iOS => null (koristi SF Pro Display automatski)
  // Android => Inter (iz assets/fonts/)
  final fontFamily = Platform.isIOS ? null : 'Inter';

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: fontFamily,
      bodyColor: TGColors.text,
      displayColor: TGColors.text,
    ),
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
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: TGColors.text,
    ),
  );
}
