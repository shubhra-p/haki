import 'package:flutter/material.dart';
import 'colors.dart';

/// Haki Design System - Elevation & Shadow System
///
/// Based on DESIGN.md elevation levels using warm, indigo-tinted shadows in Light Mode
/// and deep black ambient occlusion shadows in Dark Mode.
class HakiElevation {
  HakiElevation._();

  static Color get _shadowBase =>
      HakiColors.isDarkMode ? Colors.black : HakiColors.lightPrimary;

  /// Level 0 - Canvas: no shadow, flat background
  static List<BoxShadow> get level0 => [];

  /// Level 1 - Docked panels & inactive cards
  /// Ambient diffusion shadow
  static List<BoxShadow> get level1 => [
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.28 : 0.04,
          ),
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.16 : 0.02,
          ),
          offset: const Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ];

  /// Level 2 — Active flashcard (idle)
  /// Pronounced tactile depth
  static List<BoxShadow> get level2 => [
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.40 : 0.08,
          ),
          offset: const Offset(0, 12),
          blurRadius: 32,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.22 : 0.03,
          ),
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: -2,
        ),
      ];

  /// Level 3 - Dragged/swiped flashcard
  /// Elevated directional shadow + 1.03x scale
  static List<BoxShadow> get level3 => [
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.55 : 0.16,
          ),
          offset: const Offset(0, 24),
          blurRadius: 48,
          spreadRadius: -8,
        ),
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.30 : 0.06,
          ),
          offset: const Offset(0, 8),
          blurRadius: 16,
          spreadRadius: -4,
        ),
      ];

  /// Level 4 - Modals & bottom drawers
  static List<BoxShadow> get level4 => [
        BoxShadow(
          color: _shadowBase.withValues(
            alpha: HakiColors.isDarkMode ? 0.60 : 0.18,
          ),
          offset: const Offset(0, -8),
          blurRadius: 40,
          spreadRadius: -6,
        ),
      ];
}
