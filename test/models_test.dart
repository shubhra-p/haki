import 'package:flutter_test/flutter_test.dart';
import 'package:haki/models/deck.dart';
import 'package:haki/models/enums.dart';
import 'package:haki/models/flash_card.dart';

void main() {
  group('Domain Models', () {
    test('Deck progress calculation and properties', () {
      final deck = Deck(
        id: 'deck-1',
        name: 'Conversational Spanish',
        sourceLanguage: 'Spanish',
        targetLanguage: 'English',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalCards: 100,
        masteredCards: 45,
        learningCards: 35,
        newCards: 20,
        dueCards: 12,
      );

      expect(deck.progressPercent, equals(0.45));
      expect(deck.progressPercentInt, equals(45));
      expect(deck.isEmpty, isFalse);
      expect(deck.isCompleted, isFalse);
      expect(deck.languagePairLabel, equals('Spanish → English'));
    });

    test('FlashCard copyWith and initial values', () {
      final now = DateTime.now();
      final card = FlashCard(
        id: 'c1',
        deckId: 'd1',
        word: 'Sobremesa',
        meaning: 'After-lunch talk',
        createdAt: now,
        updatedAt: now,
      );

      expect(card.reviewStatus, equals(ReviewStatus.newCard));
      expect(card.easeFactor, equals(2.5));
      expect(card.intervalDays, equals(0));
      expect(card.reviewCount, equals(0));

      final updated = card.copyWith(
        reviewStatus: ReviewStatus.mastered,
        intervalDays: 25,
      );

      expect(updated.reviewStatus, equals(ReviewStatus.mastered));
      expect(updated.intervalDays, equals(25));
      expect(updated.word, equals('Sobremesa')); // Preserved
    });
  });
}
