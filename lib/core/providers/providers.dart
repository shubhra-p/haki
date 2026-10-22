import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/daos/deck_dao.dart';
import '../database/daos/card_dao.dart';
import '../database/daos/review_dao.dart';
import '../../services/spaced_repetition.dart';
import '../../services/analytics_calculator.dart';
import '../../models/models.dart';

// ─── Database ────────────────────────────────────────────────────────

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

// ─── Services ────────────────────────────────────────────────────────

/// Spaced repetition scheduler
final schedulerProvider = Provider<SpacedRepetitionScheduler>((ref) {
  return const SpacedRepetitionScheduler();
});

/// Analytics calculator
final analyticsProvider = Provider<AnalyticsCalculator>((ref) {
  return const AnalyticsCalculator();
});

// ─── Deck Providers ──────────────────────────────────────────────────

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

// ─── Card Providers ──────────────────────────────────────────────────

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

// ─── Global Stats Providers ──────────────────────────────────────────

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
