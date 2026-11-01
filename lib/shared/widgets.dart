import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/elevation.dart';
import '../core/theme/spacing.dart';

/// A tactile elevated card matching the design system.
class HakiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final int elevationLevel;
  final Color? borderColor;
  final double? borderRadius;
  final VoidCallback? onTap;

  const HakiCard({
    super.key,
    required this.child,
    this.padding,
    this.elevationLevel = 1,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shadows = switch (elevationLevel) {
      0 => HakiElevation.level0,
      1 => HakiElevation.level1,
      2 => HakiElevation.level2,
      3 => HakiElevation.level3,
      4 => HakiElevation.level4,
      _ => HakiElevation.level1,
    };

    final radius = borderRadius ?? HakiRadius.lg;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? HakiColors.cardBorder,
            width: 1,
          ),
          boxShadow: shadows,
        ),
        child: Material(
          color: HakiColors.cardBackground,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped chip/badge
class HakiPill extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;

  const HakiPill({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? HakiColors.surfaceContainerLow,
        borderRadius: HakiRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor ?? HakiColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: HakiTypography.labelSm.copyWith(
                color: textColor ?? HakiColors.textSecondary,
                fontSize: fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak pill with fire icon
class StreakPill extends StatelessWidget {
  final int streak;

  const StreakPill({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return HakiPill(
      label: '$streak',
      backgroundColor: HakiColors.streakPillBackground,
      textColor: HakiColors.secondary,
      icon: Icons.local_fire_department,
    );
  }
}

/// Circular progress indicator with percentage
class CircularProgressBadge extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;

  const CircularProgressBadge({
    super.key,
    required this.progress,
    this.size = 42,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? HakiColors.emerald;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: HakiColors.neutralTrack,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: HakiTypography.labelSm.copyWith(
              color: progressColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Primary pill button matching design spec
class HakiPillButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final bool isLoading;

  const HakiPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 54,
    this.isLoading = false,
  });

  @override
  State<HakiPillButton> createState() => _HakiPillButtonState();
}

class _HakiPillButtonState extends State<HakiPillButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? HakiColors.primary;
    final fg = widget.foregroundColor ?? HakiColors.onPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        transform: _isPressed
            ? (Matrix4.translationValues(0.0, 2.0, 0.0)
              ..scaleByDouble(0.98, 0.98, 1.0, 1.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.onPressed != null ? bg : bg.withValues(alpha: 0.5),
          borderRadius: HakiRadius.fullAll,
        ),
        alignment: Alignment.center,
        child: widget.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(fg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: fg, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: HakiTypography.labelLg.copyWith(color: fg),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Convenience alias for HakiPillButton
typedef HakiButton = HakiPillButton;

/// Linear progress bar with animated fill
class HakiProgressBar extends StatelessWidget {
  final double progress;
  final Color? color;
  final double height;

  const HakiProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: HakiRadius.fullAll,
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: HakiColors.neutralTrack,
          valueColor: AlwaysStoppedAnimation(color ?? HakiColors.emerald),
        ),
      ),
    );
  }
}

/// Empty state placeholder
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HakiColors.primaryFixed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: HakiColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: HakiTypography.headlineMd.copyWith(
                color: HakiColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: HakiTypography.bodyMd.copyWith(
                color: HakiColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              HakiPillButton(
                label: actionLabel!,
                onPressed: onAction,
                backgroundColor: HakiColors.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Metric card for insights dashboard
class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final Color? trendColor;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return HakiCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: (iconColor ?? HakiColors.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: HakiRadius.smAll,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor ?? HakiColors.primary,
                  ),
                ),
              if (trend != null) ...[
                const Spacer(),
                HakiPill(
                  label: trend!,
                  backgroundColor:
                      (trendColor ?? HakiColors.emerald).withValues(alpha: 0.1),
                  textColor: trendColor ?? HakiColors.emerald,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: HakiTypography.metricValue.copyWith(
              color: HakiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: HakiTypography.metricLabel.copyWith(
              color: HakiColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tactile button to toggle between Light and Dark mode, or long-press to open theme selector.
class ThemeToggleButton extends ConsumerWidget {
  final double size;
  final EdgeInsetsGeometry padding;

  const ThemeToggleButton({
    super.key,
    this.size = 38,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isSystemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = switch (themeMode) {
      ThemeMode.system => isSystemDark,
      ThemeMode.dark => true,
      ThemeMode.light => false,
    };

    return Padding(
      padding: padding,
      child: Tooltip(
        message: 'Toggle theme (Long press for options)',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              ref.read(themeModeProvider.notifier).setThemeMode(newMode);
            },
            onLongPress: () => showThemeModeSheet(context, ref),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: HakiColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: HakiColors.cardBorder,
                  width: 1,
                ),
                boxShadow: HakiElevation.level1,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  size: 20,
                  color: isDark ? HakiColors.accentViolet : HakiColors.amber,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal bottom sheet to select System, Light, or Dark theme.
void showThemeModeSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      final currentMode = ref.watch(themeModeProvider);

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: HakiColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: HakiColors.cardBorder, width: 1),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: HakiColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: HakiColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.palette_rounded,
                      size: 20,
                      color: HakiColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appearance',
                          style: HakiTypography.headlineSm.copyWith(
                            color: HakiColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Choose your preferred theme interface',
                          style: HakiTypography.bodySm.copyWith(
                            color: HakiColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ThemeOptionTile(
                title: 'System Default',
                subtitle: 'Automatically matches your device settings',
                icon: Icons.brightness_auto_rounded,
                iconColor: HakiColors.primary,
                isSelected: currentMode == ThemeMode.system,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOptionTile(
                title: 'Light Mode',
                subtitle: 'Crisp cream surfaces and warm indigo accents',
                icon: Icons.light_mode_rounded,
                iconColor: HakiColors.amber,
                isSelected: currentMode == ThemeMode.light,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOptionTile(
                title: 'Dark Mode',
                subtitle: 'Deep obsidian midnight with violet glow',
                icon: Icons.dark_mode_rounded,
                iconColor: HakiColors.accentViolet,
                isSelected: currentMode == ThemeMode.dark,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? HakiColors.primary.withValues(alpha: 0.08)
              : HakiColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? HakiColors.primary : HakiColors.cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: HakiTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: HakiColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: HakiTypography.bodySm.copyWith(
                      color: HakiColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: HakiColors.primary,
                size: 22,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HakiColors.cardBorder, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

