import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';
import '../../models/enums.dart';

/// Database seeder — provides initial realistic demo data matching DESIGN.md
/// and media screenshots. Runs only if database is completely empty.
class DatabaseSeeder {
  static const _uuid = Uuid();

  static Future<void> seedIfEmpty(HakiDatabase db) async {
    final deckDao = db.deckDao;

    final existingDecks = await deckDao.getAllDecks();
    if (existingDecks.isNotEmpty) return;

    final now = DateTime.now();

    // ─── Deck 1: Conversational Spanish ──────────────────────────────────
    final spanishDeck = await deckDao.createDeck(
      name: 'Conversational Spanish',
      sourceLanguage: 'Spanish',
      targetLanguage: 'English',
    );

    final spanishCards = [
      {
        'word': 'Sobremesa',
        'meaning':
            'The time spent lingering around the table engaged in conversation after a meal.',
        'transliteration': 'so-bre-me-sa',
        'pronunciation': '[so.βɾe.ˈme.sa]',
        'status': ReviewStatus.review,
        'dueOffsetHours': -2, // Due now
        'intervalDays': 1,
        'easeFactor': 2.5,
        'reviews': 3,
        'correct': 3,
      },
      {
        'word': 'Madrugada',
        'meaning':
            'Early dawn, the wee hours of the morning between midnight and sunrise.',
        'transliteration': 'ma-dru-ga-da',
        'pronunciation': '[ma.ðɾu.ˈɣa.ða]',
        'status': ReviewStatus.review,
        'dueOffsetHours': -1, // Due now
        'intervalDays': 2,
        'easeFactor': 2.4,
        'reviews': 4,
        'correct': 4,
      },
      {
        'word': 'Estrenar',
        'meaning':
            'To wear, use, or display something for the very first time.',
        'transliteration': 'es-tre-nar',
        'pronunciation': '[es.tɾe.ˈnaɾ]',
        'status': ReviewStatus.learning,
        'dueOffsetHours': 4,
        'intervalDays': 1,
        'easeFactor': 2.2,
        'reviews': 2,
        'correct': 1,
      },
      {
        'word': 'Desvelado',
        'meaning':
            'Kept awake, unable to sleep, or sleep-deprived from late hours.',
        'transliteration': 'des-ve-la-do',
        'pronunciation': '[des.βe.ˈla.ðo]',
        'status': ReviewStatus.review,
        'dueOffsetHours': -5, // Due now
        'intervalDays': 1,
        'easeFactor': 2.1,
        'reviews': 3,
        'correct': 2,
      },
      {
        'word': 'Empalagar',
        'meaning':
            'To feel sickened by something overly sweet, cloying, or excessively sentimental.',
        'transliteration': 'em-pa-la-gar',
        'pronunciation': '[em.pa.la.ˈɣaɾ]',
        'status': ReviewStatus.learning,
        'dueOffsetHours': 12,
        'intervalDays': 1,
        'easeFactor': 2.3,
        'reviews': 2,
        'correct': 1,
      },
      {
        'word': 'Friolero',
        'meaning':
            'A person who is exceptionally sensitive to cold temperatures.',
        'transliteration': 'frio-le-ro',
        'pronunciation': '[fɾjo.ˈle.ɾo]',
        'status': ReviewStatus.mastered,
        'dueOffsetHours': 72,
        'intervalDays': 24,
        'easeFactor': 2.7,
        'reviews': 6,
        'correct': 6,
      },
      {
        'word': 'Tutear',
        'meaning':
            'To address someone informally using "tú" instead of "usted".',
        'transliteration': 'tu-te-ar',
        'pronunciation': '[tu.te.ˈaɾ]',
        'status': ReviewStatus.mastered,
        'dueOffsetHours': 140,
        'intervalDays': 30,
        'easeFactor': 2.8,
        'reviews': 7,
        'correct': 7,
      },
    ];

    for (final c in spanishCards) {
      final cardId = _uuid.v4();
      final status = c['status'] as ReviewStatus;
      final offset = c['dueOffsetHours'] as int;
      final dueDate = now.add(Duration(hours: offset));

      await db.into(db.cardTable).insert(
            CardTableCompanion.insert(
              id: cardId,
              deckId: spanishDeck.id,
              word: c['word'] as String,
              meaning: c['meaning'] as String,
              transliteration: Value(c['transliteration'] as String?),
              pronunciation: Value(c['pronunciation'] as String?),
              reviewStatus: Value(status.name),
              dueDate: Value(dueDate),
              intervalDays: Value(c['intervalDays'] as int),
              easeFactor: Value(c['easeFactor'] as double),
              reviewCount: Value(c['reviews'] as int),
              correctCount: Value(c['correct'] as int),
              createdAt: Value(now.subtract(const Duration(days: 10))),
              updatedAt: Value(now),
            ),
          );

      // Create a few review events for history & momentum
      await db.into(db.reviewEventTable).insert(
            ReviewEventTableCompanion.insert(
              id: _uuid.v4(),
              cardId: cardId,
              deckId: spanishDeck.id,
              rating: ReviewRating.good.name,
              reviewedAt: Value(now.subtract(const Duration(days: 1))),
              previousIntervalDays: const Value(1),
              newIntervalDays: Value(c['intervalDays'] as int),
              previousEaseFactor: const Value(2.5),
              newEaseFactor: Value(c['easeFactor'] as double),
              responseTimeMs: const Value(1850),
            ),
          );
    }

    // ─── Deck 2: Essential Kanji & Vocab ─────────────────────────────────
    final kanjiDeck = await deckDao.createDeck(
      name: 'Essential Kanji & Vocab',
      sourceLanguage: 'Japanese',
      targetLanguage: 'English',
    );

    final kanjiCards = [
      {
        'word': '約束',
        'meaning': 'Promise, appointment, agreement',
        'transliteration': 'やくそく (yakusoku)',
        'pronunciation': '[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]',
        'status': ReviewStatus.review,
        'dueOffsetHours': -3,
        'intervalDays': 1,
        'easeFactor': 2.5,
      },
      {
        'word': '木漏れ日',
        'meaning': 'Sunlight filtering through trees and leaves',
        'transliteration': 'こもれび (komorebi)',
        'pronunciation': '[ko̞.mo̞.ɾe̞.bi]',
        'status': ReviewStatus.learning,
        'dueOffsetHours': 6,
        'intervalDays': 1,
        'easeFactor': 2.3,
      },
      {
        'word': '一期一会',
        'meaning': 'Once-in-a-lifetime encounter, treasure every meeting',
        'transliteration': 'いちごいちえ (ichigo ichie)',
        'pronunciation': '[i.t͡ɕi.ɡo̞ i.t͡ɕi.e̞]',
        'status': ReviewStatus.mastered,
        'dueOffsetHours': 96,
        'intervalDays': 21,
        'easeFactor': 2.6,
      },
    ];

    for (final c in kanjiCards) {
      final cardId = _uuid.v4();
      final status = c['status'] as ReviewStatus;
      final offset = c['dueOffsetHours'] as int;

      await db.into(db.cardTable).insert(
            CardTableCompanion.insert(
              id: cardId,
              deckId: kanjiDeck.id,
              word: c['word'] as String,
              meaning: c['meaning'] as String,
              transliteration: Value(c['transliteration'] as String?),
              pronunciation: Value(c['pronunciation'] as String?),
              reviewStatus: Value(status.name),
              dueDate: Value(now.add(Duration(hours: offset))),
              intervalDays: Value(c['intervalDays'] as int),
              easeFactor: Value(c['easeFactor'] as double),
              reviewCount: const Value(2),
              correctCount: const Value(2),
              createdAt: Value(now.subtract(const Duration(days: 5))),
              updatedAt: Value(now),
            ),
          );
    }

    // ─── Deck 3: Gastronomy & Wine Culture ───────────────────────────────
    final foodDeck = await deckDao.createDeck(
      name: 'Gastronomy & Wine Culture',
      sourceLanguage: 'French',
      targetLanguage: 'English',
    );

    final foodCards = [
      {
        'word': 'Terroir',
        'meaning':
            'The characteristic taste and flavor imparted to a wine by its environment.',
        'transliteration': 'tɛʁ.waʁ',
        'pronunciation': '[tɛʁ.waʁ]',
        'status': ReviewStatus.mastered,
      },
      {
        'word': 'Amuse-bouche',
        'meaning':
            'A single, bite-sized hors d\'œuvre served complimentary before a meal.',
        'transliteration': 'a.myz.buʃ',
        'pronunciation': '[a.myz.buʃ]',
        'status': ReviewStatus.mastered,
      },
    ];

    for (final c in foodCards) {
      await db.into(db.cardTable).insert(
            CardTableCompanion.insert(
              id: _uuid.v4(),
              deckId: foodDeck.id,
              word: c['word'] as String,
              meaning: c['meaning'] as String,
              transliteration: Value(c['transliteration'] as String?),
              pronunciation: Value(c['pronunciation'] as String?),
              reviewStatus: Value((c['status'] as ReviewStatus).name),
              dueDate: Value(now.add(const Duration(days: 14))),
              intervalDays: const Value(25),
              easeFactor: const Value(2.7),
              reviewCount: const Value(5),
              correctCount: const Value(5),
              createdAt: Value(now.subtract(const Duration(days: 20))),
              updatedAt: Value(now),
            ),
          );
    }
  }
}
