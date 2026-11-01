import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haki/core/database/daos/card_dao.dart';
import 'package:haki/core/database/daos/deck_dao.dart';
import 'package:haki/core/database/daos/review_dao.dart';
import 'package:haki/core/providers/providers.dart';
import 'package:haki/features/deck_detail/deck_detail_screen.dart';
import 'package:haki/features/deck_library/deck_library_screen.dart';
import 'package:haki/features/study/study_screen.dart';
import 'package:haki/models/models.dart';

class FakeCardDao implements CardDao {
  final List<FlashCard> cards;
  final List<FlashCard> seenCards;

  FakeCardDao({
    this.cards = const [],
    this.seenCards = const [],
  });

  @override
  Future<List<FlashCard>> getDueCards(String deckId) async => cards;

  @override
  Future<List<FlashCard>> getCardsForDeck(String deckId) async => cards;

  @override
  Future<List<FlashCard>> getSeenCardsForDeck(String deckId) async => seenCards;

  @override
  Stream<List<FlashCard>> watchSeenCardsForDeck(String deckId) =>
      Stream.value(seenCards);

  @override
  Future<void> updateCardReview({
    required String id,
    required ReviewStatus status,
    required DateTime dueDate,
    required int intervalDays,
    required double easeFactor,
    required int reviewCount,
    required int correctCount,
    required int incorrectCount,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDeckDao implements DeckDao {
  Deck? currentDeck;
  FakeDeckDao(this.currentDeck);

  @override
  Future<Deck?> getDeckById(String id) async => currentDeck;

  @override
  Stream<Deck?> watchDeckById(String id) => Stream.value(currentDeck);

  @override
  Stream<List<Deck>> watchAllDecks() =>
      Stream.value(currentDeck != null ? [currentDeck!] : []);

  @override
  Future<void> updateLastStudied(String deckId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeReviewDao implements ReviewDao {
  @override
  Future<StudySession> startSession(String deckId) async {
    return StudySession(
      id: 'session-1',
      deckId: deckId,
      startedAt: DateTime.now(),
    );
  }

  @override
  Future<void> endSession({
    required String sessionId,
    required int cardsStudied,
    required int correctCount,
    required int incorrectCount,
  }) async {}

  @override
  Future<ReviewEvent> createReviewEvent({
    required String cardId,
    required String deckId,
    required ReviewRating rating,
    required int previousIntervalDays,
    required int newIntervalDays,
    required double previousEaseFactor,
    required double newEaseFactor,
    int responseTimeMs = 0,
  }) async {
    return ReviewEvent(
      id: 'event-1',
      cardId: cardId,
      deckId: deckId,
      rating: rating,
      reviewedAt: DateTime.now(),
      previousIntervalDays: previousIntervalDays,
      newIntervalDays: newIntervalDays,
      previousEaseFactor: previousEaseFactor,
      newEaseFactor: newEaseFactor,
      responseTimeMs: responseTimeMs,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Revise Seen Cards Domain & Logic Tests', () {
    test('Deck.seenCards and hasSeenCards compute correctly', () {
      final now = DateTime.now();
      final partiallyStudiedDeck = Deck(
        id: 'd1',
        name: 'Spanish 100 Words',
        totalCards: 100,
        newCards: 80,
        learningCards: 15,
        masteredCards: 5,
        dueCards: 80,
        createdAt: now,
        updatedAt: now,
      );

      // 100 total - 80 new = 20 seen cards
      expect(partiallyStudiedDeck.seenCards, equals(20));
      expect(partiallyStudiedDeck.hasSeenCards, isTrue);

      final freshDeck = Deck(
        id: 'd2',
        name: 'French 50 Words',
        totalCards: 50,
        newCards: 50,
        learningCards: 0,
        masteredCards: 0,
        dueCards: 50,
        createdAt: now,
        updatedAt: now,
      );

      // 50 total - 50 new = 0 seen cards
      expect(freshDeck.seenCards, equals(0));
      expect(freshDeck.hasSeenCards, isFalse);
    });

    test('Randomization shuffles order of seen cards with elements preserved',
        () {
      final cards = List.generate(
        20,
        (i) => FlashCard(
          id: 'c$i',
          deckId: 'd1',
          word: 'Word $i',
          meaning: 'Meaning $i',
          reviewStatus: ReviewStatus.review,
          reviewCount: 1,
          createdAt: DateTime.now().add(Duration(minutes: i)),
          updatedAt: DateTime.now(),
        ),
      );

      final shuffled1 = List<FlashCard>.from(cards)..shuffle(math.Random(42));
      final shuffled2 = List<FlashCard>.from(cards)..shuffle(math.Random(99));

      expect(shuffled1.length, equals(cards.length));
      expect(
        shuffled1.map((c) => c.id).toSet(),
        equals(cards.map((c) => c.id).toSet()),
      );

      final originalIds = cards.map((c) => c.id).toList();
      final shuffledIds1 = shuffled1.map((c) => c.id).toList();
      final shuffledIds2 = shuffled2.map((c) => c.id).toList();

      expect(shuffledIds1, isNot(equals(originalIds)));
      expect(shuffledIds2, isNot(equals(shuffledIds1)));
    });

    test(
        'Seen cards filter logic includes learning, review, and mastered, excluding new cards',
        () {
      final now = DateTime.now();
      final cardNew = FlashCard(
        id: 'c1',
        deckId: 'd1',
        word: 'New Word',
        meaning: 'Never seen',
        reviewStatus: ReviewStatus.newCard,
        reviewCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      final cardLearning = FlashCard(
        id: 'c2',
        deckId: 'd1',
        word: 'Learning Word',
        meaning: 'Studied once',
        reviewStatus: ReviewStatus.learning,
        reviewCount: 1,
        lastReviewedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final cardReview = FlashCard(
        id: 'c3',
        deckId: 'd1',
        word: 'Review Word',
        meaning: 'In review cycle',
        reviewStatus: ReviewStatus.review,
        reviewCount: 2,
        lastReviewedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final cardMastered = FlashCard(
        id: 'c4',
        deckId: 'd1',
        word: 'Mastered Word',
        meaning: 'Mastered lexeme',
        reviewStatus: ReviewStatus.mastered,
        reviewCount: 5,
        lastReviewedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      bool isCardSeen(FlashCard c) =>
          c.reviewStatus != ReviewStatus.newCard ||
          c.reviewCount > 0 ||
          c.lastReviewedAt != null;

      expect(isCardSeen(cardNew), isFalse);
      expect(isCardSeen(cardLearning), isTrue);
      expect(isCardSeen(cardReview), isTrue);
      expect(isCardSeen(cardMastered), isTrue);
    });
  });

  group('Revision UI and Navigation Widget Tests', () {
    testWidgets(
        'StudySessionScreen displays Revision top bar pill and seen card in revision mode',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final seenCard1 = FlashCard(
        id: 'c1',
        deckId: 'd1',
        word: 'ReviseMe1',
        meaning: 'First Seen Word',
        reviewStatus: ReviewStatus.learning,
        reviewCount: 1,
        createdAt: now,
        updatedAt: now,
      );
      final seenCard2 = FlashCard(
        id: 'c2',
        deckId: 'd1',
        word: 'ReviseMe2',
        meaning: 'Second Seen Word',
        reviewStatus: ReviewStatus.review,
        reviewCount: 2,
        createdAt: now,
        updatedAt: now,
      );

      final deck = Deck(
        id: 'd1',
        name: 'Japanese N5 Deck',
        totalCards: 10,
        newCards: 8,
        learningCards: 1,
        masteredCards: 1,
        createdAt: now,
        updatedAt: now,
      );

      final fakeCardDao = FakeCardDao(seenCards: [seenCard1, seenCard2]);
      final fakeDeckDao = FakeDeckDao(deck);
      final fakeReviewDao = FakeReviewDao();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deckByIdProvider('d1').overrideWith((ref) => Stream.value(deck)),
            cardsForDeckProvider('d1')
                .overrideWith((ref) => Stream.value([seenCard1, seenCard2])),
            cardDaoProvider.overrideWithValue(fakeCardDao),
            deckDaoProvider.overrideWithValue(fakeDeckDao),
            reviewDaoProvider.overrideWithValue(fakeReviewDao),
          ],
          child: const MaterialApp(
            home: StudySessionScreen(
              deckId: 'd1',
              isRevision: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Top bar displays (Revision) and shuffle icon
      expect(find.text('Japanese N5 Deck (Revision)'), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsAtLeastNWidgets(1));

      // Shows one of the seen cards
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && (w.data == 'ReviseMe1' || w.data == 'ReviseMe2'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'StudySessionScreen displays empty state when deck has 0 seen cards in revision mode',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final deck = Deck(
        id: 'd1',
        name: 'Brand New Deck',
        totalCards: 20,
        newCards: 20,
        createdAt: now,
        updatedAt: now,
      );

      final fakeCardDao = FakeCardDao(seenCards: []);
      final fakeDeckDao = FakeDeckDao(deck);
      final fakeReviewDao = FakeReviewDao();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deckByIdProvider('d1').overrideWith((ref) => Stream.value(deck)),
            cardsForDeckProvider('d1').overrideWith((ref) => Stream.value([])),
            cardDaoProvider.overrideWithValue(fakeCardDao),
            deckDaoProvider.overrideWithValue(fakeDeckDao),
            reviewDaoProvider.overrideWithValue(fakeReviewDao),
          ],
          child: const MaterialApp(
            home: StudySessionScreen(
              deckId: 'd1',
              isRevision: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No seen cards yet!'), findsOneWidget);
      expect(
        find.text(
          'You have not studied any cards in this deck yet. Study cards from this deck first to revise them.',
        ),
        findsOneWidget,
      );
      expect(find.text('Start Regular Study'), findsOneWidget);
      expect(find.text('Back to Decks'), findsOneWidget);
    });

    testWidgets(
        'DeckDetailScreen renders Revise Seen button and Study button in stats header',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final deck = Deck(
        id: 'd1',
        name: 'Korean Vocab',
        totalCards: 50,
        newCards: 30, // 20 seen cards
        learningCards: 15,
        masteredCards: 5,
        dueCards: 5,
        createdAt: now,
        updatedAt: now,
      );

      final fakeDeckDao = FakeDeckDao(deck);
      final fakeCardDao = FakeCardDao();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deckByIdProvider('d1').overrideWith((ref) => Stream.value(deck)),
            cardsForDeckProvider('d1').overrideWith((ref) => Stream.value([])),
            deckDaoProvider.overrideWithValue(fakeDeckDao),
            cardDaoProvider.overrideWithValue(fakeCardDao),
          ],
          child: const MaterialApp(
            home: DeckDetailScreen(deckId: 'd1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Revise Seen (20) button renders
      expect(find.text('Revise Seen (20)'), findsOneWidget);
      expect(find.text('Study (5)'), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'DeckLibraryScreen deck card displays Revise Seen button and seen count',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final deck = Deck(
        id: 'd1',
        name: 'German Words',
        totalCards: 100,
        newCards: 65, // 35 seen cards
        learningCards: 20,
        masteredCards: 15,
        dueCards: 12,
        createdAt: now,
        updatedAt: now,
      );

      final fakeDeckDao = FakeDeckDao(deck);
      final fakeCardDao = FakeCardDao();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDecksProvider.overrideWith((ref) => Stream.value([deck])),
            totalDueCardsProvider.overrideWith((ref) => Future.value(12)),
            currentStreakProvider.overrideWith((ref) => Future.value(3)),
            deckDaoProvider.overrideWithValue(fakeDeckDao),
            cardDaoProvider.overrideWithValue(fakeCardDao),
          ],
          child: const MaterialApp(
            home: DeckLibraryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Revise Seen (35)'), findsOneWidget);
      expect(find.text('35 Seen'), findsOneWidget);
      expect(find.text('Study Now'), findsOneWidget);
    });

    testWidgets(
        'StudyHomeScreen _StudyDeckTile displays shuffle revise button when deck has seen cards',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final deckWithSeen = Deck(
        id: 'd1',
        name: 'Italian Essentials',
        totalCards: 60,
        newCards: 40, // 20 seen cards
        learningCards: 10,
        masteredCards: 10,
        dueCards: 0,
        createdAt: now,
        updatedAt: now,
      );

      final fakeDeckDao = FakeDeckDao(deckWithSeen);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDecksProvider
                .overrideWith((ref) => Stream.value([deckWithSeen])),
            totalDueCardsProvider.overrideWith((ref) => Future.value(0)),
            currentStreakProvider.overrideWith((ref) => Future.value(5)),
            deckDaoProvider.overrideWithValue(fakeDeckDao),
          ],
          child: const MaterialApp(
            home: StudyHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shuffle), findsOneWidget);
      expect(find.text('Flip'), findsOneWidget);
    });
  });
}
