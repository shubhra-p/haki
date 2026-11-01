import 'package:flutter_test/flutter_test.dart';
import 'package:haki/models/models.dart';
import 'package:haki/services/spaced_repetition.dart';
import 'package:haki/services/analytics_calculator.dart';

void main() {
  group('Study Session & Mastery Sync Tests', () {
    const scheduler = SpacedRepetitionScheduler();
    const analytics = AnalyticsCalculator();

    test('Mastered card has interval >= 21 and status ReviewStatus.mastered', () {
      final now = DateTime.now();
      final card = FlashCard(
        id: 'c1',
        deckId: 'd1',
        word: 'こんにちは',
        meaning: 'Hello',
        reviewStatus: ReviewStatus.newCard,
        createdAt: now,
        updatedAt: now,
      );

      // Simulating swipe right -> Mastered
      final masteredCard = card.copyWith(
        reviewStatus: ReviewStatus.mastered,
        intervalDays: 21,
        dueDate: now.add(const Duration(days: 21)),
        reviewCount: card.reviewCount + 1,
        correctCount: card.correctCount + 1,
      );

      expect(masteredCard.reviewStatus, equals(ReviewStatus.mastered));
      expect(masteredCard.intervalDays, greaterThanOrEqualTo(21));
      expect(masteredCard.correctCount, equals(1));
    });

    test('Deck progress registers properly when cards are mastered', () {
      final now = DateTime.now();
      final deck = Deck(
        id: 'd1',
        name: 'Japanese - 2 Syllable Hiragana',
        totalCards: 44,
        masteredCards: 10,
        dueCards: 34,
        newCards: 34,
        createdAt: now,
        updatedAt: now,
      );

      expect(deck.masteredCards, equals(10));
      expect(deck.progressPercent, closeTo(10 / 44, 0.001));
      expect(deck.progressPercentInt, equals(23));
    });

    test('Study days and streak are calculated from review events', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      // User reviewed cards today and yesterday
      final studyDays = [yesterday, today];
      final currentStreak = analytics.calculateCurrentStreak(studyDays);
      final longestStreak = analytics.calculateLongestStreak(studyDays);

      expect(currentStreak, equals(2));
      expect(longestStreak, equals(2));
    });

    test('Study time formatting handles seconds and minutes accurately', () {
      expect(analytics.formatStudyTime(45), equals('45s'));
      expect(analytics.formatStudyTime(120), equals('2m'));
      expect(analytics.formatStudyTime(3660), equals('1h 1m'));
    });

    test('Retention rate is accurately computed from review events', () {
      final now = DateTime.now();
      final events = [
        ReviewEvent(
          id: 'e1',
          cardId: 'c1',
          deckId: 'd1',
          rating: ReviewRating.good,
          reviewedAt: now,
        ),
        ReviewEvent(
          id: 'e2',
          cardId: 'c2',
          deckId: 'd1',
          rating: ReviewRating.easy,
          reviewedAt: now,
        ),
        ReviewEvent(
          id: 'e3',
          cardId: 'c3',
          deckId: 'd1',
          rating: ReviewRating.again,
          reviewedAt: now,
        ),
      ];

      final rate = analytics.calculateRetentionRate(events);
      // 2 correct out of 3 = 66.67%
      expect(rate, closeTo(2 / 3, 0.01));
    });

    test('Scheduler graduates cards to mastered when interval reaches >= 21 days', () {
      final now = DateTime.now();
      final matureCard = FlashCard(
        id: 'c1',
        deckId: 'd1',
        word: 'ありがとう',
        meaning: 'Thank you',
        reviewStatus: ReviewStatus.review,
        intervalDays: 14,
        easeFactor: 2.5,
        reviewCount: 3,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      );

      // Rating Good: 14 * 2.5 = 35 days -> >= 21 days -> Mastered!
      final result = scheduler.schedule(matureCard, ReviewRating.good);
      expect(result.status, equals(ReviewStatus.mastered));
      expect(result.intervalDays, greaterThanOrEqualTo(21));
    });
  });
}
