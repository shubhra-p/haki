import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';
import '../tables.dart';
import '../../../models/enums.dart';
import '../../../models/flash_card.dart' as domain;

part 'card_dao.g.dart';

/// Data access object for flashcard operations.
@DriftAccessor(tables: [CardTable])
class CardDao extends DatabaseAccessor<HakiDatabase> with _$CardDaoMixin {
  CardDao(super.db);

  static const _uuid = Uuid();

  /// Get all cards for a deck
  Future<List<domain.FlashCard>> getCardsForDeck(String deckId) async {
    final rows = await (select(cardTable)
          ..where((c) => c.deckId.equals(deckId))
          ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Watch all cards for a deck (reactive)
  Stream<List<domain.FlashCard>> watchCardsForDeck(String deckId) {
    return (select(cardTable)
          ..where((c) => c.deckId.equals(deckId))
          ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  /// Get cards due for review in a deck
  Future<List<domain.FlashCard>> getDueCards(String deckId) async {
    final now = DateTime.now();
    final rows = await (select(cardTable)
          ..where(
            (c) =>
                c.deckId.equals(deckId) &
                (c.reviewStatus.equals(ReviewStatus.newCard.name) |
                    c.dueDate.isSmallerOrEqualValue(now) |
                    c.dueDate.isNull()),
          ))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Get all due cards across all decks
  Future<List<domain.FlashCard>> getAllDueCards() async {
    final now = DateTime.now();
    final rows = await (select(cardTable)
          ..where(
            (c) =>
                c.reviewStatus.equals(ReviewStatus.newCard.name) |
                c.dueDate.isSmallerOrEqualValue(now) |
                c.dueDate.isNull(),
          ))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Get a single card by ID
  Future<domain.FlashCard?> getCardById(String id) async {
    final query = select(cardTable)..where((c) => c.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  /// Create a new card
  Future<domain.FlashCard> createCard({
    required String deckId,
    required String word,
    required String meaning,
    String? transliteration,
    String? pronunciation,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await into(cardTable).insert(
      CardTableCompanion.insert(
        id: id,
        deckId: deckId,
        word: word,
        meaning: meaning,
        transliteration: Value(transliteration),
        pronunciation: Value(pronunciation),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return domain.FlashCard(
      id: id,
      deckId: deckId,
      word: word,
      meaning: meaning,
      transliteration: transliteration,
      pronunciation: pronunciation,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create multiple cards in a transaction (for CSV import)
  Future<List<domain.FlashCard>> createCards(
    List<CardTableCompanion> companions,
  ) async {
    return transaction(() async {
      final results = <domain.FlashCard>[];
      for (final companion in companions) {
        await into(cardTable).insert(companion);
        results.add(
          domain.FlashCard(
            id: companion.id.value,
            deckId: companion.deckId.value,
            word: companion.word.value,
            meaning: companion.meaning.value,
            transliteration: companion.transliteration.value,
            pronunciation: companion.pronunciation.value,
            createdAt: companion.createdAt.value,
            updatedAt: companion.updatedAt.value,
          ),
        );
      }
      return results;
    });
  }

  /// Update a card's content (preserves review history)
  Future<void> updateCardContent({
    required String id,
    String? word,
    String? meaning,
    String? transliteration,
    String? pronunciation,
    bool clearTransliteration = false,
    bool clearPronunciation = false,
  }) async {
    final companion = CardTableCompanion(
      word: word != null ? Value(word) : const Value.absent(),
      meaning: meaning != null ? Value(meaning) : const Value.absent(),
      transliteration: clearTransliteration
          ? const Value(null)
          : (transliteration != null
              ? Value(transliteration)
              : const Value.absent()),
      pronunciation: clearPronunciation
          ? const Value(null)
          : (pronunciation != null
              ? Value(pronunciation)
              : const Value.absent()),
      updatedAt: Value(DateTime.now()),
    );

    await (update(cardTable)..where((c) => c.id.equals(id))).write(companion);
  }

  /// Update a card's review data after a review
  Future<void> updateCardReview({
    required String id,
    required ReviewStatus status,
    required DateTime dueDate,
    required int intervalDays,
    required double easeFactor,
    required int reviewCount,
    required int correctCount,
    required int incorrectCount,
  }) async {
    await (update(cardTable)..where((c) => c.id.equals(id))).write(
      CardTableCompanion(
        reviewStatus: Value(status.name),
        lastReviewedAt: Value(DateTime.now()),
        dueDate: Value(dueDate),
        intervalDays: Value(intervalDays),
        easeFactor: Value(easeFactor),
        reviewCount: Value(reviewCount),
        correctCount: Value(correctCount),
        incorrectCount: Value(incorrectCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a card
  Future<void> deleteCard(String id) async {
    await transaction(() async {
      // Delete associated review events
      await (delete(db.reviewEventTable)..where((r) => r.cardId.equals(id)))
          .go();
      // Delete the card
      await (delete(cardTable)..where((c) => c.id.equals(id))).go();
    });
  }

  /// Duplicate a card (creates copy with new ID, resets review data)
  Future<domain.FlashCard> duplicateCard(String cardId) async {
    final original = await getCardById(cardId);
    if (original == null) {
      throw StateError('Card not found: $cardId');
    }

    return createCard(
      deckId: original.deckId,
      word: original.word,
      meaning: original.meaning,
      transliteration: original.transliteration,
      pronunciation: original.pronunciation,
    );
  }

  /// Check for duplicate cards by word in a deck
  Future<List<domain.FlashCard>> findDuplicates(
    String deckId,
    String word,
  ) async {
    final rows = await (select(cardTable)
          ..where(
            (c) =>
                c.deckId.equals(deckId) &
                c.word.lower().equals(word.toLowerCase()),
          ))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Replace card content but preserve identity and review history
  Future<void> replaceCardContent({
    required String existingCardId,
    required String word,
    required String meaning,
    String? transliteration,
    String? pronunciation,
  }) async {
    await (update(cardTable)..where((c) => c.id.equals(existingCardId))).write(
      CardTableCompanion(
        word: Value(word),
        meaning: Value(meaning),
        transliteration: Value(transliteration),
        pronunciation: Value(pronunciation),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get total card count across all decks
  Future<int> getTotalCardCount() async {
    final count = cardTable.id.count();
    final query = selectOnly(cardTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get mastered card count across all decks
  Future<int> getMasteredCardCount() async {
    final rows = await (select(cardTable)
          ..where((c) => c.reviewStatus.equals(ReviewStatus.mastered.name)))
        .get();
    return rows.length;
  }

  /// Watch mastered card count across all decks (reactive)
  Stream<int> watchMasteredCardCount() {
    return (select(cardTable)
          ..where((c) => c.reviewStatus.equals(ReviewStatus.mastered.name)))
        .watch()
        .map((rows) => rows.length);
  }

  /// Watch total due card count across all decks (reactive)
  Stream<int> watchTotalDueCards() {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {cardTable},
        )
        .watch()
        .asyncMap((_) async {
          final cards = await getAllDueCards();
          return cards.length;
        });
  }

  /// Get cards that need attention (learning, errors, or lowest ease factor)
  Future<List<domain.FlashCard>> getNeedsAttentionCards({int limit = 5}) async {
    final rows = await (select(cardTable)
          ..where(
            (c) =>
                c.reviewStatus.equals(ReviewStatus.learning.name) |
                c.incorrectCount.isBiggerThanValue(0),
          )
          ..orderBy([
            (c) => OrderingTerm.asc(c.easeFactor),
            (c) => OrderingTerm.desc(c.incorrectCount),
          ])
          ..limit(limit))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Watch cards that need attention (reactive)
  Stream<List<domain.FlashCard>> watchNeedsAttentionCards({int limit = 5}) {
    return (select(cardTable)
          ..where(
            (c) =>
                c.reviewStatus.equals(ReviewStatus.learning.name) |
                c.incorrectCount.isBiggerThanValue(0),
          )
          ..orderBy([
            (c) => OrderingTerm.asc(c.easeFactor),
            (c) => OrderingTerm.desc(c.incorrectCount),
          ])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  domain.FlashCard _toDomain(CardTableData data) {
    return domain.FlashCard(
      id: data.id,
      deckId: data.deckId,
      word: data.word,
      meaning: data.meaning,
      transliteration: data.transliteration,
      pronunciation: data.pronunciation,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastReviewedAt: data.lastReviewedAt,
      reviewStatus: ReviewStatus.values.firstWhere(
        (s) => s.name == data.reviewStatus,
        orElse: () => ReviewStatus.newCard,
      ),
      dueDate: data.dueDate,
      intervalDays: data.intervalDays,
      easeFactor: data.easeFactor,
      reviewCount: data.reviewCount,
      correctCount: data.correctCount,
      incorrectCount: data.incorrectCount,
    );
  }
}
