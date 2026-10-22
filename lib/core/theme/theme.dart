import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// Builds the complete Haki MaterialApp themes (Light and Dark).

/// Consolidates DESIGN.md tokens into dual coherent ThemeData structures
/// so that the entire application responds smoothly to ThemeMode changes.
class HakiTheme {
  HakiTheme._();

  /// Light theme matching the warm cream editorial aesthetic
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: HakiColors.lightPrimary,
        onPrimary: HakiColors.lightOnPrimary,
        primaryContainer: HakiColors.lightPrimaryContainer,
        onPrimaryContainer: HakiColors.lightOnPrimaryContainer,
        inversePrimary: HakiColors.lightInversePrimary,
        secondary: HakiColors.secondary,
        onSecondary: HakiColors.onSecondary,
        secondaryContainer: HakiColors.secondaryContainer,
        onSecondaryContainer: HakiColors.onSecondaryContainer,
        tertiary: HakiColors.emerald,
        onTertiary: HakiColors.lightOnPrimary,
        tertiaryContainer: HakiColors.tertiaryContainer,
        onTertiaryContainer: HakiColors.onTertiaryContainer,
        error: HakiColors.error,
        onError: HakiColors.onError,
        errorContainer: HakiColors.errorContainer,
        onErrorContainer: HakiColors.onErrorContainer,
        surface: HakiColors.lightSurface,
        onSurface: HakiColors.lightOnSurface,
        onSurfaceVariant: HakiColors.lightOnSurfaceVariant,
        inverseSurface: HakiColors.lightInverseSurface,
        onInverseSurface: HakiColors.lightInverseOnSurface,
        outline: HakiColors.outline,
        outlineVariant: HakiColors.outlineVariant,
        surfaceTint: HakiColors.surfaceTint,
        surfaceContainerLowest: HakiColors.lightSurfaceContainerLowest,
        surfaceContainerLow: HakiColors.lightSurfaceContainerLow,
        surfaceContainer: HakiColors.lightSurfaceContainer,
        surfaceContainerHigh: HakiColors.lightSurfaceContainerHigh,
        surfaceContainerHighest: HakiColors.lightSurfaceContainerHighest,
      ),

      // Scaffold
      scaffoldBackgroundColor: HakiColors.lightSurface,

      // Text theme with full international font fallbacks
      textTheme: TextTheme(
        displayLarge: HakiTypography.headlineXl.copyWith(color: HakiColors.lightTextPrimary),
        displayMedium: HakiTypography.headlineLg.copyWith(color: HakiColors.lightTextPrimary),
        displaySmall: HakiTypography.headlineMd.copyWith(color: HakiColors.lightTextPrimary),
        headlineLarge: HakiTypography.headlineLg.copyWith(color: HakiColors.lightTextPrimary),
        headlineMedium: HakiTypography.headlineMd.copyWith(color: HakiColors.lightTextPrimary),
        headlineSmall: HakiTypography.headlineSm.copyWith(color: HakiColors.lightTextPrimary),
        titleLarge: HakiTypography.headlineSm.copyWith(color: HakiColors.lightTextPrimary),
        titleMedium: HakiTypography.bodyLg.copyWith(color: HakiColors.lightTextPrimary),
        titleSmall: HakiTypography.bodyMd.copyWith(color: HakiColors.lightTextPrimary),
        bodyLarge: HakiTypography.bodyLg.copyWith(color: HakiColors.lightTextPrimary),
        bodyMedium: HakiTypography.bodyMd.copyWith(color: HakiColors.lightTextPrimary),
        bodySmall: HakiTypography.bodySm.copyWith(color: HakiColors.lightTextSecondary),
        labelLarge: HakiTypography.labelLg.copyWith(color: HakiColors.lightTextPrimary),
        labelMedium: HakiTypography.labelMd.copyWith(color: HakiColors.lightTextSecondary),
        labelSmall: HakiTypography.labelSm.copyWith(color: HakiColors.lightTextSecondary),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: HakiColors.lightSurface,
        foregroundColor: HakiColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: HakiTypography.headlineSm.copyWith(
          color: HakiColors.lightTextPrimary,
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HakiColors.lightCardBackground,
        selectedItemColor: HakiColors.lightPrimary,
        unselectedItemColor: HakiColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: HakiTypography.labelSm,
        unselectedLabelStyle: HakiTypography.labelSm,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: HakiColors.lightCardBackground,
        indicatorColor: HakiColors.lightPrimaryFixed,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(
          HakiTypography.labelSm.copyWith(
            color: HakiColors.lightTextSecondary,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: HakiColors.lightCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: HakiColors.lightCardBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HakiColors.lightPrimary,
          foregroundColor: HakiColors.lightOnPrimary,
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
          foregroundColor: HakiColors.lightPrimary,
          side: const BorderSide(color: HakiColors.lightInputBorder, width: 1.5),
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
          foregroundColor: HakiColors.lightPrimary,
          textStyle: HakiTypography.labelLg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HakiColors.lightCardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.lightInputBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.lightInputBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.lightPrimary,
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
          color: HakiColors.lightTextDisabled,
        ),
        labelStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.lightTextSecondary,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: HakiColors.lightCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: HakiColors.lightSheetHandle,
        dragHandleSize: Size(36, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: HakiColors.lightCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: HakiTypography.headlineMd.copyWith(
          color: HakiColors.lightTextPrimary,
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
        backgroundColor: HakiColors.lightSurfaceContainerLow,
        labelStyle: HakiTypography.labelMd.copyWith(color: HakiColors.lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: HakiColors.lightCardBorder,
        thickness: 1,
        space: 1,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HakiColors.lightInverseSurface,
        contentTextStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.lightInverseOnSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HakiColors.emerald,
        linearTrackColor: HakiColors.lightNeutralTrack,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.lightOnPrimary;
          }
          return HakiColors.lightTextDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.lightPrimary;
          }
          return HakiColors.lightNeutralTrack;
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

  /// Dark theme matching the deep obsidian indigo aesthetic
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: HakiColors.darkPrimary,
        onPrimary: HakiColors.darkOnPrimary,
        primaryContainer: HakiColors.darkPrimaryContainer,
        onPrimaryContainer: HakiColors.darkOnPrimaryContainer,
        inversePrimary: HakiColors.darkInversePrimary,
        secondary: HakiColors.secondary,
        onSecondary: HakiColors.onSecondary,
        secondaryContainer: HakiColors.darkSurfaceContainerHigh,
        onSecondaryContainer: HakiColors.secondaryFixedDim,
        tertiary: HakiColors.emerald,
        onTertiary: Colors.white,
        tertiaryContainer: HakiColors.darkEmeraldTint,
        onTertiaryContainer: HakiColors.tertiaryFixed,
        error: HakiColors.error,
        onError: HakiColors.onError,
        errorContainer: HakiColors.darkRoseTint,
        onErrorContainer: HakiColors.rose,
        surface: HakiColors.darkSurface,
        onSurface: HakiColors.darkOnSurface,
        onSurfaceVariant: HakiColors.darkOnSurfaceVariant,
        inverseSurface: HakiColors.darkInverseSurface,
        onInverseSurface: HakiColors.darkInverseOnSurface,
        outline: HakiColors.outline,
        outlineVariant: HakiColors.darkCardBorder,
        surfaceTint: HakiColors.darkPrimary,
        surfaceContainerLowest: HakiColors.darkSurfaceContainerLowest,
        surfaceContainerLow: HakiColors.darkSurfaceContainerLow,
        surfaceContainer: HakiColors.darkSurfaceContainer,
        surfaceContainerHigh: HakiColors.darkSurfaceContainerHigh,
        surfaceContainerHighest: HakiColors.darkSurfaceContainerHighest,
      ),

      // Scaffold
      scaffoldBackgroundColor: HakiColors.darkSurface,

      // Text theme with full international font fallbacks
      textTheme: TextTheme(
        displayLarge: HakiTypography.headlineXl.copyWith(color: HakiColors.darkTextPrimary),
        displayMedium: HakiTypography.headlineLg.copyWith(color: HakiColors.darkTextPrimary),
        displaySmall: HakiTypography.headlineMd.copyWith(color: HakiColors.darkTextPrimary),
        headlineLarge: HakiTypography.headlineLg.copyWith(color: HakiColors.darkTextPrimary),
        headlineMedium: HakiTypography.headlineMd.copyWith(color: HakiColors.darkTextPrimary),
        headlineSmall: HakiTypography.headlineSm.copyWith(color: HakiColors.darkTextPrimary),
        titleLarge: HakiTypography.headlineSm.copyWith(color: HakiColors.darkTextPrimary),
        titleMedium: HakiTypography.bodyLg.copyWith(color: HakiColors.darkTextPrimary),
        titleSmall: HakiTypography.bodyMd.copyWith(color: HakiColors.darkTextPrimary),
        bodyLarge: HakiTypography.bodyLg.copyWith(color: HakiColors.darkTextPrimary),
        bodyMedium: HakiTypography.bodyMd.copyWith(color: HakiColors.darkTextPrimary),
        bodySmall: HakiTypography.bodySm.copyWith(color: HakiColors.darkTextSecondary),
        labelLarge: HakiTypography.labelLg.copyWith(color: HakiColors.darkTextPrimary),
        labelMedium: HakiTypography.labelMd.copyWith(color: HakiColors.darkTextSecondary),
        labelSmall: HakiTypography.labelSm.copyWith(color: HakiColors.darkTextSecondary),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: HakiColors.darkSurface,
        foregroundColor: HakiColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: HakiTypography.headlineSm.copyWith(
          color: HakiColors.darkTextPrimary,
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HakiColors.darkCardBackground,
        selectedItemColor: HakiColors.darkPrimary,
        unselectedItemColor: HakiColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: HakiTypography.labelSm,
        unselectedLabelStyle: HakiTypography.labelSm,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: HakiColors.darkCardBackground,
        indicatorColor: HakiColors.darkPrimaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(
          HakiTypography.labelSm.copyWith(
            color: HakiColors.darkTextSecondary,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: HakiColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: HakiColors.darkCardBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: HakiTypography.labelLg.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: HakiColors.darkTextPrimary,
          side: const BorderSide(color: HakiColors.darkInputBorder, width: 1.5),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: HakiTypography.labelLg.copyWith(
            color: HakiColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HakiColors.darkTextPrimary,
          textStyle: HakiTypography.labelLg.copyWith(
            color: HakiColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HakiColors.darkCardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.darkInputBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.darkInputBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: HakiColors.darkPrimary,
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
          color: HakiColors.darkTextDisabled,
        ),
        labelStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.darkTextSecondary,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: HakiColors.darkCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: HakiColors.darkSheetHandle,
        dragHandleSize: Size(36, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: HakiColors.darkCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: HakiTypography.headlineMd.copyWith(
          color: HakiColors.darkTextPrimary,
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
        backgroundColor: HakiColors.darkSurfaceContainerLow,
        labelStyle: HakiTypography.labelMd.copyWith(color: HakiColors.darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: HakiColors.darkCardBorder,
        thickness: 1,
        space: 1,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HakiColors.darkSurfaceContainerHigh,
        contentTextStyle: HakiTypography.bodySm.copyWith(
          color: HakiColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HakiColors.emerald,
        linearTrackColor: HakiColors.darkNeutralTrack,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.darkOnPrimary;
          }
          return HakiColors.darkTextDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HakiColors.darkPrimary;
          }
          return HakiColors.darkNeutralTrack;
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
