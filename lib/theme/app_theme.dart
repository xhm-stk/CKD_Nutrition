import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === Colors Tokens ===
  static const Color bgBase = Color(
    0xFF090E17,
  ); // Void Navy (Background Layer 0)
  static const Color bgSurface = Color(
    0xFF131B2B,
  ); // Obsidian Blue (Card Layer 1)
  static const Color bgElevated = Color(
    0xFF1E293B,
  ); // Slate Navy (Modal Layer 2)

  static const Color brandPrimary = Color(0xFF00E5FF); // Neon Cyan
  static const Color brandSecondary = Color(0xFFF59E0B); // Amber Gold
  static const Color brandAccent = Color(0xFF10B981); // Emerald Green

  static const Color textHighEmphasis =
      Colors.white; // opacity adjusted in theme
  static const Color textMediumEmphasis = Colors.white70;
  static const Color textLowEmphasis = Colors.white38;

  // Danger/Warning
  static const Color errorBase = Color(0xFFEF4444); // Ruby Red

  // === Typography Tokens ===
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.promptTextTheme(base).copyWith(
      displayLarge: GoogleFonts.prompt(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: textHighEmphasis.withValues(alpha: 0.92),
      ),
      displayMedium: GoogleFonts.prompt(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textHighEmphasis.withValues(alpha: 0.92),
      ),
      bodyLarge: GoogleFonts.prompt(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textHighEmphasis.withValues(alpha: 0.92),
      ),
      bodyMedium: GoogleFonts.prompt(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: textMediumEmphasis,
      ),
      labelSmall: GoogleFonts.prompt(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: textLowEmphasis,
      ),
    );
  }

  // === Light Theme (Fallback, not used actively since locked to Dark Mode) ===
  static final lightColorScheme = ColorScheme.light(
    primary: Colors.teal.shade700,
    secondary: Colors.orange.shade600,
    surface: const Color(0xFFF8FAFC),
    onSurface: const Color(0xFF0F172A),
    errorContainer: Colors.red.shade50,
    onErrorContainer: Colors.red.shade900,
    tertiaryContainer: Colors.orange.shade50,
    onTertiaryContainer: Colors.orange.shade900,
  );

  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: lightColorScheme,
      textTheme: _buildTextTheme(base.textTheme),
    );
  }

  // === Ultimate Premium Dark Mode ===
  static final darkColorScheme = ColorScheme.dark(
    primary: brandPrimary,
    secondary: brandSecondary,
    surface: bgSurface,
    onSurface: textHighEmphasis.withValues(alpha: 0.92),
    error: errorBase,
    errorContainer: errorBase.withValues(alpha: 0.15),
    onErrorContainer: errorBase,
    tertiaryContainer: brandSecondary.withValues(alpha: 0.15),
    onTertiaryContainer: brandSecondary,
  );

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: bgBase,
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgBase,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgElevated,
        selectedItemColor: brandPrimary,
        unselectedItemColor: Colors.white38,
        elevation: 10,
      ),
      cardTheme: CardTheme(
        color: bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: GoogleFonts.prompt(fontSize: 14, color: textLowEmphasis),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: brandPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorBase, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor:
              brandPrimary, // Will be overridden by custom widgets with gradients
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.prompt(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
    );
  }
}
