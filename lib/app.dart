import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'core/router/router.dart';

/// Root application widget.
class HakiApp extends ConsumerWidget {
  const HakiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Haki',
      debugShowCheckedModeBanner: false,
      theme: HakiTheme.light,
      routerConfig: appRouter,
    );
  }
}
