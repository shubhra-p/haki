import 'enums.dart';

/// Domain model for a vocabulary flashcard.
///
/// Contains four primary content fields plus review metadata.
/// Immutable — create new instances for updates.
class FlashCard {
  final String id;
  final String deckId;
  final String word;
  final String meaning;
  final String? transliteration;
  final String? pronunciation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReviewedAt;
  final ReviewStatus reviewStatus;
  final DateTime? dueDate;
  final int intervalDays;
  final double easeFactor;
  final int reviewCount;
  final int correctCount;
  final int incorrectCount;

  const FlashCard({
    required this.id,
    required this.deckId,
    required this.word,
    required this.meaning,
    this.transliteration,
    this.pronunciation,
    required this.createdAt,
    required this.updatedAt,
    this.lastReviewedAt,
    this.reviewStatus = ReviewStatus.newCard,
    this.dueDate,
    this.intervalDays = 0,
    this.easeFactor = 2.5,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
  });

  /// Whether this card is due for review now
  bool get isDue {
    if (reviewStatus == ReviewStatus.newCard) return true;
    if (dueDate == null) return true;
    return DateTime.now().isAfter(dueDate!) ||
        DateTime.now().isAtSameMomentAs(dueDate!);
  }

  /// Whether this card is overdue (past due date by more than a day)
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().difference(dueDate!).inDays > 0;
  }

  /// Create a copy with updated fields
  FlashCard copyWith({
    String? id,
    String? deckId,
    String? word,
    String? meaning,
    String? transliteration,
    String? pronunciation,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastReviewedAt,
    ReviewStatus? reviewStatus,
    DateTime? dueDate,
    int? intervalDays,
    double? easeFactor,
    int? reviewCount,
    int? correctCount,
    int? incorrectCount,
    bool clearTransliteration = false,
    bool clearPronunciation = false,
    bool clearLastReviewedAt = false,
    bool clearDueDate = false,
  }) {
    return FlashCard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      transliteration: clearTransliteration
          ? null
          : (transliteration ?? this.transliteration),
      pronunciation:
          clearPronunciation ? null : (pronunciation ?? this.pronunciation),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReviewedAt:
          clearLastReviewedAt ? null : (lastReviewedAt ?? this.lastReviewedAt),
      reviewStatus: reviewStatus ?? this.reviewStatus,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FlashCard(id: $id, word: $word, meaning: $meaning)';
}
