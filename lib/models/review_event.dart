import 'enums.dart';

/// A single review event, recorded each time a user rates a card.
///
/// Used for analytics, streak calculation, and audit trail.
class ReviewEvent {
  final String id;
  final String cardId;
  final String deckId;
  final ReviewRating rating;
  final DateTime reviewedAt;
  final int previousIntervalDays;
  final int newIntervalDays;
  final double previousEaseFactor;
  final double newEaseFactor;
  final int responseTimeMs;

  const ReviewEvent({
    required this.id,
    required this.cardId,
    required this.deckId,
    required this.rating,
    required this.reviewedAt,
    this.previousIntervalDays = 0,
    this.newIntervalDays = 0,
    this.previousEaseFactor = 2.5,
    this.newEaseFactor = 2.5,
    this.responseTimeMs = 0,
  });

  /// Whether this was a correct recall (not Again)
  bool get isCorrect => rating != ReviewRating.again;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEvent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Tracks a complete study session.
class StudySession {
  final String id;
  final String deckId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int cardsStudied;
  final int correctCount;
  final int incorrectCount;

  const StudySession({
    required this.id,
    required this.deckId,
    required this.startedAt,
    this.endedAt,
    this.cardsStudied = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
  });

  /// Session duration
  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  /// Accuracy percentage (0.0 - 1.0)
  double get accuracy {
    if (cardsStudied == 0) return 0.0;
    return correctCount / cardsStudied;
  }

  StudySession copyWith({
    String? id,
    String? deckId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? cardsStudied,
    int? correctCount,
    int? incorrectCount,
    bool clearEndedAt = false,
  }) {
    return StudySession(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: clearEndedAt ? null : (endedAt ?? this.endedAt),
      cardsStudied: cardsStudied ?? this.cardsStudied,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
