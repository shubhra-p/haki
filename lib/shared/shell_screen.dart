import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers/providers.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

/// Shell screen with bottom navigation bar.
///
/// Wraps the main navigation tabs: Study, Decks, Create & Import, Progress.
class ShellScreen extends ConsumerWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/study')) return 0;
    if (location.startsWith('/decks')) return 1;
    if (location.startsWith('/create') || location.startsWith('/import')) {
      return 2;
    }
    if (location.startsWith('/insights')) return 3;
    return 1; // Default to decks
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/study');
        break;
      case 1:
        context.go('/decks');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/insights');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: HakiColors.surface,
      body: KeyedSubtree(
        key: ValueKey('shell_page_${themeMode.name}_${HakiColors.isDarkMode}'),
        child: child,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: HakiColors.cardBackground,
          border: Border(
            top: BorderSide(
              color: HakiColors.cardBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: HakiColors.primary.withValues(alpha: 0.04),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.school_outlined,
                  activeIcon: Icons.school,
                  label: 'Study',
                  isSelected: selectedIndex == 0,
                  onTap: () => _onItemTapped(context, 0),
                ),
                _NavItem(
                  icon: Icons.library_books_outlined,
                  activeIcon: Icons.library_books,
                  label: 'Decks',
                  isSelected: selectedIndex == 1,
                  onTap: () => _onItemTapped(context, 1),
                ),
                _NavItem(
                  icon: Icons.add_circle_outline,
                  activeIcon: Icons.add_circle,
                  label: 'Create',
                  isSelected: selectedIndex == 2,
                  onTap: () => _onItemTapped(context, 2),
                  accentColor: HakiColors.secondary,
                ),
                _NavItem(
                  icon: Icons.insights_outlined,
                  activeIcon: Icons.insights,
                  label: 'Progress',
                  isSelected: selectedIndex == 3,
                  onTap: () => _onItemTapped(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? (accentColor ?? HakiColors.primary)
        : HakiColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: HakiTypography.labelSm.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
