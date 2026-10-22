import 'package:flutter_test/flutter_test.dart';
import 'package:haki/models/enums.dart';
import 'package:haki/models/flash_card.dart';
import 'package:haki/services/spaced_repetition.dart';

void main() {
  group('SpacedRepetitionScheduler', () {
    late SpacedRepetitionScheduler scheduler;
    late FlashCard sampleCard;

    setUp(() {
      scheduler = const SpacedRepetitionScheduler();
      sampleCard = FlashCard(
        id: 'test-card-1',
        deckId: 'deck-1',
        word: 'sobremesa',
        meaning: 'table talk after lunch',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      );
    });

    test('new card rated Again enters learning step 1', () {
      final result = scheduler.schedule(sampleCard, ReviewRating.again);

      expect(result.status, equals(ReviewStatus.learning));
      expect(result.intervalDays, equals(0));
      expect(result.dueDate.isAfter(DateTime.now()), isTrue);
    });

    test('new card rated Good graduates with interval = graduatingIntervalDays',
        () {
      final result = scheduler.schedule(sampleCard, ReviewRating.good);

      expect(result.status, equals(ReviewStatus.review));
      expect(result.intervalDays, equals(1));
    });

    test('new card rated Easy jumps ahead with easyIntervalDays', () {
      final result = scheduler.schedule(sampleCard, ReviewRating.easy);

      expect(result.status, equals(ReviewStatus.review));
      expect(result.intervalDays, equals(4));
      expect(result.easeFactor, greaterThan(sampleCard.easeFactor));
    });

    test('review card rated Again resets to learning and lowers ease factor',
        () {
      final reviewCard = sampleCard.copyWith(
        reviewStatus: ReviewStatus.review,
        intervalDays: 10,
        easeFactor: 2.5,
        reviewCount: 3,
      );

      final result = scheduler.schedule(reviewCard, ReviewRating.again);

      expect(result.status, equals(ReviewStatus.learning));
      expect(result.intervalDays, equals(0));
      expect(result.easeFactor, lessThan(2.5));
    });

    test('ease factor never drops below minEaseFactor floor', () {
      final lowEaseCard = sampleCard.copyWith(
        reviewStatus: ReviewStatus.review,
        intervalDays: 1,
        easeFactor: 1.35,
        reviewCount: 10,
      );

      final result = scheduler.schedule(lowEaseCard, ReviewRating.again);

      expect(result.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('card with interval >= 21 days transitions to mastered status', () {
      final experiencedCard = sampleCard.copyWith(
        reviewStatus: ReviewStatus.review,
        intervalDays: 15,
        easeFactor: 2.5,
        reviewCount: 5,
      );

      final result = scheduler.schedule(experiencedCard, ReviewRating.good);

      expect(result.intervalDays, greaterThanOrEqualTo(21));
      expect(result.status, equals(ReviewStatus.mastered));
    });
  });
}
