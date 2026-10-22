import 'package:flutter/material.dart';

/// Haki Design System — Color Tokens
///
/// Consolidated from DESIGN.md specification.
/// All colors are defined here as the single source of truth.
class HakiColors {
  HakiColors._();

  // ─── Primary Palette ───────────────────────────────────────────────
  /// Deep Indigo — structural authority, headers, primary actions
  static const Color primary = Color(0xFF1E1B4B);

  /// Darker primary variant
  static const Color primaryDark = Color(0xFF070235);

  /// On-primary text
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Primary container for elevated elements
  static const Color primaryContainer = Color(0xFF1E1B4B);

  /// On primary container
  static const Color onPrimaryContainer = Color(0xFF8683BA);

  /// Inverse primary for dark surfaces
  static const Color inversePrimary = Color(0xFFC4C1FB);

  /// Primary fixed (lighter tint)
  static const Color primaryFixed = Color(0xFFE3DFFF);

  /// Primary fixed dim
  static const Color primaryFixedDim = Color(0xFFC4C1FB);

  // ─── Secondary Palette (Electric Coral) ────────────────────────────
  /// Electric Coral — energy, streaks, XP, active focus
  static const Color secondary = Color(0xFFFF6B4A);

  /// Secondary darker variant (from design tokens)
  static const Color secondaryDark = Color(0xFFAE3115);

  /// Secondary container
  static const Color secondaryContainer = Color(0xFFFD6A49);

  /// On-secondary
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// On-secondary container
  static const Color onSecondaryContainer = Color(0xFF640F00);

  /// Secondary fixed
  static const Color secondaryFixed = Color(0xFFFFDAD2);

  /// Secondary fixed dim
  static const Color secondaryFixedDim = Color(0xFFFFB4A3);

  // ─── Tertiary Palette (Emerald) ────────────────────────────────────
  /// Crisp Emerald — mastered, correct, positive reinforcement
  static const Color emerald = Color(0xFF10B981);

  /// Tertiary alias for emerald
  static const Color tertiary = emerald;

  /// Emerald tint background
  static const Color emeraldTint = Color(0xFFECFDF5);

  /// Emerald border
  static const Color emeraldBorder = Color(0xFFA7F3D0);

  /// Tertiary container
  static const Color tertiaryContainer = Color(0xFF002819);

  /// On-tertiary container
  static const Color onTertiaryContainer = Color(0xFF009D6C);

  /// Tertiary fixed
  static const Color tertiaryFixed = Color(0xFF6FFBBE);

  /// Tertiary fixed dim
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);

  // ─── Negative / Rose ───────────────────────────────────────────────
  /// Vivid Rose — retry, review-needed, incorrect
  static const Color rose = Color(0xFFF43F5E);

  /// Rose tint background
  static const Color roseTint = Color(0xFFFFF1F2);

  /// Rose border
  static const Color roseBorder = Color(0xFFFECDD3);

  // ─── Error ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ─── Surface & Background ──────────────────────────────────────────
  /// Warm cream canvas — main background
  static const Color surface = Color(0xFFFAF9F7);

  /// Slightly warmer variant
  static const Color surfaceWarm = Color(0xFFFDFCFA);

  /// Surface dim
  static const Color surfaceDim = Color(0xFFDADAD8);

  /// Surface bright
  static const Color surfaceBright = Color(0xFFFAF9F7);

  /// Lowest container — pure white
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  /// Low container
  static const Color surfaceContainerLow = Color(0xFFF4F3F1);

  /// Default container
  static const Color surfaceContainer = Color(0xFFEFEEEC);

  /// High container
  static const Color surfaceContainerHigh = Color(0xFFE9E8E6);

  /// Highest container
  static const Color surfaceContainerHighest = Color(0xFFE3E2E0);

  /// Card background — elevated white
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Card border — subtle structural
  static const Color cardBorder = Color(0xFFF1EFEA);

  // ─── Text Colors ───────────────────────────────────────────────────
  /// Primary text — deep slate
  static const Color textPrimary = Color(0xFF0F172A);

  /// On-surface (from design tokens)
  static const Color onSurface = Color(0xFF1A1C1B);

  /// On-surface variant
  static const Color onSurfaceVariant = Color(0xFF47464F);

  /// Secondary text
  static const Color textSecondary = Color(0xFF64748B);

  /// Disabled text
  static const Color textDisabled = Color(0xFF94A3B8);

  /// Inverse text — white on dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Inverse surface
  static const Color inverseSurface = Color(0xFF2F3130);

  /// Inverse on-surface
  static const Color inverseOnSurface = Color(0xFFF1F1EF);

  // ─── Outline & Border ──────────────────────────────────────────────
  /// Outline
  static const Color outline = Color(0xFF787680);

  /// Outline variant
  static const Color outlineVariant = Color(0xFFC8C5D0);

  /// Input border
  static const Color inputBorder = Color(0xFFE2E8F0);

  /// Neutral track (for progress bars)
  static const Color neutralTrack = Color(0xFFE2E8F0);

  /// CSV dropzone background
  static const Color dropzoneBackground = Color(0xFFF8FAFC);

  /// Bottom sheet handle
  static const Color sheetHandle = Color(0xFFCBD5E1);

  // ─── Surface Tint ──────────────────────────────────────────────────
  static const Color surfaceTint = Color(0xFF5B598C);

  // ─── Functional Colors ─────────────────────────────────────────────
  /// Streak pill background
  static Color get streakPillBackground => secondary.withValues(alpha: 0.12);

  /// Indigo scrim for modals
  static Color get modalScrim => const Color(0xFF1E1B4B).withValues(alpha: 0.4);

  /// Focus ring
  static Color get focusRing => const Color(0xFF1E1B4B).withValues(alpha: 0.08);

  // ─── Gradient helpers ──────────────────────────────────────────────
  /// Review banner gradient (dark indigo)
  static const LinearGradient reviewBannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF2D2A6E),
    ],
  );

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
