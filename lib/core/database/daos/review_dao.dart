import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';
import '../tables.dart';
import '../../../models/enums.dart';
import '../../../models/review_event.dart' as domain;

part 'review_dao.g.dart';

/// Data access object for review events and study sessions.
@DriftAccessor(tables: [ReviewEventTable, StudySessionTable])
class ReviewDao extends DatabaseAccessor<HakiDatabase> with _$ReviewDaoMixin {
  ReviewDao(super.db);

  static const _uuid = Uuid();

  // ─── Review Events ─────────────────────────────────────────────────

  /// Record a review event
  Future<domain.ReviewEvent> createReviewEvent({
    required String cardId,
    required String deckId,
    required ReviewRating rating,
    required int previousIntervalDays,
    required int newIntervalDays,
    required double previousEaseFactor,
    required double newEaseFactor,
    int responseTimeMs = 0,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await into(reviewEventTable).insert(
      ReviewEventTableCompanion.insert(
        id: id,
        cardId: cardId,
        deckId: deckId,
        rating: rating.name,
        reviewedAt: Value(now),
        previousIntervalDays: Value(previousIntervalDays),
        newIntervalDays: Value(newIntervalDays),
        previousEaseFactor: Value(previousEaseFactor),
        newEaseFactor: Value(newEaseFactor),
        responseTimeMs: Value(responseTimeMs),
      ),
    );

    return domain.ReviewEvent(
      id: id,
      cardId: cardId,
      deckId: deckId,
      rating: rating,
      reviewedAt: now,
      previousIntervalDays: previousIntervalDays,
      newIntervalDays: newIntervalDays,
      previousEaseFactor: previousEaseFactor,
      newEaseFactor: newEaseFactor,
      responseTimeMs: responseTimeMs,
    );
  }

  /// Get all review events for a card
  Future<List<domain.ReviewEvent>> getReviewsForCard(String cardId) async {
    final rows = await (select(reviewEventTable)
          ..where((r) => r.cardId.equals(cardId))
          ..orderBy([(r) => OrderingTerm.desc(r.reviewedAt)]))
        .get();
    return rows.map(_reviewToDomain).toList();
  }

  /// Get all review events for a deck
  Future<List<domain.ReviewEvent>> getReviewsForDeck(String deckId) async {
    final rows = await (select(reviewEventTable)
          ..where((r) => r.deckId.equals(deckId))
          ..orderBy([(r) => OrderingTerm.desc(r.reviewedAt)]))
        .get();
    return rows.map(_reviewToDomain).toList();
  }

  /// Get review events in a date range
  Future<List<domain.ReviewEvent>> getReviewsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await (select(reviewEventTable)
          ..where(
            (r) =>
                r.reviewedAt.isBiggerOrEqualValue(start) &
                r.reviewedAt.isSmallerOrEqualValue(end),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.reviewedAt)]))
        .get();
    return rows.map(_reviewToDomain).toList();
  }

  /// Get total review count
  Future<int> getTotalReviewCount() async {
    final count = reviewEventTable.id.count();
    final query = selectOnly(reviewEventTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get recent review events across all decks
  Future<List<domain.ReviewEvent>> getAllReviews({int limit = 500}) async {
    final rows = await (select(reviewEventTable)
          ..orderBy([(r) => OrderingTerm.desc(r.reviewedAt)])
          ..limit(limit))
        .get();
    return rows.map(_reviewToDomain).toList();
  }

  /// Get reviews for today
  Future<List<domain.ReviewEvent>> getTodayReviews() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getReviewsInRange(startOfDay, endOfDay);
  }

  /// Get the most recent review event for undo
  Future<domain.ReviewEvent?> getLastReviewEvent(String deckId) async {
    final query = select(reviewEventTable)
      ..where((r) => r.deckId.equals(deckId))
      ..orderBy([(r) => OrderingTerm.desc(r.reviewedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null ? _reviewToDomain(row) : null;
  }

  /// Delete a review event (for undo)
  Future<void> deleteReviewEvent(String id) async {
    await (delete(reviewEventTable)..where((r) => r.id.equals(id))).go();
  }

  // ─── Study Sessions ───────────────────────────────────────────────

  /// Start a new study session
  Future<domain.StudySession> startSession(String deckId) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await into(studySessionTable).insert(
      StudySessionTableCompanion.insert(
        id: id,
        deckId: deckId,
        startedAt: Value(now),
      ),
    );

    return domain.StudySession(
      id: id,
      deckId: deckId,
      startedAt: now,
    );
  }

  /// End a study session
  Future<void> endSession({
    required String sessionId,
    required int cardsStudied,
    required int correctCount,
    required int incorrectCount,
  }) async {
    await (update(studySessionTable)..where((s) => s.id.equals(sessionId)))
        .write(
      StudySessionTableCompanion(
        endedAt: Value(DateTime.now()),
        cardsStudied: Value(cardsStudied),
        correctCount: Value(correctCount),
        incorrectCount: Value(incorrectCount),
      ),
    );
  }

  /// Get all study sessions
  Future<List<domain.StudySession>> getAllSessions() async {
    final rows = await (select(studySessionTable)
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
    return rows.map(_sessionToDomain).toList();
  }

  /// Get sessions for a deck
  Future<List<domain.StudySession>> getSessionsForDeck(
    String deckId,
  ) async {
    final rows = await (select(studySessionTable)
          ..where((s) => s.deckId.equals(deckId))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
    return rows.map(_sessionToDomain).toList();
  }

  /// Get total study time in seconds
  Future<int> getTotalStudyTimeSeconds() async {
    final sessions = await getAllSessions();
    int total = 0;
    for (final session in sessions) {
      if (session.endedAt != null) {
        total += session.endedAt!.difference(session.startedAt).inSeconds;
      }
    }
    return total;
  }

  /// Get study days for streak calculation
  Future<List<DateTime>> getStudyDays() async {
    final sessions = await getAllSessions();
    final days = <DateTime>{};
    for (final session in sessions) {
      days.add(
        DateTime(
          session.startedAt.year,
          session.startedAt.month,
          session.startedAt.day,
        ),
      );
    }
    final sorted = days.toList()..sort();
    return sorted;
  }

  // ─── Mappers ───────────────────────────────────────────────────────

  domain.ReviewEvent _reviewToDomain(ReviewEventTableData data) {
    return domain.ReviewEvent(
      id: data.id,
      cardId: data.cardId,
      deckId: data.deckId,
      rating: ReviewRating.values.firstWhere(
        (r) => r.name == data.rating,
        orElse: () => ReviewRating.again,
      ),
      reviewedAt: data.reviewedAt,
      previousIntervalDays: data.previousIntervalDays,
      newIntervalDays: data.newIntervalDays,
      previousEaseFactor: data.previousEaseFactor,
      newEaseFactor: data.newEaseFactor,
      responseTimeMs: data.responseTimeMs,
    );
  }

  domain.StudySession _sessionToDomain(StudySessionTableData data) {
    return domain.StudySession(
      id: data.id,
      deckId: data.deckId,
      startedAt: data.startedAt,
      endedAt: data.endedAt,
      cardsStudied: data.cardsStudied,
      correctCount: data.correctCount,
      incorrectCount: data.incorrectCount,
    );
  }
}
