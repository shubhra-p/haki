import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// Builds the complete Haki MaterialApp theme.
///
/// Consolidates DESIGN.md tokens into a single coherent ThemeData
/// so that no scattered color literals appear in feature code.
class HakiTheme {
  HakiTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: HakiColors.primary,
        onPrimary: HakiColors.onPrimary,
        primaryContainer: HakiColors.primaryContainer,
        onPrimaryContainer: HakiColors.onPrimaryContainer,
        inversePrimary: HakiColors.inversePrimary,
        secondary: HakiColors.secondary,
        onSecondary: HakiColors.onSecondary,
        secondaryContainer: HakiColors.secondaryContainer,
        onSecondaryContainer: HakiColors.onSecondaryContainer,
        tertiary: HakiColors.emerald,
        onTertiary: HakiColors.onPrimary,
        tertiaryContainer: HakiColors.tertiaryContainer,
        onTertiaryContainer: HakiColors.onTertiaryContainer,
        error: HakiColors.error,
        onError: HakiColors.onError,
        errorContainer: HakiColors.errorContainer,
        onErrorContainer: HakiColors.onErrorContainer,
        surface: HakiColors.surface,
        onSurface: HakiColors.onSurface,
        onSurfaceVariant: HakiColors.onSurfaceVariant,
        inverseSurface: HakiColors.inverseSurface,
        onInverseSurface: HakiColors.inverseOnSurface,
        outline: HakiColors.outline,
        outlineVariant: HakiColors.outlineVariant,
        surfaceTint: HakiColors.surfaceTint,
        surfaceContainerLowest: HakiColors.surfaceContainerLowest,
        surfaceContainerLow: HakiColors.surfaceContainerLow,
        surfaceContainer: HakiColors.surfaceContainer,
        surfaceContainerHigh: HakiColors.surfaceContainerHigh,
        surfaceContainerHighest: HakiColors.surfaceContainerHighest,
      ),

      // Scaffold
      scaffoldBackgroundColor: HakiColors.surface,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: HakiColors.surface,
        foregroundColor: HakiColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: HakiTypography.headlineSm.copyWith(
          color: HakiColors.textPrimary,
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HakiColors.cardBackground,
        selectedItemColor: HakiColors.primary,
        unselectedItemColor: HakiColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: HakiTypography.labelSm,
        unselectedLabelStyle: HakiTypography.labelSm,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: HakiColors.cardBackground,
        indicatorColor: HakiColors.primaryFixed,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(
          HakiTypography.labelSm.copyWith(
            color: HakiColors.textSecondary,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: HakiColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: HakiColors.cardBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HakiColors.primary,
          foregroundColor: HakiColors.onPrimary,
          elevation: 0,
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: HakiTypography.labelLg,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: HakiColors.primary,
          side: const BorderSide(color: HakiColors.inputBorder, width: 1.5),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: HakiTypography.labelLg,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HakiColors.primary,
          textStyle: HakiTypography.labelLg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HakiColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.inputBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.inputBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.error,
            width: 1.5,
          ),
        ),
        hintStyle: HakiTypography.bodyMd.copyWith(
          color: HakiColors.textDisabled,
        ),
        labelStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.textSecondary,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: HakiColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: HakiColors.sheetHandle,
        dragHandleSize: Size(36, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: HakiColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: HakiTypography.headlineMd.copyWith(
          color: HakiColors.textPrimary,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HakiColors.secondary,
        foregroundColor: HakiColors.onSecondary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: HakiColors.surfaceContainerLow,
        labelStyle: HakiTypography.labelMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: HakiColors.cardBorder,
        thickness: 1,
        space: 1,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HakiColors.inverseSurface,
        contentTextStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.inverseOnSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HakiColors.emerald,
        linearTrackColor: HakiColors.neutralTrack,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.onPrimary;
          }
          return HakiColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.primary;
          }
          return HakiColors.neutralTrack;
        }),
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
