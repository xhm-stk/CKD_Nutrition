import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === Colors Tokens (White-Blue Theme Edition) ===
  static const Color bgBase = Color(0xFF030712); // Deep Ocean Night
  static const Color bgSurface = Color(0xFF0F172A); // Dark Slate Blue
  static const Color bgElevated = Color(0xFF1E293B); // Elevated Slate

  static const Color brandPrimary = Color(0xFF0284C7); // Sky Blue / Ocean Blue
  static const Color brandSecondary = Color(0xFFF59E0B); // Amber Gold
  static const Color brandAccent = Color(0xFF38BDF8); // Light Sky Accent

  static const Color textHighEmphasis =
      Colors.white; // opacity adjusted in theme
  static const Color textMediumEmphasis = Colors.white70;
  static const Color textLowEmphasis = Colors.white38;

  // Danger/Warning
  static const Color errorBase = Color(0xFFEF4444); // Ruby Red

  // === Shape Tokens ===
  static const double radiusSmall = 16.0;
  static const double radiusMedium = 24.0;
  static const double radiusLarge = 32.0;

  static Color getBase(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color getSurface(BuildContext context) =>
      Theme.of(context).cardTheme.color ??
      Theme.of(context).colorScheme.surface;
  static Color getElevated(BuildContext context) =>
      Theme.of(context).dialogTheme.backgroundColor ??
      Theme.of(context).colorScheme.surface;
  static Color getBorderColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.05);

  // === Typography Tokens ===
  static TextTheme _buildTextTheme(
    TextTheme base,
    Color textColor,
    Color subtitleColor,
  ) {
    return GoogleFonts.promptTextTheme(base).copyWith(
      displayLarge: GoogleFonts.prompt(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: textColor,
      ),
      displayMedium: GoogleFonts.prompt(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.prompt(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.prompt(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: subtitleColor,
      ),
      labelSmall: GoogleFonts.prompt(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: subtitleColor.withValues(alpha: 0.6),
      ),
    );
  }

  // === Light Theme ===
  static final lightColorScheme = ColorScheme.light(
    primary: brandPrimary,
    secondary: brandSecondary,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF0F172A),
    error: errorBase,
    errorContainer: errorBase.withValues(alpha: 0.1),
    onErrorContainer: errorBase,
    tertiaryContainer: brandSecondary.withValues(alpha: 0.1),
    onTertiaryContainer: brandSecondary,
  );

  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: const Color(
        0xFFF0F9FF,
      ), // Extremely light blue background (Sky 50)
      textTheme: _buildTextTheme(
        base.textTheme,
        const Color(0xFF0F172A), // Slate 900 for high emphasis
        const Color(0xFF475569), // Slate 600 for medium emphasis
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF0F9FF),
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: brandPrimary,
        unselectedItemColor: Color(0xFF94A3B8),
        elevation: 10,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: GoogleFonts.prompt(
          fontSize: 14,
          color: const Color(0xFF94A3B8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: brandPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorBase, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.prompt(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
    );
  }
}
