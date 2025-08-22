import 'package:flutter/material.dart';

/// Sailantro — Light Nautical Theme
/// Palette: Navy (primary), Teal (secondary), Sand (accent), Foam (surface)
const _navy = Color(0xFF0C2A43);
const _teal = Color(0xFF0FA3B1);
const _sand = Color(0xFFFFB13B);
const _foam = Color(0xFFE7F7FA);

final lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: _navy,
    onPrimary: Colors.white,
    secondary: _teal,
    onSecondary: Colors.white,
    tertiary: _sand,
    onTertiary: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF0C2A43),
    error: Color(0xFFE63946),
    onError: Colors.white,
    primaryContainer: Color(0xFF1A415F),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFFBCE9EE),
    onSecondaryContainer: Color(0xFF0C2A43),
    tertiaryContainer: Color(0xFFFFE2B8),
    onTertiaryContainer: Color(0xFF5B3B00),
    outline: Color(0xFF8EA3B5),
    outlineVariant: Color(0xFFE1E8EF),
    scrim: Colors.black54,
    shadow: Colors.black12,
    inversePrimary: Color(0xFFB3CCE5),
    inverseSurface: Color(0xFF0F2130),
    onInverseSurface: Colors.white,
  ),
  scaffoldBackgroundColor: _foam,

  // Typography tuned for iOS look (larger titles, heavy weights on headlines)
  textTheme: Typography.blackCupertino.copyWith(
    titleLarge: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .2),
    titleMedium: const TextStyle(fontWeight: FontWeight.w700),
    bodyLarge: const TextStyle(height: 1.25),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: _foam,
    foregroundColor: _navy,
    elevation: 0,
    centerTitle: true,
  ),


  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: _navy,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: .2),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: _teal,
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
);
