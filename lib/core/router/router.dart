import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/deck_library/deck_library_screen.dart';
import '../../features/deck_detail/deck_detail_screen.dart';
import '../../features/study/study_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/csv_import/csv_import_screen.dart';
import '../../features/card_editor/card_editor_screen.dart';
import '../../shared/shell_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  AppRoutes._();

  static const String deckLibrary = '/decks';
  static const String study = '/study';
  static const String createImport = '/create';
  static const String insights = '/insights';
  static const String deckDetail = '/decks/:deckId';
  static const String studyDeck = '/study/:deckId';
  static const String csvImport = '/import';
  static const String csvImportToDeck = '/import/:deckId';
  static const String addCard = '/decks/:deckId/add';
  static const String editCard = '/decks/:deckId/edit/:cardId';
}

/// Lightweight fade + slide transition for detail pages.
/// Much cheaper than CupertinoPageTransitionsBuilder which renders
/// a full-screen shadow composite during the slide animation.
CustomTransitionPage<T> _smoothPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.06, 0.0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.deckLibrary,
  routes: [
    // Shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.study,
          name: 'study',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudyHomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.deckLibrary,
          name: 'decks',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DeckLibraryScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.createImport,
          name: 'create',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CsvImportScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.insights,
          name: 'insights',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InsightsScreen(),
          ),
        ),
      ],
    ),
    // Detail routes (outside shell for full-screen experience)
    // Use lightweight fade+slide instead of heavy Cupertino transitions
    GoRoute(
      path: AppRoutes.deckDetail,
      name: 'deck-detail',
      pageBuilder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return _smoothPage(
          state: state,
          child: DeckDetailScreen(deckId: deckId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.studyDeck,
      name: 'study-deck',
      pageBuilder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        final mode = state.uri.queryParameters['mode'];
        final isRevision = mode == 'revise_seen' ||
            mode == 'revision' ||
            state.extra == 'revise_seen' ||
            state.extra == true;
        return _smoothPage(
          state: state,
          child: StudySessionScreen(
            deckId: deckId,
            isRevision: isRevision,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.csvImportToDeck,
      name: 'import-to-deck',
      pageBuilder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return _smoothPage(
          state: state,
          child: CsvImportScreen(existingDeckId: deckId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addCard,
      name: 'add-card',
      pageBuilder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return _smoothPage(
          state: state,
          child: CardEditorScreen(deckId: deckId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editCard,
      name: 'edit-card',
      pageBuilder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        final cardId = state.pathParameters['cardId']!;
        return _smoothPage(
          state: state,
          child: CardEditorScreen(deckId: deckId, cardId: cardId),
        );
      },
    ),
  ],
);
