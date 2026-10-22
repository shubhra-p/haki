import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Haki Design System — Typography
///
/// Plus Jakarta Sans: Headlines, flashcard lexemes, body text
/// Space Grotesk: Phonetics, labels, metrics, IPA
class HakiTypography {
  HakiTypography._();

  // ─── Plus Jakarta Sans ─────────────────────────────────────────────

  /// Headline XL — 40px, ExtraBold (800)
  static TextStyle get headlineXl => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 48 / 40,
        letterSpacing: -0.03 * 40,
      );

  /// Headline XL Mobile — 32px, ExtraBold (800)
  static TextStyle get headlineXlMobile => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      );

  /// Headline LG — 32px, Bold (700)
  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      );

  /// Headline LG Mobile — 26px, Bold (700)
  static TextStyle get headlineLgMobile => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.01 * 26,
      );

  /// Headline MD — 22px, Bold (700)
  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 30 / 22,
        letterSpacing: -0.01 * 22,
      );

  /// Headline SM — 18px, SemiBold (600)
  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
      );

  /// Body LG — 18px, Regular (400)
  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
      );

  /// Body MD — 16px, Regular (400)
  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  /// Body SM — 14px, Regular (400)
  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  // ─── Space Grotesk ─────────────────────────────────────────────────

  /// Phonetic Display — 18px, Medium (500), wider tracking
  static TextStyle get phoneticDisplay => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 24 / 18,
        letterSpacing: 0.04 * 18,
      );

  /// Label LG — 15px, SemiBold (600)
  static TextStyle get labelLg => GoogleFonts.spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        letterSpacing: 0.02 * 15,
      );

  /// Label MD — 13px, SemiBold (600)
  static TextStyle get labelMd => GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.03 * 13,
      );

  /// Label SM — 11px, Bold (700)
  static TextStyle get labelSm => GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 16 / 11,
        letterSpacing: 0.06 * 11,
      );

  // ─── Convenience Methods ───────────────────────────────────────────

  /// Flashcard word display (large, commanding)
  static TextStyle get flashcardWord => headlineXlMobile;

  /// Flashcard meaning text
  static TextStyle get flashcardMeaning => headlineMd;

  /// Metric value (large number display)
  static TextStyle get metricValue => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  /// Metric label (below the value)
  static TextStyle get metricLabel => labelMd;
}
