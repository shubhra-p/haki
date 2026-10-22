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
    GoRoute(
      path: AppRoutes.deckDetail,
      name: 'deck-detail',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return DeckDetailScreen(deckId: deckId);
      },
    ),
    GoRoute(
      path: AppRoutes.studyDeck,
      name: 'study-deck',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return StudySessionScreen(deckId: deckId);
      },
    ),
    GoRoute(
      path: AppRoutes.csvImportToDeck,
      name: 'import-to-deck',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return CsvImportScreen(existingDeckId: deckId);
      },
    ),
    GoRoute(
      path: AppRoutes.addCard,
      name: 'add-card',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return CardEditorScreen(deckId: deckId);
      },
    ),
    GoRoute(
      path: AppRoutes.editCard,
      name: 'edit-card',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        final cardId = state.pathParameters['cardId']!;
        return CardEditorScreen(deckId: deckId, cardId: cardId);
      },
    ),
  ],
);
