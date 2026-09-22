import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  // default dark
  static const background = Color(0xFF0B0D14);
  static const surface = Color(0xFF10121B);
  static const cardBackground = Color(0xFF141722);
  static const border = Color(0xFF2A2E3A);
  static const primaryText = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFFB2BEC3);
  static const tertiaryText = Color(0xFF636E72);
  // default light (now overridden by preset when used)
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

/// Palette that a theme builds from — changes with preset
class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
  });
  final Color background, surface, card, border, primaryText, secondaryText, tertiaryText;
}

/// Builds ThemeData dynamically — now with per-preset palette override.
class AppTheme {
  /// Call with preset if available; falls back to default light/dark.
  static ThemeData build({
    required Brightness brightness,
    required Color accent,
    AppPalette? palette,
  }) {
    final isDark = brightness == Brightness.dark;
    // resolve palette
    final bg = palette?.background ?? (isDark ? TradeColors.background : TradeColors.lightBackground);
    final sf = palette?.surface ?? (isDark ? TradeColors.surface : TradeColors.lightSurface);
    final card = palette?.card ?? (isDark ? TradeColors.cardBackground : TradeColors.lightCard);
    final bdr = palette?.border ?? (isDark ? TradeColors.border : TradeColors.lightBorder);
    final pt = palette?.primaryText ?? (isDark ? TradeColors.primaryText : TradeColors.lightPrimaryText);
    final st = palette?.secondaryText ?? (isDark ? TradeColors.secondaryText : TradeColors.lightSecondaryText);
    final tt = palette?.tertiaryText ?? (isDark ? TradeColors.tertiaryText : TradeColors.lightTertiaryText);

    final baseText = GoogleFonts.plusJakartaSansTextTheme(ThemeData(brightness: brightness).textTheme);

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
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accent, foregroundColor: Colors.white),
      textTheme: baseText.copyWith(
        displayLarge: baseText.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w700, color: pt),
        displayMedium: baseText.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: pt),
        headlineMedium: baseText.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: pt),
        headlineSmall: baseText.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w500, color: pt),
        titleLarge: baseText.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: pt, letterSpacing: -0.2),
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16, color: pt),
        bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 14, color: st),
        bodySmall: baseText.bodySmall?.copyWith(fontSize: 12, color: tt),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: bdr)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: sf, selectedItemColor: accent, unselectedItemColor: st, type: BottomNavigationBarType.fixed),
      chipTheme: ChipThemeData(selectedColor: accent.withValues(alpha: 0.15), backgroundColor: Colors.transparent),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? accent : null),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? accent.withValues(alpha: 0.4) : null),
      ),
      dividerColor: bdr,
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
