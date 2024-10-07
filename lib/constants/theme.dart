import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightTheme() {
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.baseColor,
        brightness: Brightness.light,
        error: ThemeColors.errorColor,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.baseColor,
        brightness: Brightness.dark,
        error: ThemeColors.errorColor,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}

class ThemeColors {
  static const Color baseColor = Colors.deepPurple;
  static const Color errorColor = Colors.red;
  static const Color accentColor = Color.fromARGB(255, 76, 175, 158);
}
