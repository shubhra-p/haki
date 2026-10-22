import 'package:drift/drift.dart';

/// Deck table — stores vocabulary deck metadata
class DeckTable extends Table {
  @override
  String get tableName => 'decks';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sourceLanguage => text().nullable()();
  TextColumn get targetLanguage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastStudiedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Card table — stores individual vocabulary flashcards
class CardTable extends Table {
  @override
  String get tableName => 'cards';

  TextColumn get id => text()();
  TextColumn get deckId => text().references(DeckTable, #id)();
  TextColumn get word => text().withLength(min: 1)();
  TextColumn get meaning => text().withLength(min: 1)();
  TextColumn get transliteration => text().nullable()();
  TextColumn get pronunciation => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  TextColumn get reviewStatus =>
      text().withDefault(const Constant('newCard'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Review event table — audit trail for every review action
class ReviewEventTable extends Table {
  @override
  String get tableName => 'review_events';

  TextColumn get id => text()();
  TextColumn get cardId => text().references(CardTable, #id)();
  TextColumn get deckId => text().references(DeckTable, #id)();
  TextColumn get rating => text()();
  DateTimeColumn get reviewedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get previousIntervalDays =>
      integer().withDefault(const Constant(0))();
  IntColumn get newIntervalDays => integer().withDefault(const Constant(0))();
  RealColumn get previousEaseFactor =>
      real().withDefault(const Constant(2.5))();
  RealColumn get newEaseFactor => real().withDefault(const Constant(2.5))();
  IntColumn get responseTimeMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Study session table — tracks complete study sessions
class StudySessionTable extends Table {
  @override
  String get tableName => 'study_sessions';

  TextColumn get id => text()();
  TextColumn get deckId => text().references(DeckTable, #id)();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get cardsStudied => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
