import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';
import '../tables.dart';
import '../../../models/enums.dart';
import '../../../models/deck.dart' as domain;

part 'deck_dao.g.dart';

/// Data access object for deck operations.
@DriftAccessor(tables: [DeckTable, CardTable])
class DeckDao extends DatabaseAccessor<HakiDatabase> with _$DeckDaoMixin {
  DeckDao(super.db);

  static const _uuid = Uuid();

  /// Get all decks with their card statistics
  Future<List<domain.Deck>> getAllDecks() async {
    final decks = await select(deckTable).get();
    final result = <domain.Deck>[];

    for (final deck in decks) {
      final stats = await _getDeckStats(deck.id);
      result.add(_toDomain(deck, stats));
    }

    return result;
  }

  /// Watch all decks with stats (reactive stream)
  Stream<List<domain.Deck>> watchAllDecks() {
    return select(deckTable).watch().asyncMap((decks) async {
      final result = <domain.Deck>[];
      for (final deck in decks) {
        final stats = await _getDeckStats(deck.id);
        result.add(_toDomain(deck, stats));
      }
      return result;
    });
  }

  /// Get a single deck by ID with stats
  Future<domain.Deck?> getDeckById(String id) async {
    final query = select(deckTable)..where((d) => d.id.equals(id));
    final deck = await query.getSingleOrNull();
    if (deck == null) return null;
    final stats = await _getDeckStats(id);
    return _toDomain(deck, stats);
  }

  /// Watch a single deck by ID
  Stream<domain.Deck?> watchDeckById(String id) {
    final query = select(deckTable)..where((d) => d.id.equals(id));
    return query.watchSingleOrNull().asyncMap((deck) async {
      if (deck == null) return null;
      final stats = await _getDeckStats(id);
      return _toDomain(deck, stats);
    });
  }

  /// Create a new deck
  Future<domain.Deck> createDeck({
    required String name,
    String? sourceLanguage,
    String? targetLanguage,
    bool showReadingOnFront = true,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await into(deckTable).insert(
      DeckTableCompanion.insert(
        id: id,
        name: name,
        sourceLanguage: Value(sourceLanguage),
        targetLanguage: Value(targetLanguage),
        showReadingOnFront: Value(showReadingOnFront),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return domain.Deck(
      id: id,
      name: name,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      showReadingOnFront: showReadingOnFront,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Update deck metadata
  Future<void> updateDeck({
    required String id,
    String? name,
    String? sourceLanguage,
    String? targetLanguage,
    bool? showReadingOnFront,
    bool clearSourceLanguage = false,
    bool clearTargetLanguage = false,
  }) async {
    final companion = DeckTableCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      sourceLanguage: clearSourceLanguage
          ? const Value(null)
          : (sourceLanguage != null
              ? Value(sourceLanguage)
              : const Value.absent()),
      targetLanguage: clearTargetLanguage
          ? const Value(null)
          : (targetLanguage != null
              ? Value(targetLanguage)
              : const Value.absent()),
      showReadingOnFront: showReadingOnFront != null
          ? Value(showReadingOnFront)
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await (update(deckTable)..where((d) => d.id.equals(id))).write(companion);
  }

  /// Update the last studied timestamp
  Future<void> updateLastStudied(String deckId) async {
    await (update(deckTable)..where((d) => d.id.equals(deckId))).write(
      DeckTableCompanion(
        lastStudiedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a deck and all associated cards, reviews, and sessions
  Future<void> deleteDeck(String id) async {
    await transaction(() async {
      // Delete review events for cards in this deck
      await (delete(db.reviewEventTable)..where((r) => r.deckId.equals(id)))
          .go();

      // Delete study sessions for this deck
      await (delete(db.studySessionTable)..where((s) => s.deckId.equals(id)))
          .go();

      // Delete cards
      await (delete(cardTable)..where((c) => c.deckId.equals(id))).go();

      // Delete the deck
      await (delete(deckTable)..where((d) => d.id.equals(id))).go();
    });
  }

  /// Search decks by name
  Future<List<domain.Deck>> searchDecks(String query) async {
    final decks =
        await (select(deckTable)..where((d) => d.name.like('%$query%'))).get();

    final result = <domain.Deck>[];
    for (final deck in decks) {
      final stats = await _getDeckStats(deck.id);
      result.add(_toDomain(deck, stats));
    }
    return result;
  }

  /// Get card count statistics for a deck
  Future<_DeckStats> _getDeckStats(String deckId) async {
    final cards =
        await (select(cardTable)..where((c) => c.deckId.equals(deckId))).get();

    final int total = cards.length;
    int newCards = 0;
    int learning = 0;
    int mastered = 0;
    int due = 0;
    final now = DateTime.now();

    for (final card in cards) {
      final status = ReviewStatus.values.firstWhere(
        (s) => s.name == card.reviewStatus,
        orElse: () => ReviewStatus.newCard,
      );

      switch (status) {
        case ReviewStatus.newCard:
          newCards++;
          due++;
          break;
        case ReviewStatus.learning:
          learning++;
          if (card.dueDate == null || !now.isBefore(card.dueDate!)) {
            due++;
          }
          break;
        case ReviewStatus.review:
          if (card.dueDate == null || !now.isBefore(card.dueDate!)) {
            due++;
          }
          break;
        case ReviewStatus.mastered:
          mastered++;
          if (card.dueDate != null && !now.isBefore(card.dueDate!)) {
            due++;
          }
          break;
      }
    }

    return _DeckStats(
      total: total,
      newCards: newCards,
      learning: learning,
      mastered: mastered,
      due: due,
    );
  }

  domain.Deck _toDomain(DeckTableData data, _DeckStats stats) {
    return domain.Deck(
      id: data.id,
      name: data.name,
      sourceLanguage: data.sourceLanguage,
      targetLanguage: data.targetLanguage,
      showReadingOnFront: data.showReadingOnFront,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastStudiedAt: data.lastStudiedAt,
      totalCards: stats.total,
      newCards: stats.newCards,
      learningCards: stats.learning,
      masteredCards: stats.mastered,
      dueCards: stats.due,
    );
  }
}

class _DeckStats {
  final int total;
  final int newCards;
  final int learning;
  final int mastered;
  final int due;

  const _DeckStats({
    required this.total,
    required this.newCards,
    required this.learning,
    required this.mastered,
    required this.due,
  });
}
