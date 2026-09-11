import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Primary (Indigo)
  static const Color primary = Color(0xFF4355B9);
  static const Color primaryContainer = Color(0xFF3244A8);
  static const Color primaryFixed = Color(0xFFDEE0FF);
  static const Color onPrimaryFixed = Color(0xFF00105C);

  // Brand Secondary (Slate / Slate Navy)
  static const Color secondary = Color(0xFF565F71);
  static const Color secondaryContainer = Color(0xFF3E4758);
  static const Color secondaryFixed = Color(0xFFDAE2F9);
  static const Color onSecondaryFixed = Color(0xFF131C2C);

  // Brand Tertiary (Emerald Teal / Jade)
  static const Color tertiary = Color(0xFF2A6A4E);
  static const Color tertiaryContainer = Color(0xFF1B5139);
  static const Color tertiaryFixed = Color(0xFFAEF2CD);
  static const Color tertiaryFixedDim = Color(0xFF93D5B2);
  static const Color onTertiaryFixed = Color(0xFF002113);

  // Brand Error / Urgent
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Neutral Outlines & Surfaces
  static const Color outline = Color(0xFF74777F);
  static const Color outlineVariant = Color(0xFFC4C6D0);

  // Surfaces Light
  static const Color surfaceLight = Color(0xFFF9F9FC);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowLight = Color(0xFFF3F3F7);
  static const Color surfaceContainerLight = Color(0xFFEDEDF2);
  static const Color surfaceContainerHighLight = Color(0xFFE7E7EC);

  // Surfaces Dark
  static const Color surfaceDark = Color(0xFF121316);
  static const Color surfaceContainerLowestDark = Color(0xFF1A1B1F);
  static const Color surfaceContainerLowDark = Color(0xFF202126);
  static const Color surfaceContainerDark = Color(0xFF27282E);
  static const Color surfaceContainerHighDark = Color(0xFF303138);
}

class AppTheme {
  static ThemeData get lightTheme => light();
  static ThemeData get darkTheme => dark();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryFixed,
        onPrimaryContainer: AppColors.onPrimaryFixed,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryFixed,
        onSecondaryContainer: AppColors.onSecondaryFixed,
        tertiary: AppColors.tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.tertiaryFixed,
        onTertiaryContainer: AppColors.onTertiaryFixed,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surfaceLight,
        onSurface: const Color(0xFF191C20),
        onSurfaceVariant: const Color(0xFF44474E),
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      cardTheme: CardThemeData(
        elevation: 1,
        color: AppColors.surfaceContainerLowestLight,
        shape: roundedCornerShape(16),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFB9C3FF),
        onPrimary: const Color(0xFF0C248A),
        primaryContainer: const Color(0xFF2A3D9F),
        onPrimaryContainer: AppColors.primaryFixed,
        secondary: const Color(0xFFBFC6DC),
        onSecondary: const Color(0xFF283141),
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.secondaryFixed,
        tertiary: const Color(0xFF93D5B2),
        onTertiary: const Color(0xFF003823),
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.tertiaryFixed,
        error: const Color(0xFFFFB4AB),
        onError: const Color(0xFF690005),
        errorContainer: const Color(0xFF93000A),
        onErrorContainer: AppColors.errorContainer,
        surface: AppColors.surfaceDark,
        onSurface: const Color(0xFFE2E2E6),
        onSurfaceVariant: const Color(0xFFC4C6D0),
        outline: const Color(0xFF8E9099),
        outlineVariant: const Color(0xFF44474E),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      cardTheme: CardThemeData(
        elevation: 1,
        color: AppColors.surfaceContainerLowestDark,
        shape: roundedCornerShape(16),
      ),
    );
  }
}

ShapeBorder roundedCornerShape(double radius) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
