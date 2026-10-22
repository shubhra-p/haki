import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haki/app.dart';
import 'package:haki/core/database/daos/card_dao.dart';
import 'package:haki/core/providers/providers.dart';
import 'package:haki/features/csv_import/csv_import_screen.dart';
import 'package:haki/features/study/study_screen.dart';
import 'package:haki/models/models.dart';

class FakeCardDao implements CardDao {
  final List<FlashCard> cards;
  FakeCardDao(this.cards);

  @override
  Future<List<FlashCard>> getDueCards(String deckId) async => cards;

  @override
  Future<List<FlashCard>> getCardsForDeck(String deckId) async => cards;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Defect Fixes Verification', () {
    testWidgets(
      'Issue 1: Decks window -> Click create deck and leave without creating does not throw',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: HakiApp(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Find the + button to create deck
        final addBtn = find.byIcon(Icons.add);
        expect(addBtn, findsWidgets);
        await tester.tap(addBtn.first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Bottom sheet is visible
        expect(find.text('Create New Deck'), findsOneWidget);

        // Dismiss the bottom sheet by tapping outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is gone and no exception was thrown
        expect(find.text('Create New Deck'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Issue 2: Create window -> Navigating to /create renders language dropdowns without error',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: HakiApp(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Tap on Create tab
        final createTab = find.text('Create');
        expect(createTab, findsOneWidget);
        await tester.tap(createTab);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify CsvImportScreen is rendered
        expect(find.byType(CsvImportScreen), findsOneWidget);
        expect(find.text('Learning'), findsOneWidget);
        expect(find.text('In Language'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Tap Try Sample to test CSV loading & column mapping dropdowns
        final trySample = find.text('Try Sample');
        expect(trySample, findsOneWidget);
        await tester.tap(trySample);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify mapping card rendered without any assertion error
        expect(find.text('Column Header Mapping'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Issue 2 Edge Case: CsvImportScreen with existingDeckId containing novel language',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: CsvImportScreen(existingDeckId: 'non-existent-deck'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify no assertion error is thrown
        expect(find.byType(CsvImportScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Issue 3: StudySessionScreen does not render hardcoded culinary or B2 tags',
      (WidgetTester tester) async {
        final card = FlashCard(
          id: 'card-1',
          deckId: 'deck-1',
          word: '食べる',
          meaning: 'to eat',
          transliteration: 'taberu',
          pronunciation: 'ta-be-ru',
          reviewStatus: ReviewStatus.newCard,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final fakeCardDao = FakeCardDao([card]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cardDaoProvider.overrideWithValue(fakeCardDao),
              deckByIdProvider('deck-1').overrideWith(
                (ref) => Stream.value(
                  Deck(
                    id: 'deck-1',
                    name: 'Japanese JLPT N4',
                    sourceLanguage: 'Japanese',
                    targetLanguage: 'English',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                ),
              ),
              currentStreakProvider.overrideWith((ref) => 5),
            ],
            child: const MaterialApp(
              home: StudySessionScreen(deckId: 'deck-1'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify card contents are visible
        expect(find.text('食べる'), findsOneWidget);
        expect(find.text('ta-be-ru'), findsOneWidget);
        expect(find.text('taberu'), findsOneWidget);

        // Verify hardcoded culinary & B2 intermediate are NOT present
        expect(find.text('CULINARY & DINING'), findsNothing);
        expect(find.text('B2 Intermediate'), findsNothing);
        expect(find.text('Spanish B2'), findsNothing);

        // Verify dynamic status badge is present
        expect(find.text('NEW CARD'), findsOneWidget);

        // Unmount widget so periodic timer stops
        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'Issue 4: Japanese CSV input in CsvImportScreen parses Kanji/Kana cleanly without mojibake',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: CsvImportScreen(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Switch to Japanese sample
        final langDropdown = find.text('Spanish');
        expect(langDropdown, findsOneWidget);
        await tester.tap(langDropdown);
        await tester.pumpAndSettle();

        final japaneseItem = find.text('Japanese').last;
        await tester.tap(japaneseItem);
        await tester.pumpAndSettle();

        // Tap Try Sample
        final trySampleBtn = find.text('Try Sample');
        expect(trySampleBtn, findsOneWidget);
        await tester.tap(trySampleBtn);
        await tester.pumpAndSettle();

        // Verify Japanese text rendered in preview
        expect(find.text('約束'), findsOneWidget);
        expect(find.text('A promise or appointment'), findsOneWidget);
        expect(find.text('[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]'), findsOneWidget);

        // Verify NO mojibake characters exist in the widget tree
        expect(find.textContaining('ç´æ'), findsNothing);
        expect(find.textContaining('ã‚'), findsNothing);
      },
    );
  });
}
