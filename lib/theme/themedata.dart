import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // Define light theme colors, fonts, etc.
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(

        onPrimary: Colors.black,
        onSecondary: Colors.white,
        primary: Colors.deepOrangeAccent,
        secondary: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.yellow,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      colorScheme: const ColorScheme.dark(
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        primary: Colors.deepOrangeAccent,
        secondary: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.yellow,
    );
  }
}
