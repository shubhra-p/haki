import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Haki Design System - Typography
///
/// Plus Jakarta Sans: Headlines, flashcard lexemes, body text
/// Space Grotesk: Phonetics, labels, metrics, IPA
class HakiTypography {
  HakiTypography._();

  /// Comprehensive international font fallbacks for CJK (Japanese, Chinese, Korean),
  /// Cyrillic, Greek, Arabic, Devanagari, and phonetic IPA glyphs across Android,
  /// iOS, Windows, macOS, and Linux.
  static const List<String> fontFallbacks = [
    'Noto Sans JP',
    'Noto Sans CJK JP',
    'Hiragino Sans',
    'Hiragino Kaku Gothic ProN',
    'Yu Gothic',
    'Meiryo',
    'MS Gothic',
    'Noto Sans SC',
    'Noto Sans CJK SC',
    'PingFang SC',
    'Microsoft YaHei',
    'Noto Sans KR',
    'Noto Sans CJK KR',
    'Malgun Gothic',
    'Apple SD Gothic Neo',
    'Noto Sans Devanagari',
    'Noto Sans Arabic',
    'Noto Sans Thai',
    'Noto Sans',
    'sans-serif',
  ];

  static TextStyle _plusJakartaSans({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(fontFamilyFallback: fontFallbacks);
  }

  static TextStyle _spaceGrotesk({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(fontFamilyFallback: fontFallbacks);
  }

  // Plus Jakarta Sans

  /// Headline XL - 40px, ExtraBold (800)
  static TextStyle get headlineXl => _plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 48 / 40,
        letterSpacing: -0.03 * 40,
      );

  /// Headline XL Mobile - 32px, ExtraBold (800)
  static TextStyle get headlineXlMobile => _plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      );

  /// Headline LG - 32px, Bold (700)
  static TextStyle get headlineLg => _plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      );

  /// Headline LG Mobile - 26px, Bold (700)
  static TextStyle get headlineLgMobile => _plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.01 * 26,
      );

  /// Headline MD - 22px, Bold (700)
  static TextStyle get headlineMd => _plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 30 / 22,
        letterSpacing: -0.01 * 22,
      );

  /// Headline SM - 18px, SemiBold (600)
  static TextStyle get headlineSm => _plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
      );

  /// Body LG - 18px, Regular (400)
  static TextStyle get bodyLg => _plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
      );

  /// Body MD - 16px, Regular (400)
  static TextStyle get bodyMd => _plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  /// Body SM - 14px, Regular (400)
  static TextStyle get bodySm => _plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  // Space Grotesk

  /// Phonetic Display - 18px, Medium (500), wider tracking
  static TextStyle get phoneticDisplay => _spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 24 / 18,
        letterSpacing: 0.04 * 18,
      );

  /// Label LG - 15px, SemiBold (600)
  static TextStyle get labelLg => _spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        letterSpacing: 0.02 * 15,
      );

  /// Label MD - 13px, SemiBold (600)
  static TextStyle get labelMd => _spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.03 * 13,
      );

  /// Label SM - 11px, Bold (700)
  static TextStyle get labelSm => _spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 16 / 11,
        letterSpacing: 0.06 * 11,
      );

  // Convenience Methods

  /// Flashcard word display (large, commanding)
  static TextStyle get flashcardWord => headlineXlMobile;

  /// Flashcard meaning text
  static TextStyle get flashcardMeaning => headlineMd;

  /// Metric value (large number display)
  static TextStyle get metricValue => _plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  /// Metric label (below the value)
  static TextStyle get metricLabel => labelMd;
}
