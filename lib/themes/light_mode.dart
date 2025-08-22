import 'package:flutter/material.dart';

/// Lottie-matched Nautical Palette
const _boatBlue   = Color(0xFF0E5AA7); // hull / primary
const _seaCyan = Color(0xFF92D3F5); // waves / secondary
const _sunYellow = Color(0xFFECBF4C); // sun / tertiary
const _sailWhite  = Color(0xFFFFFFFF); // sails / surfaces
const _foam       = Color(0xFFECF7FF); // bg foam
const _deepNavy   = Color(0xFF0B2942); // on-colors, headings
const _reefCoral  = Color(0xFFFF6B6B); // errors

final lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _boatBlue,
    brightness: Brightness.light,
  ).copyWith(
    primary: _boatBlue,
    onPrimary: Colors.white,
    secondary: _seaCyan,
    onSecondary: _deepNavy,
    tertiary: _sunYellow,
    onTertiary: _deepNavy,
    surface: _sailWhite,
    onSurface: _deepNavy,
    error: _reefCoral,
    onError: Colors.white,
    primaryContainer: _boatBlue.withAlpha(12),
    secondaryContainer: _seaCyan.withAlpha(15),
    tertiaryContainer: _sunYellow.withAlpha(18),
    outline: _deepNavy.withAlpha(20),
    outlineVariant: const Color(0xFFE2EAF4),
    inversePrimary: _seaCyan,
    inverseSurface: const Color(0xFF0F2130),
    onInverseSurface: Colors.white,
    shadow: Colors.black12,
    scrim: Colors.black54,
  ),

  scaffoldBackgroundColor: _foam,

  // iOS-leaning typography with strong titles (Duolingo vibe)
  textTheme: Typography.blackCupertino.copyWith(
    titleLarge: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .2),
    titleMedium: const TextStyle(fontWeight: FontWeight.w700),
    bodyLarge: const TextStyle(height: 1.25),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: _foam,
    foregroundColor: _deepNavy,
    elevation: 0,
    centerTitle: true,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF6FAFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: _boatBlue,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: _boatBlue,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: .2),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: _seaCyan,
      foregroundColor: _deepNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: _boatBlue,
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
);
