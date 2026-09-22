import 'package:flutter/material.dart';

class TradeColors {
  static const primaryPurple = Color(0xFF9A8CFF);
  static const lightPurple = Color(0xFFC8C1FF);
  static const darkPurple = Color(0xFF5B4CC4);
  static const purpleLight = Color(0xFF25223A);
  static const accentPink = Color(0xFFFD79A8);
  static const accentCyan = Color(0xFF00CEC9);
  static const accentLime = Color(0xFF00B894);
  static const successGreen = Color(0xFF00B894);
  static const successLight = Color(0xFF55EFC4);
  static const errorRed = Color(0xFFD63031);
  static const errorLight = Color(0xFFFF7675);
  static const warningOrange = Color(0xFFE17055);
  static const infoBlue = Color(0xFF74B9FF);
  // dark palette
  static const background = Color(0xFF0B0D14);
  static const surface = Color(0xFF10121B);
  static const cardBackground = Color(0xFF141722);
  static const border = Color(0xFF2A2E3A);
  static const primaryText = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFFB2BEC3);
  static const tertiaryText = Color(0xFF636E72);
  // light palette
  static const lightBackground = Color(0xFFF5F6FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE3E6EE);
  static const lightPrimaryText = Color(0xFF1A1E2E);
  static const lightSecondaryText = Color(0xFF6B7280);
  static const lightTertiaryText = Color(0xFF9CA3AF);

  static const darkPurpleGradient = LinearGradient(
    colors: [surface, cardBackground, background],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Builds ThemeData dynamically based on brightness + accent.
class AppTheme {
  static ThemeData build({required Brightness brightness, required Color accent}) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? TradeColors.background : TradeColors.lightBackground;
    final sf = isDark ? TradeColors.surface : TradeColors.lightSurface;
    final card = isDark ? TradeColors.cardBackground : TradeColors.lightCard;
    final bdr = isDark ? TradeColors.border : TradeColors.lightBorder;
    final pt = isDark ? TradeColors.primaryText : TradeColors.lightPrimaryText;
    final st = isDark ? TradeColors.secondaryText : TradeColors.lightSecondaryText;
    final tt = isDark ? TradeColors.tertiaryText : TradeColors.lightTertiaryText;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
        primary: accent,
        secondary: accent.withValues(alpha: 0.85),
        surface: sf,
        error: TradeColors.errorRed,
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: pt,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: isDark ? 4 : 1,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: pt),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: pt),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: pt),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: pt),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: pt),
        bodyLarge: TextStyle(fontSize: 16, color: pt),
        bodyMedium: TextStyle(fontSize: 14, color: st),
        bodySmall: TextStyle(fontSize: 12, color: tt),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: bdr)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: sf,
        selectedItemColor: accent,
        unselectedItemColor: st,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        selectedColor: accent.withValues(alpha: 0.15),
        backgroundColor: Colors.transparent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? accent : null),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? accent.withValues(alpha: 0.4) : null),
      ),
    );
  }
}

// Backward compat
class TradeTheme {
  static ThemeData get lightTheme => AppTheme.build(brightness: Brightness.light, accent: TradeColors.primaryPurple);
  static ThemeData get darkTheme => AppTheme.build(brightness: Brightness.dark, accent: TradeColors.primaryPurple);
}

class TradeThemes {
  static ThemeData get lightTheme => TradeTheme.lightTheme;
  static ThemeData get darkTheme => TradeTheme.darkTheme;
}
