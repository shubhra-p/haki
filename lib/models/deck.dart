/// Domain model for a vocabulary deck.
///
/// Contains metadata and aggregate statistics.
/// Immutable - create new instances for updates.
class Deck {
  final String id;
  final String name;
  final String? sourceLanguage;
  final String? targetLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastStudiedAt;

  // Aggregate stats (populated from queries)
  final int totalCards;
  final int newCards;
  final int learningCards;
  final int masteredCards;
  final int dueCards;

  const Deck({
    required this.id,
    required this.name,
    this.sourceLanguage,
    this.targetLanguage,
    required this.createdAt,
    required this.updatedAt,
    this.lastStudiedAt,
    this.totalCards = 0,
    this.newCards = 0,
    this.learningCards = 0,
    this.masteredCards = 0,
    this.dueCards = 0,
  });

  /// Review cards = totalCards - newCards - masteredCards
  int get reviewCards => totalCards - newCards - masteredCards;

  /// Progress percentage (0.0 - 1.0)
  double get progressPercent {
    if (totalCards == 0) return 0.0;
    return masteredCards / totalCards;
  }

  /// Progress percentage as integer (0-100)
  int get progressPercentInt => (progressPercent * 100).round();

  /// Whether this deck has any cards
  bool get isEmpty => totalCards == 0;

  /// Whether all cards are mastered
  bool get isCompleted => totalCards > 0 && masteredCards == totalCards;

  /// Formatted language pair label (e.g., "EN → ES")
  String? get languagePairLabel {
    if (sourceLanguage == null && targetLanguage == null) return null;
    final source = sourceLanguage ?? '?';
    final target = targetLanguage ?? '?';
    return '$source → $target';
  }

  Deck copyWith({
    String? id,
    String? name,
    String? sourceLanguage,
    String? targetLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastStudiedAt,
    int? totalCards,
    int? newCards,
    int? learningCards,
    int? masteredCards,
    int? dueCards,
    bool clearSourceLanguage = false,
    bool clearTargetLanguage = false,
    bool clearLastStudiedAt = false,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceLanguage:
          clearSourceLanguage ? null : (sourceLanguage ?? this.sourceLanguage),
      targetLanguage:
          clearTargetLanguage ? null : (targetLanguage ?? this.targetLanguage),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastStudiedAt:
          clearLastStudiedAt ? null : (lastStudiedAt ?? this.lastStudiedAt),
      totalCards: totalCards ?? this.totalCards,
      newCards: newCards ?? this.newCards,
      learningCards: learningCards ?? this.learningCards,
      masteredCards: masteredCards ?? this.masteredCards,
      dueCards: dueCards ?? this.dueCards,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Deck && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Deck(id: $id, name: $name, cards: $totalCards)';
}
