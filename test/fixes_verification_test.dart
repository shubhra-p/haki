import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haki/app.dart';
import 'package:haki/core/database/daos/card_dao.dart';
import 'package:haki/core/providers/providers.dart';
import 'package:haki/core/theme/colors.dart';
import 'package:haki/core/theme/theme.dart';
import 'package:haki/features/csv_import/csv_import_screen.dart';
import 'package:haki/features/study/study_screen.dart';
import 'package:haki/models/models.dart';
import 'package:haki/shared/widgets.dart';

import 'package:haki/core/database/daos/deck_dao.dart';
import 'package:haki/features/deck_detail/deck_detail_screen.dart';
import 'package:haki/features/deck_library/deck_library_screen.dart';
import 'package:haki/features/insights/insights_screen.dart';

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
  Future<void> updateDeck({
    required String id,
    String? name,
    String? sourceLanguage,
    String? targetLanguage,
    bool? showReadingOnFront,
    bool clearSourceLanguage = false,
    bool clearTargetLanguage = false,
  }) async {
    if (currentDeck != null) {
      currentDeck = currentDeck!.copyWith(
        name: name,
        sourceLanguage: clearSourceLanguage ? null : sourceLanguage,
        targetLanguage: clearTargetLanguage ? null : targetLanguage,
        showReadingOnFront: showReadingOnFront,
      );
    }
  }

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

  group('Feature: Front/Back Reading Placement for Character Recognition', () {
    testWidgets(
      'When showReadingOnFront is true, front shows reading & transliteration',
      (WidgetTester tester) async {
        final card = FlashCard(
          id: 'card-1',
          deckId: 'deck-jp',
          word: '食べる',
          meaning: 'to eat',
          transliteration: 'taberu',
          pronunciation: 'ta-be-ru',
          reviewStatus: ReviewStatus.newCard,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final deck = Deck(
          id: 'deck-jp',
          name: 'Japanese JLPT N4',
          sourceLanguage: 'Japanese',
          targetLanguage: 'English',
          showReadingOnFront: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cardDaoProvider.overrideWithValue(FakeCardDao([card])),
              deckByIdProvider('deck-jp').overrideWith(
                (ref) => Stream.value(deck),
              ),
              currentStreakProvider.overrideWith((ref) => 3),
            ],
            child: const MaterialApp(
              home: StudySessionScreen(deckId: 'deck-jp'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Front displays word, pronunciation, and transliteration
        expect(find.text('食べる'), findsOneWidget);
        expect(find.text('ta-be-ru'), findsOneWidget);
        expect(find.text('taberu'), findsOneWidget);
        expect(find.text('Readings on back'), findsNothing);

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'When showReadingOnFront is false, front hides reading & back reveals it on flip',
      (WidgetTester tester) async {
        final card = FlashCard(
          id: 'card-1',
          deckId: 'deck-jp-hide',
          word: '食べる',
          meaning: 'to eat',
          transliteration: 'taberu',
          pronunciation: 'ta-be-ru',
          reviewStatus: ReviewStatus.newCard,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final deck = Deck(
          id: 'deck-jp-hide',
          name: 'Japanese Kanji Recognition',
          sourceLanguage: 'Japanese',
          targetLanguage: 'English',
          showReadingOnFront: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cardDaoProvider.overrideWithValue(FakeCardDao([card])),
              deckByIdProvider('deck-jp-hide').overrideWith(
                (ref) => Stream.value(deck),
              ),
              currentStreakProvider.overrideWith((ref) => 3),
            ],
            child: const MaterialApp(
              home: StudySessionScreen(deckId: 'deck-jp-hide'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // On Front: Character is displayed, but reading & transliteration are HIDDEN
        expect(find.text('食べる'), findsOneWidget);
        expect(find.text('ta-be-ru'), findsNothing);
        expect(find.text('taberu'), findsNothing);
        expect(find.text('Readings on back'), findsOneWidget);

        // Tap the card to flip
        await tester.tap(find.text('食べる'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // On Back: Meaning and revealed readings (transliteration + pronunciation) are now visible!
        expect(find.text('to eat'), findsOneWidget);
        expect(find.text('taberu'), findsOneWidget);
        expect(find.text('ta-be-ru'), findsOneWidget);

        // Verify layout hierarchy on the back: Character -> Meaning -> Pronunciation -> Reading
        final wordPos = tester.getTopLeft(find.text('食べる')).dy;
        final meaningPos = tester.getTopLeft(find.text('to eat')).dy;
        final pronunciationPos = tester.getTopLeft(find.text('ta-be-ru')).dy;
        final transliterationPos = tester.getTopLeft(find.text('taberu')).dy;

        expect(
          wordPos < meaningPos,
          isTrue,
          reason: 'Character/word must appear above meaning on card back',
        );
        expect(
          meaningPos < pronunciationPos,
          isTrue,
          reason:
              'Meaning must appear directly below character/word, before pronunciation on card back',
        );
        expect(
          pronunciationPos < transliterationPos,
          isTrue,
          reason:
              'Pronunciation must appear before transliteration/reading on card back',
        );

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'DeckDetailScreen renders reading placement toggle and responds to interaction',
      (WidgetTester tester) async {
        final deck = Deck(
          id: 'deck-settings',
          name: 'Kanji Core 1000',
          sourceLanguage: 'Japanese',
          targetLanguage: 'English',
          showReadingOnFront: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final fakeDeckDao = FakeDeckDao(deck);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              deckDaoProvider.overrideWithValue(fakeDeckDao),
              deckByIdProvider('deck-settings').overrideWith(
                (ref) => Stream.value(fakeDeckDao.currentDeck),
              ),
              cardsForDeckProvider('deck-settings').overrideWith(
                (ref) => Stream.value([]),
              ),
            ],
            child: const MaterialApp(
              home: DeckDetailScreen(deckId: 'deck-settings'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify Reading Placement card is displayed
        expect(find.text('Card Readings'), findsOneWidget);
        expect(find.text('Shown on Front'), findsOneWidget);
        expect(find.text('Back'), findsOneWidget);

        // Tap 'Back' segment
        await tester.tap(find.text('Back'));
        await tester.pumpAndSettle();

        // Verify updateDeck was called with showReadingOnFront: false
        expect(fakeDeckDao.currentDeck?.showReadingOnFront, isFalse);
      },
    );

    testWidgets(
      'Issue: Long deck name does not cause RenderFlex overflow on top bar or deck cards on narrow screens',
      (WidgetTester tester) async {
        // Emulate a standard compact mobile viewport (360x800)
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final longNamedDeck = Deck(
          id: 'deck-long-name',
          name:
              'Japanese Advanced JLPT N1 Comprehensive Master Vocabulary Deck With Very Long Title',
          sourceLanguage: 'Japanese',
          targetLanguage: 'English',
          showReadingOnFront: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final card = FlashCard(
          id: 'c-long-1',
          deckId: 'deck-long-name',
          word: '挨拶',
          meaning: 'greeting',
          reviewStatus: ReviewStatus.newCard,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cardDaoProvider.overrideWithValue(FakeCardDao([card])),
              deckByIdProvider('deck-long-name').overrideWith(
                (ref) => Stream.value(longNamedDeck),
              ),
              currentStreakProvider.overrideWith((ref) => 15),
            ],
            child: const MaterialApp(
              home: StudySessionScreen(deckId: 'deck-long-name'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Ensure zero layout overflow errors were captured
        expect(tester.takeException(), isNull);

        // Verify all top-bar elements remain rendered and visible
        expect(find.byIcon(Icons.style), findsOneWidget);
        expect(find.byIcon(Icons.subtitles_outlined), findsOneWidget);
        expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
        expect(find.byIcon(Icons.close), findsAtLeastNWidgets(1));

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'Issue: Forgetting curve card and insights screen render with 0 overflow on compact mobile screens',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        FlutterErrorDetails? caughtDetails;
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          caughtDetails = details;
        };

        final dummyCard = FlashCard(
          id: 'card-1',
          deckId: 'deck-10',
          word: 'Supercalifragilisticexpialidocious',
          pronunciation: 'soo-per-kal-uh-fraj-uh-lis-tik-ek-spee-al-i-doh-shus',
          meaning:
              'Extraordinarily good; wonderful with extremely long explanation',
          intervalDays: 1,
          easeFactor: 1.3,
          incorrectCount: 5,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              totalReviewCountProvider.overrideWith((ref) => 42),
              totalStudyTimeProvider.overrideWith((ref) => 1800),
              totalMasteredProvider.overrideWith((ref) => 12),
              currentStreakProvider.overrideWith((ref) => 5),
              retentionRateProvider.overrideWith((ref) => 0.88),
              studyDaysProvider.overrideWith((ref) => [DateTime.now()]),
              needsAttentionCardsProvider.overrideWith((ref) => [dummyCard]),
            ],
            child: const MaterialApp(
              home: InsightsScreen(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        FlutterError.onError = originalOnError;

        expect(caughtDetails, isNull);
        expect(find.text('Forgetting Curve'), findsOneWidget);
        expect(find.text('SRS v2 (Projected)'), findsOneWidget);
        expect(find.text('LEARNING 1'), findsOneWidget);
        expect(find.text('MASTERED'), findsOneWidget);
        expect(find.text('Supercalifragilisticexpialidocious'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
      },
    );

    test('HakiColors adaptive tokens switch based on setDarkMode', () {
      HakiColors.setDarkMode(false);
      expect(HakiColors.isDarkMode, isFalse);
      expect(HakiColors.surface, equals(HakiColors.lightSurface));
      expect(HakiColors.cardBackground, equals(HakiColors.lightCardBackground));
      expect(HakiColors.textPrimary, equals(HakiColors.lightTextPrimary));

      HakiColors.setDarkMode(true);
      expect(HakiColors.isDarkMode, isTrue);
      expect(HakiColors.surface, equals(HakiColors.darkSurface));
      expect(HakiColors.cardBackground, equals(HakiColors.darkCardBackground));
      expect(HakiColors.textPrimary, equals(HakiColors.darkTextPrimary));

      // Reset to light
      HakiColors.setDarkMode(false);
    });

    test('ThemeModeNotifier toggles between system, light, and dark', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), equals(ThemeMode.system));

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), equals(ThemeMode.light));

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
      expect(container.read(themeModeProvider), equals(ThemeMode.system));
    });

    testWidgets('ThemeToggleButton quick toggles between light and dark modes',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final mode = ref.watch(themeModeProvider);
              return MaterialApp(
                theme: HakiTheme.light,
                darkTheme: HakiTheme.dark,
                themeMode: mode,
                home: const Scaffold(
                  body: Center(
                    child: ThemeToggleButton(),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeToggleButton), findsOneWidget);

      // Tap toggle button (starts at system -> toggles to dark or light depending on system)
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      final firstToggled = container.read(themeModeProvider);
      expect(firstToggled != ThemeMode.system, isTrue);

      // Tap again to switch to opposite
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      final secondToggled = container.read(themeModeProvider);
      expect(secondToggled != firstToggled, isTrue);
    });

    testWidgets(
        'ThemeToggleButton long press opens appearance bottom sheet with all 3 options',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final mode = ref.watch(themeModeProvider);
              return MaterialApp(
                theme: HakiTheme.light,
                darkTheme: HakiTheme.dark,
                themeMode: mode,
                home: const Scaffold(
                  body: Center(
                    child: ThemeToggleButton(),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Long press to show sheet
      await tester.longPress(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);

      // Tap Dark Mode option
      await tester.tap(find.text('Dark Mode'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
    });

    testWidgets(
        'Theme toggle button is present on InsightsScreen (Progress tab) and removed from DeckLibraryScreen',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          totalReviewCountProvider.overrideWith((ref) => 0),
          totalStudyTimeProvider.overrideWith((ref) => 0),
          totalMasteredProvider.overrideWith((ref) => 0),
          currentStreakProvider.overrideWith((ref) => 0),
          retentionRateProvider.overrideWith((ref) => 0.0),
          studyDaysProvider.overrideWith((ref) => []),
          needsAttentionCardsProvider.overrideWith((ref) => []),
          filteredDecksProvider
              .overrideWith((ref) => const AsyncValue.data(<Deck>[])),
          totalDueCardsProvider.overrideWith((ref) => 0),
        ],
      );
      addTearDown(container.dispose);

      // Verify DeckLibraryScreen has NO ThemeToggleButton
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DeckLibraryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ThemeToggleButton), findsNothing);

      // Verify InsightsScreen (Progress tab) has ThemeToggleButton
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: InsightsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ThemeToggleButton), findsOneWidget);

      // Tap ThemeToggleButton directly in InsightsScreen
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      // Verify theme instantly switched
      expect(container.read(themeModeProvider) != ThemeMode.system, isTrue);
    });

    test(
        'HakiColors darkOnPrimary and darkTextInverse provide high contrast white text',
        () {
      HakiColors.setDarkMode(true);
      expect(HakiColors.textInverse, equals(Colors.white));
      expect(HakiColors.onPrimary, equals(Colors.white));
      HakiColors.setDarkMode(false);
    });

    testWidgets(
        'StudyHomeScreen top banner and Study buttons render high contrast white text in dark mode',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final dummyDeck = Deck(
        id: 'test-deck',
        name: 'Japanese - 2 Syllable words',
        sourceLanguage: 'Japanese',
        targetLanguage: 'English',
        totalCards: 44,
        dueCards: 37,
        masteredCards: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          allDecksProvider.overrideWith((ref) => Stream.value([dummyDeck])),
          totalDueCardsProvider.overrideWith((ref) => 37),
          currentStreakProvider.overrideWith((ref) => 2),
        ],
      );
      addTearDown(container.dispose);

      HakiColors.setDarkMode(true);
      addTearDown(() => HakiColors.setDarkMode(false));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: HakiTheme.light,
            darkTheme: HakiTheme.dark,
            themeMode: ThemeMode.dark,
            home: const StudyHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top card heading "Ready for Review"
      final headingTextFinder = find.text('Ready for Review');
      expect(headingTextFinder, findsOneWidget);
      final Text headingWidget = tester.widget(headingTextFinder);
      expect(headingWidget.style?.color, equals(Colors.white));

      // Deck tile Study button
      final studyButtonFinder = find.widgetWithText(ElevatedButton, 'Study');
      expect(studyButtonFinder, findsOneWidget);
      final Text studyTextWidget = tester.widget(find.text('Study'));
      expect(studyTextWidget.style?.color, equals(Colors.white));
    });
  });
}
