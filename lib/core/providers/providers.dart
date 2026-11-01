import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../theme/colors.dart';
import '../database/database.dart';
import '../database/daos/deck_dao.dart';
import '../database/daos/card_dao.dart';
import '../database/daos/review_dao.dart';
import '../../services/spaced_repetition.dart';
import '../../services/analytics_calculator.dart';
import '../../models/models.dart';

// Database

/// Singleton database instance
final databaseProvider = Provider<HakiDatabase>((ref) {
  final db = HakiDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Deck DAO
final deckDaoProvider = Provider<DeckDao>((ref) {
  return ref.watch(databaseProvider).deckDao;
});

/// Card DAO
final cardDaoProvider = Provider<CardDao>((ref) {
  return ref.watch(databaseProvider).cardDao;
});

/// Review DAO
final reviewDaoProvider = Provider<ReviewDao>((ref) {
  return ref.watch(databaseProvider).reviewDao;
});

// Services

/// Spaced repetition scheduler
final schedulerProvider = Provider<SpacedRepetitionScheduler>((ref) {
  return const SpacedRepetitionScheduler();
});

/// Analytics calculator
final analyticsProvider = Provider<AnalyticsCalculator>((ref) {
  return const AnalyticsCalculator();
});

// Deck Providers

/// Watch all decks with stats (reactive stream)
final allDecksProvider = StreamProvider<List<Deck>>((ref) {
  return ref.watch(deckDaoProvider).watchAllDecks();
});

/// Watch a single deck by ID
final deckByIdProvider = StreamProvider.family<Deck?, String>((ref, id) {
  return ref.watch(deckDaoProvider).watchDeckById(id);
});

/// Search query for deck filtering
final deckSearchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered decks based on search query
final filteredDecksProvider = Provider<AsyncValue<List<Deck>>>((ref) {
  final query = ref.watch(deckSearchQueryProvider).toLowerCase();
  final decksAsync = ref.watch(allDecksProvider);

  return decksAsync.whenData((decks) {
    if (query.isEmpty) return decks;
    return decks.where((d) => d.name.toLowerCase().contains(query)).toList();
  });
});

/// Total due cards across all decks
final totalDueCardsProvider = FutureProvider<int>((ref) async {
  final cards = await ref.watch(cardDaoProvider).getAllDueCards();
  return cards.length;
});

// Card Providers

/// Watch cards for a specific deck
final cardsForDeckProvider =
    StreamProvider.family<List<FlashCard>, String>((ref, deckId) {
  return ref.watch(cardDaoProvider).watchCardsForDeck(deckId);
});

/// Due cards for a deck
final dueCardsForDeckProvider =
    FutureProvider.family<List<FlashCard>, String>((ref, deckId) {
  return ref.watch(cardDaoProvider).getDueCards(deckId);
});

/// Seen cards for a deck (cards that have been studied/reviewed at least once)
final seenCardsForDeckProvider =
    FutureProvider.family<List<FlashCard>, String>((ref, deckId) {
  return ref.watch(cardDaoProvider).getSeenCardsForDeck(deckId);
});

/// Watch seen cards for a deck (reactive)
final watchSeenCardsForDeckProvider =
    StreamProvider.family<List<FlashCard>, String>((ref, deckId) {
  return ref.watch(cardDaoProvider).watchSeenCardsForDeck(deckId);
});

// Global Stats Providers

/// Total review count
final totalReviewCountProvider = FutureProvider<int>((ref) {
  return ref.watch(reviewDaoProvider).getTotalReviewCount();
});

/// Total study time in seconds
final totalStudyTimeProvider = FutureProvider<int>((ref) {
  return ref.watch(reviewDaoProvider).getTotalStudyTimeSeconds();
});

/// Study days for streak calculation
final studyDaysProvider = FutureProvider<List<DateTime>>((ref) {
  return ref.watch(reviewDaoProvider).getStudyDays();
});

/// Current streak
final currentStreakProvider = FutureProvider<int>((ref) async {
  final days = await ref.watch(studyDaysProvider.future);
  return ref.watch(analyticsProvider).calculateCurrentStreak(days);
});

/// Longest streak
final longestStreakProvider = FutureProvider<int>((ref) async {
  final days = await ref.watch(studyDaysProvider.future);
  return ref.watch(analyticsProvider).calculateLongestStreak(days);
});

/// Total mastered cards
final totalMasteredProvider = FutureProvider<int>((ref) {
  return ref.watch(cardDaoProvider).getMasteredCardCount();
});

/// Genuine retention rate calculated from review events (0.0 if no reviews)
final retentionRateProvider = FutureProvider<double>((ref) async {
  final events = await ref.watch(reviewDaoProvider).getAllReviews(limit: 500);
  if (events.isEmpty) return 0.0;
  return ref.watch(analyticsProvider).calculateRetentionRate(events);
});

/// Cards needing attention (learning status, errors, or lowest ease factor)
final needsAttentionCardsProvider = FutureProvider<List<FlashCard>>((ref) {
  return ref.watch(cardDaoProvider).getNeedsAttentionCards(limit: 5);
});

// Theme Mode Provider

/// Manages and persists application theme mode (System, Light, Dark).
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _syncHakiColors(ThemeMode.system);
    _loadSavedTheme();
  }

  static void _syncHakiColors(ThemeMode mode) {
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };
    HakiColors.setDarkMode(isDark);
  }

  Future<void> _loadSavedTheme() async {
    try {
      final file = await _getSettingsFile();
      if (file != null && await file.exists()) {
        final content = await file.readAsString();
        switch (content.trim()) {
          case 'dark':
            _syncHakiColors(ThemeMode.dark);
            state = ThemeMode.dark;
            break;
          case 'light':
            _syncHakiColors(ThemeMode.light);
            state = ThemeMode.light;
            break;
          case 'system':
          default:
            _syncHakiColors(ThemeMode.system);
            state = ThemeMode.system;
            break;
        }
      }
    } catch (_) {
      // Graceful fallback for test or restricted environments
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _syncHakiColors(mode);
    state = mode;
    try {
      final file = await _getSettingsFile();
      if (file != null) {
        final val = switch (mode) {
          ThemeMode.dark => 'dark',
          ThemeMode.light => 'light',
          ThemeMode.system => 'system',
        };
        await file.writeAsString(val);
      }
    } catch (_) {}
  }

  Future<void> toggleTheme(BuildContext context) async {
    final currentIsDark = state == ThemeMode.dark ||
        (state == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    await setThemeMode(currentIsDark ? ThemeMode.light : ThemeMode.dark);
  }

  static Future<File?> _getSettingsFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/haki_theme_mode.txt');
    } catch (_) {
      return null;
    }
  }
}

/// Theme Mode Provider
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
