import 'package:flutter_test/flutter_test.dart';
import 'package:haki/models/enums.dart';
import 'package:haki/models/review_event.dart';
import 'package:haki/services/analytics_calculator.dart';

void main() {
  group('AnalyticsCalculator', () {
    const calculator = AnalyticsCalculator();

    test('calculates streak correctly for consecutive days including today',
        () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final days = [
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 3)),
      ];

      final streak = calculator.calculateCurrentStreak(days);
      expect(streak, equals(4));
    });

    test('returns 0 streak if last study day was more than 1 day ago', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final days = [
        today.subtract(const Duration(days: 3)),
        today.subtract(const Duration(days: 4)),
      ];

      final streak = calculator.calculateCurrentStreak(days);
      expect(streak, equals(0));
    });

    test('calculates longest streak accurately', () {
      final base = DateTime(2026, 1, 1);
      final days = [
        base,
        base.add(const Duration(days: 1)),
        base.add(const Duration(days: 2)), // Streak 1: 3 days
        base.add(const Duration(days: 6)),
        base.add(const Duration(days: 7)),
        base.add(const Duration(days: 8)),
        base.add(const Duration(days: 9)),
        base.add(const Duration(days: 10)), // Streak 2: 5 days
      ];

      final longest = calculator.calculateLongestStreak(days);
      expect(longest, equals(5));
    });

    test('calculates retention rate from review events', () {
      final events = [
        ReviewEvent(
          id: '1',
          cardId: 'c1',
          deckId: 'd1',
          rating: ReviewRating.good,
          reviewedAt: DateTime.now(),
          previousIntervalDays: 1,
          newIntervalDays: 3,
          previousEaseFactor: 2.5,
          newEaseFactor: 2.5,
        ),
        ReviewEvent(
          id: '2',
          cardId: 'c2',
          deckId: 'd1',
          rating: ReviewRating.easy,
          reviewedAt: DateTime.now(),
          previousIntervalDays: 1,
          newIntervalDays: 4,
          previousEaseFactor: 2.5,
          newEaseFactor: 2.65,
        ),
        ReviewEvent(
          id: '3',
          cardId: 'c3',
          deckId: 'd1',
          rating: ReviewRating.hard,
          reviewedAt: DateTime.now(),
          previousIntervalDays: 1,
          newIntervalDays: 1,
          previousEaseFactor: 2.5,
          newEaseFactor: 2.35,
        ),
        ReviewEvent(
          id: '4',
          cardId: 'c4',
          deckId: 'd1',
          rating: ReviewRating.again, // only this is incorrect
          reviewedAt: DateTime.now(),
          previousIntervalDays: 3,
          newIntervalDays: 0,
          previousEaseFactor: 2.5,
          newEaseFactor: 2.3,
        ),
      ];

      final retention = calculator.calculateRetentionRate(events);
      expect(retention, equals(0.75));
    });

    test('formats study time in seconds to human readable strings', () {
      expect(calculator.formatStudyTime(45), equals('45s'));
      expect(calculator.formatStudyTime(125), equals('2m'));
      expect(calculator.formatStudyTime(3600), equals('1h 0m'));
      expect(calculator.formatStudyTime(67500), equals('18h 45m'));
    });
  });
}
