import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    // Primary color: A deep, mystical blue, reminiscent of Pandora's bioluminescent elements
    primary: const Color(0xFF1E88E5), // A vibrant blue

    // Secondary color: A darker, muted blue-green for background elements
    secondary: const Color(0xFF004D40), // Dark teal/green

    // Tertiary color: A lighter, more luminous green for accents and interactive elements
    tertiary: const Color(0xFF8BC34A), // Lime green/bright green

    // Inverse Primary: A soft, ethereal glow for text or icons that need to stand out against dark backgrounds
    inversePrimary: const Color(0xFFE0F7FA), // Light cyan/pale blue

    // Surface color: For cards, sheets, and other elevated surfaces – a slightly lighter shade of the secondary
    surface: const Color(0xFF00362C), // Darker teal

    // Error color: A contrasting but still somewhat naturalistic red for warnings/errors
    error: const Color(0xFFD32F2F), // Muted red

    // OnPrimary: Color for text and icons on the primary color
    onPrimary: Colors.white,

    // OnSecondary: Color for text and icons on the secondary color
    onSecondary: Colors.white,

    // OnSurface: Color for text and icons on the surface color
    onSurface: Colors.white70,

    // OnError: Color for text and icons on the error color
    onError: Colors.white,
  ),
  // Scaffold background: The main background color for your app's screens
  scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Very dark, almost black
  // You can also adjust text themes, button themes, etc., here for more detailed styling
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0F7FA)), // Light text for general content
    bodyMedium: TextStyle(color: Color(0xFFB2EBF2)), // Slightly less bright text
    headlineSmall: TextStyle(color: Color(0xFF8BC34A)), // Green accents for headlines
    // Define other text styles as needed
  ),
  // Further theming for elements like buttons, app bars, etc.
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF004D40), // Secondary color for AppBar
    foregroundColor: Colors.white, // Text/icon color on AppBar
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF1E88E5), // Primary blue for buttons
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Rounded button corners
    ),
  ),
  // Add more theme properties here for a complete design system
);
