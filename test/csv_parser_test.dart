import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:haki/models/enums.dart';
import 'package:haki/services/csv_parser.dart';

void main() {
  group('CsvParser', () {
    late CsvParser parser;

    setUp(() {
      parser = CsvParser();
    });

    test('parses simple valid CSV with standard headers', () {
      const csv = '''word,meaning,transliteration,pronunciation
sobremesa,after-lunch chat,so-bre-me-sa,[so.βɾe.ˈme.sa]
madrugada,early dawn,ma-dru-ga-da,[ma.ðɾu.ˈɣa.ða]''';

      final result = parser.parse(csv, hasHeader: true);

      expect(result.hasErrors, isFalse);
      expect(result.rows.length, equals(2));
      expect(result.validRows.length, equals(2));
      expect(result.rows[0].word, equals('sobremesa'));
      expect(result.rows[0].meaning, equals('after-lunch chat'));
      expect(result.rows[0].transliteration, equals('so-bre-me-sa'));
      expect(result.rows[0].pronunciation, equals('[so.βɾe.ˈme.sa]'));
      expect(result.rows[0].status, equals(ImportRowStatus.valid));
    });

    test('auto-detects alias column headers correctly', () {
      const csv = '''term,definition,romaji,phonetics
約束,promise,yakusoku,[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]
木漏れ日,sunlight through trees,komorebi,[ko̞.mo̞.ɾe̞.bi]''';

      final result = parser.parse(csv, hasHeader: true);

      expect(result.rows.length, equals(2));
      expect(result.rows[0].word, equals('約束'));
      expect(result.rows[0].meaning, equals('promise'));
      expect(result.rows[0].transliteration, equals('yakusoku'));
      expect(result.rows[0].pronunciation, equals('[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]'));
    });

    test('handles quotes, commas, and multiline content inside fields', () {
      const csv = '''word,meaning
"terroir","The complete natural environment, including soil, topography, and climate"
"amuse-bouche","A bite-sized hors d'oeuvre, served free"''';

      final result = parser.parse(csv, hasHeader: true);

      expect(result.rows.length, equals(2));
      expect(result.rows[0].word, equals('terroir'));
      expect(result.rows[0].meaning, contains('soil, topography, and climate'));
    });

    test('flags rows with missing required fields as invalid', () {
      const csv = '''word,meaning
sobremesa,
,early dawn
estrenar,to use for the first time''';

      final result = parser.parse(csv, hasHeader: true);

      expect(result.rows.length, equals(3));
      expect(result.validRows.length, equals(1));
      expect(result.invalidRows.length, equals(2));
      expect(result.rows[0].status, equals(ImportRowStatus.invalid));
      expect(result.rows[1].status, equals(ImportRowStatus.invalid));
      expect(result.rows[2].status, equals(ImportRowStatus.valid));
    });

    test('generates and parses sample CSV reliably', () {
      final sample = CsvParser.generateSampleCsv();
      expect(sample, isNotEmpty);

      final result = parser.parse(sample, hasHeader: true);
      expect(result.validRows.length, greaterThanOrEqualTo(5));
      expect(result.validRows.first.word, equals('sobremesa'));
    });

    test('exports cards list to CSV format with correct escaping', () {
      final cards = [
        {
          'word': 'café, solo',
          'meaning': 'espresso, "black"',
          'transliteration': 'ca-fe',
          'pronunciation': '[ka.fe]',
        },
      ];

      final exported = CsvParser.toCsv(cards);
      expect(exported, contains('"café, solo"'));
      expect(exported, contains('"espresso, ""black"""'));

      // Re-parse exported CSV to verify roundtrip fidelity
      final reparse = parser.parse(exported, hasHeader: true);
      expect(reparse.rows.length, equals(1));
      expect(reparse.rows[0].word, equals('café, solo'));
      expect(reparse.rows[0].meaning, equals('espresso, "black"'));
    });

    test(
        'decodeBytes correctly decodes UTF-8 multi-byte Japanese and IPA symbols',
        () {
      final rawUtf8 = utf8.encode('約束,A promise,やくそく,[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]');
      final decoded = CsvParser.decodeBytes(rawUtf8);
      expect(decoded, equals('約束,A promise,やくそく,[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]'));
    });

    test('decodeBytes strips UTF-8 Byte Order Mark (BOM)', () {
      final bomBytes = [
        0xEF,
        0xBB,
        0xBF,
        ...utf8.encode('word,meaning\n木漏れ日,sunlight'),
      ];
      final decoded = CsvParser.decodeBytes(bomBytes);
      expect(decoded.startsWith('word,meaning'), isTrue);
      expect(decoded, contains('木漏れ日'));
    });

    test('decodeBytes decodes other non-Latin scripts accurately', () {
      const scripts = '你好,안녕하세요,Привет,مرحبا,नमस्ते';
      final decoded = CsvParser.decodeBytes(utf8.encode(scripts));
      expect(decoded, equals(scripts));
    });

    test('generates Japanese sample and parses Kanji/Hiragana correctly', () {
      final sample = CsvParser.generateSampleCsv('Japanese');
      final result = parser.parse(sample, hasHeader: true);

      expect(result.validRows.length, greaterThanOrEqualTo(5));
      expect(result.validRows[0].word, equals('約束'));
      expect(result.validRows[0].meaning, equals('A promise or appointment'));
      expect(result.validRows[0].transliteration, equals('やくそく (yakusoku)'));
      expect(result.validRows[0].pronunciation, equals('[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]'));
    });
  });
}
