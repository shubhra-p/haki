import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/colors.dart';
import 'core/theme/theme.dart';
import 'core/router/router.dart';
import 'core/providers/providers.dart';

/// Root application widget supporting dynamic Light and Dark modes.
class HakiApp extends ConsumerWidget {
  const HakiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Keep HakiColors dynamic tokens synchronized with active brightness
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    HakiColors.setDarkMode(isDark);

    // Synchronize system UI overlay style with theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            isDark ? HakiColors.darkSurface : HakiColors.lightSurface,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'Haki',
      debugShowCheckedModeBanner: false,
      theme: HakiTheme.light,
      darkTheme: HakiTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
