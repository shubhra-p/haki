import 'package:flutter/material.dart';

/// Haki Design System — Spacing & Layout Tokens
class HakiSpacing {
  HakiSpacing._();

  // ─── Base Spacing Scale ────────────────────────────────────────────
  static const double xs = 4.0; // 0.25rem
  static const double sm = 8.0; // 0.5rem
  static const double md = 16.0; // 1rem
  static const double lg = 24.0; // 1.5rem
  static const double xl = 36.0; // 2.25rem

  // ─── Gutter ────────────────────────────────────────────────────────
  static const double gutter = 16.0; // 1rem
  static const double gutterMobile = 12.0; // 0.75rem

  // ─── Margin ────────────────────────────────────────────────────────
  static const double margin = 24.0; // 1.5rem
  static const double marginMobile = 20.0; // 1.25rem

  // ─── Screen Padding ────────────────────────────────────────────────
  static EdgeInsets screenPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 640) {
      return const EdgeInsets.symmetric(horizontal: 20.0);
    }
    return const EdgeInsets.symmetric(horizontal: 24.0);
  }

  /// Content max width for tablet/desktop centering
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 1024) return 480;
    if (width > 640) return 560;
    return double.infinity;
  }
}

/// Haki Design System — Border Radius Tokens
class HakiRadius {
  HakiRadius._();

  /// Small — 4px (0.25rem)
  static const double sm = 4.0;

  /// Default — 8px (0.5rem)
  static const double base = 8.0;

  /// Medium — 12px (0.75rem)
  static const double md = 12.0;

  /// Large — 16px (1rem)
  static const double lg = 16.0;

  /// XL — 24px (1.5rem) — flashcard stage
  static const double xl = 24.0;

  /// Full pill — 9999px
  static const double full = 9999.0;

  // ─── BorderRadius helpers ──────────────────────────────────────────
  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get baseAll => BorderRadius.circular(base);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get fullAll => BorderRadius.circular(full);
}

/// Responsive breakpoint helpers
class HakiBreakpoints {
  HakiBreakpoints._();

  static const double mobile = 640;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
