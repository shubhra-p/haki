import 'package:flutter/material.dart';

/// Haki Design System — Color Tokens & Dual Theme Palette
///
/// Consolidated from DESIGN.md specification.
/// Supports both Light and Dark themes via adaptive tokens, while exposing
/// light and dark constants for explicit theme generation.
class HakiColors {
  HakiColors._();

  // Theme Mode State
  static bool _isDarkMode = false;

  /// Whether the app is currently rendering in dark mode
  static bool get isDarkMode => _isDarkMode;

  /// Updates active theme mode dynamically
  static void setDarkMode(bool dark) {
    _isDarkMode = dark;
  }

  // Raw Light Palette Constants
  static const Color lightPrimary = Color(0xFF1E1B4B);
  static const Color lightPrimaryDark = Color(0xFF070235);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFF1E1B4B);
  static const Color lightOnPrimaryContainer = Color(0xFF8683BA);
  static const Color lightInversePrimary = Color(0xFFC4C1FB);
  static const Color lightPrimaryFixed = Color(0xFFE3DFFF);
  static const Color lightPrimaryFixedDim = Color(0xFFC4C1FB);

  static const Color lightSurface = Color(0xFFFAF9F7);
  static const Color lightSurfaceWarm = Color(0xFFFDFCFA);
  static const Color lightSurfaceDim = Color(0xFFDADAD8);
  static const Color lightSurfaceBright = Color(0xFFFAF9F7);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFF4F3F1);
  static const Color lightSurfaceContainer = Color(0xFFEFEEEC);
  static const Color lightSurfaceContainerHigh = Color(0xFFE9E8E6);
  static const Color lightSurfaceContainerHighest = Color(0xFFE3E2E0);

  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFF1EFEA);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextDisabled = Color(0xFF94A3B8);
  static const Color lightTextInverse = Color(0xFFFFFFFF);

  static const Color lightOnSurface = Color(0xFF1A1C1B);
  static const Color lightOnSurfaceVariant = Color(0xFF47464F);
  static const Color lightInverseSurface = Color(0xFF2F3130);
  static const Color lightInverseOnSurface = Color(0xFFF1F1EF);

  static const Color lightInputBorder = Color(0xFFE2E8F0);
  static const Color lightNeutralTrack = Color(0xFFE2E8F0);
  static const Color lightDropzoneBackground = Color(0xFFF8FAFC);
  static const Color lightSheetHandle = Color(0xFFCBD5E1);

  static const Color lightEmeraldTint = Color(0xFFECFDF5);
  static const Color lightEmeraldBorder = Color(0xFFA7F3D0);
  static const Color lightRoseTint = Color(0xFFFFF1F2);
  static const Color lightRoseBorder = Color(0xFFFECDD3);

  // Raw Dark Palette Constants (Obsidian Indigo)
  static const Color darkPrimary = Color(0xFF818CF8); // Radiant indigo accent
  static const Color darkPrimaryDark = Color(0xFF4F46E5);
  static const Color darkOnPrimary =
      Color(0xFFFFFFFF); // Crisp white text on primary buttons
  static const Color darkPrimaryContainer = Color(0xFF262354);
  static const Color darkOnPrimaryContainer = Color(0xFFC7D2FE);
  static const Color darkInversePrimary = Color(0xFF1E1B4B);
  static const Color darkPrimaryFixed = Color(0xFF2E2A66);
  static const Color darkPrimaryFixedDim = Color(0xFF221F4D);

  static const Color darkSurface = Color(0xFF0D0C1D); // Deep obsidian canvas
  static const Color darkSurfaceWarm = Color(0xFF121124);
  static const Color darkSurfaceDim = Color(0xFF090814);
  static const Color darkSurfaceBright = Color(0xFF1B1934);
  static const Color darkSurfaceContainerLowest = Color(0xFF141328);
  static const Color darkSurfaceContainerLow = Color(0xFF181730);
  static const Color darkSurfaceContainer = Color(0xFF1E1C3B);
  static const Color darkSurfaceContainerHigh = Color(0xFF252347);
  static const Color darkSurfaceContainerHighest = Color(0xFF2C2954);

  static const Color darkCardBackground =
      Color(0xFF191832); // Elevated dark card
  static const Color darkCardBorder = Color(0xFF2A274E); // Crisp subtle border

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextDisabled = Color(0xFF64748B);
  static const Color darkTextInverse =
      Color(0xFFFFFFFF); // Pure white on inverted/colored surfaces

  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1);
  static const Color darkInverseSurface = Color(0xFFF1F1EF);
  static const Color darkInverseOnSurface = Color(0xFF191832);

  static const Color darkInputBorder = Color(0xFF2D2952);
  static const Color darkNeutralTrack = Color(0xFF252244);
  static const Color darkDropzoneBackground = Color(0xFF15132A);
  static const Color darkSheetHandle = Color(0xFF4E4A7A);

  static const Color darkEmeraldTint = Color(0xFF0A2B1E);
  static const Color darkEmeraldBorder = Color(0xFF14533C);
  static const Color darkRoseTint = Color(0xFF36111C);
  static const Color darkRoseBorder = Color(0xFF5E1A2C);

  // Shared Brand & Semantic Constants
  /// Electric Coral - energy, streaks, XP, active focus
  static const Color secondary = Color(0xFFFF6B4A);
  static const Color secondaryDark = Color(0xFFAE3115);
  static const Color secondaryContainer = Color(0xFFFD6A49);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF640F00);
  static const Color secondaryFixed = Color(0xFFFFDAD2);
  static const Color secondaryFixedDim = Color(0xFFFFB4A3);

  /// Crisp Emerald — mastered, correct, positive reinforcement
  static const Color emerald = Color(0xFF10B981);
  static const Color tertiary = emerald;
  static const Color tertiaryContainer = Color(0xFF002819);
  static const Color onTertiaryContainer = Color(0xFF009D6C);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);

  /// Vivid Rose - retry, review-needed, incorrect
  static const Color rose = Color(0xFFF43F5E);

  /// Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  /// Vibrant Amber — sunshine, light mode accent, warm alerts
  static const Color amber = Color(0xFFF59E0B);

  /// Radiant Violet — dark mode accent glow, cosmic highlights
  static const Color accentViolet = Color(0xFFA78BFA);

  static const Color surfaceTint = Color(0xFF5B598C);
  static const Color outline = Color(0xFF787680);
  static const Color outlineVariant = Color(0xFFC8C5D0);

  // Dynamic Adaptive Getters (Respond to active ThemeMode)
  static Color get primary => _isDarkMode ? darkPrimary : lightPrimary;
  static Color get primaryDark =>
      _isDarkMode ? darkPrimaryDark : lightPrimaryDark;
  static Color get onPrimary => _isDarkMode ? darkOnPrimary : lightOnPrimary;
  static Color get primaryContainer =>
      _isDarkMode ? darkPrimaryContainer : lightPrimaryContainer;
  static Color get onPrimaryContainer =>
      _isDarkMode ? darkOnPrimaryContainer : lightOnPrimaryContainer;
  static Color get inversePrimary =>
      _isDarkMode ? darkInversePrimary : lightInversePrimary;
  static Color get primaryFixed =>
      _isDarkMode ? darkPrimaryFixed : lightPrimaryFixed;
  static Color get primaryFixedDim =>
      _isDarkMode ? darkPrimaryFixedDim : lightPrimaryFixedDim;

  static Color get surface => _isDarkMode ? darkSurface : lightSurface;
  static Color get surfaceWarm =>
      _isDarkMode ? darkSurfaceWarm : lightSurfaceWarm;
  static Color get surfaceDim => _isDarkMode ? darkSurfaceDim : lightSurfaceDim;
  static Color get surfaceBright =>
      _isDarkMode ? darkSurfaceBright : lightSurfaceBright;
  static Color get surfaceContainerLowest =>
      _isDarkMode ? darkSurfaceContainerLowest : lightSurfaceContainerLowest;
  static Color get surfaceContainerLow =>
      _isDarkMode ? darkSurfaceContainerLow : lightSurfaceContainerLow;
  static Color get surfaceContainer =>
      _isDarkMode ? darkSurfaceContainer : lightSurfaceContainer;
  static Color get surfaceContainerHigh =>
      _isDarkMode ? darkSurfaceContainerHigh : lightSurfaceContainerHigh;
  static Color get surfaceContainerHighest =>
      _isDarkMode ? darkSurfaceContainerHighest : lightSurfaceContainerHighest;

  static Color get cardBackground =>
      _isDarkMode ? darkCardBackground : lightCardBackground;
  static Color get cardBorder => _isDarkMode ? darkCardBorder : lightCardBorder;

  static Color get textPrimary =>
      _isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary =>
      _isDarkMode ? darkTextSecondary : lightTextSecondary;
  static Color get textDisabled =>
      _isDarkMode ? darkTextDisabled : lightTextDisabled;
  static Color get textInverse =>
      _isDarkMode ? darkTextInverse : lightTextInverse;

  static Color get onSurface => _isDarkMode ? darkOnSurface : lightOnSurface;
  static Color get onSurfaceVariant =>
      _isDarkMode ? darkOnSurfaceVariant : lightOnSurfaceVariant;
  static Color get inverseSurface =>
      _isDarkMode ? darkInverseSurface : lightInverseSurface;
  static Color get inverseOnSurface =>
      _isDarkMode ? darkInverseOnSurface : lightInverseOnSurface;

  static Color get inputBorder =>
      _isDarkMode ? darkInputBorder : lightInputBorder;
  static Color get neutralTrack =>
      _isDarkMode ? darkNeutralTrack : lightNeutralTrack;
  static Color get dropzoneBackground =>
      _isDarkMode ? darkDropzoneBackground : lightDropzoneBackground;
  static Color get sheetHandle =>
      _isDarkMode ? darkSheetHandle : lightSheetHandle;

  static Color get emeraldTint =>
      _isDarkMode ? darkEmeraldTint : lightEmeraldTint;
  static Color get emeraldBorder =>
      _isDarkMode ? darkEmeraldBorder : lightEmeraldBorder;
  static Color get roseTint => _isDarkMode ? darkRoseTint : lightRoseTint;
  static Color get roseBorder => _isDarkMode ? darkRoseBorder : lightRoseBorder;

  // ─── Functional Helpers ────────────────────────────────────────────
  /// Streak pill background
  static Color get streakPillBackground =>
      secondary.withValues(alpha: _isDarkMode ? 0.20 : 0.12);

  /// Scrim for modal overlays
  static Color get modalScrim => _isDarkMode
      ? Colors.black.withValues(alpha: 0.65)
      : const Color(0xFF1E1B4B).withValues(alpha: 0.4);

  /// Focus ring
  static Color get focusRing =>
      primary.withValues(alpha: _isDarkMode ? 0.20 : 0.08);

  // Gradient Helpers
  static const LinearGradient lightReviewBannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF2D2A6E),
    ],
  );

  static const LinearGradient darkReviewBannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF201C4E),
      Color(0xFF332D76),
    ],
  );

  /// Review banner gradient adapts automatically
  static LinearGradient get reviewBannerGradient =>
      _isDarkMode ? darkReviewBannerGradient : lightReviewBannerGradient;

  /// Coral accent gradient
  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B4A),
      Color(0xFFFF8A6A),
    ],
  );
}
