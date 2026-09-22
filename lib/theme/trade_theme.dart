import 'package:flutter/material.dart';

class TradeColors {
  static const primaryPurple = Color(0xFF9A8CFF);
  static const lightPurple = Color(0xFFC8C1FF);
  static const darkPurple = Color(0xFF5B4CC4);
  static const purpleLight = Color(0xFF25223A);
  static const accentPink = Color(0xFFFD79A8);
  static const accentCyan = Color(0xFF00CEC9);
  static const accentLime = Color(0xFF9A8CFF);
  static const successGreen = Color(0xFF00B894);
  static const successLight = Color(0xFF55EFC4);
  static const errorRed = Color(0xFFD63031);
  static const errorLight = Color(0xFFFF7675);
  static const warningOrange = Color(0xFFFF7675);
  static const infoBlue = Color(0xFF74B9FF);
  static const background = Color(0xFF0B0D14);
  static const surface = Color(0xFF10121B);
  static const cardBackground = Color(0xFF141722);
  static const border = Color(0xFF30352B);
  static const primaryText = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFFB2BEC3);
  static const tertiaryText = Color(0xFF636E72);

  static const darkPurpleGradient = LinearGradient(
    colors: [surface, cardBackground, background],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class TradeTheme {
  static ThemeData get lightTheme => _theme(Brightness.light);
  static ThemeData get darkTheme => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TradeColors.primaryPurple,
        brightness: brightness,
        primary: TradeColors.primaryPurple,
        secondary: TradeColors.lightPurple,
        surface: TradeColors.surface,
        error: TradeColors.errorRed,
      ),
      scaffoldBackgroundColor: TradeColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: TradeColors.surface,
        foregroundColor: TradeColors.primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: TradeColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: TradeColors.primaryPurple,
        foregroundColor: TradeColors.primaryText,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: TradeColors.primaryText),
        displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: TradeColors.primaryText),
        headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: TradeColors.primaryText),
        headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: TradeColors.primaryText),
        titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: TradeColors.primaryText),
        bodyLarge: TextStyle(fontSize: 16, color: TradeColors.primaryText),
        bodyMedium: TextStyle(fontSize: 14, color: TradeColors.secondaryText),
        bodySmall: TextStyle(fontSize: 12, color: TradeColors.tertiaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TradeColors.cardBackground,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: TradeColors.surface,
        selectedItemColor: TradeColors.primaryPurple,
        unselectedItemColor: TradeColors.secondaryText,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class TradeThemes {
  static ThemeData get lightTheme => TradeTheme.lightTheme;
  static ThemeData get darkTheme => TradeTheme.darkTheme;
}
