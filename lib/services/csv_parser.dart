import 'dart:convert';
import 'package:csv/csv.dart';
import '../../models/enums.dart';

/// Result of parsing a CSV file for flashcard import.
class CsvParseResult {
  final List<CsvRow> rows;
  final List<String> headers;
  final ColumnMapping mapping;
  final List<CsvError> errors;
  final int totalRowCount;

  const CsvParseResult({
    required this.rows,
    required this.headers,
    required this.mapping,
    required this.errors,
    required this.totalRowCount,
  });

  /// Valid rows ready for import
  List<CsvRow> get validRows =>
      rows.where((r) => r.status == ImportRowStatus.valid).toList();

  /// Invalid rows with errors
  List<CsvRow> get invalidRows =>
      rows.where((r) => r.status == ImportRowStatus.invalid).toList();

  bool get hasErrors => errors.isNotEmpty;
  bool get hasValidRows => validRows.isNotEmpty;
}

/// A single parsed CSV row with its validation status.
class CsvRow {
  final int lineNumber;
  final String word;
  final String meaning;
  final String? transliteration;
  final String? pronunciation;
  final ImportRowStatus status;
  final String? errorMessage;
  final List<String> rawFields;

  const CsvRow({
    required this.lineNumber,
    required this.word,
    required this.meaning,
    this.transliteration,
    this.pronunciation,
    this.status = ImportRowStatus.valid,
    this.errorMessage,
    this.rawFields = const [],
  });

  CsvRow copyWith({
    int? lineNumber,
    String? word,
    String? meaning,
    String? transliteration,
    String? pronunciation,
    ImportRowStatus? status,
    String? errorMessage,
    List<String>? rawFields,
    bool clearTransliteration = false,
    bool clearPronunciation = false,
    bool clearErrorMessage = false,
  }) {
    return CsvRow(
      lineNumber: lineNumber ?? this.lineNumber,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      transliteration: clearTransliteration
          ? null
          : (transliteration ?? this.transliteration),
      pronunciation:
          clearPronunciation ? null : (pronunciation ?? this.pronunciation),
      status: status ?? this.status,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      rawFields: rawFields ?? this.rawFields,
    );
  }
}

/// Error during CSV parsing.
class CsvError {
  final int lineNumber;
  final String message;
  final CsvErrorType type;

  const CsvError({
    required this.lineNumber,
    required this.message,
    required this.type,
  });
}

enum CsvErrorType {
  missingRequiredField,
  invalidFormat,
  emptyRow,
  headerMissing,
  tooFewColumns,
}

/// Maps CSV column indices to card fields.
class ColumnMapping {
  final int wordIndex;
  final int meaningIndex;
  final int? transliterationIndex;
  final int? pronunciationIndex;

  const ColumnMapping({
    required this.wordIndex,
    required this.meaningIndex,
    this.transliterationIndex,
    this.pronunciationIndex,
  });
}

/// Robust CSV parser for flashcard import.
///
/// Handles:
/// - UTF-8, non-English scripts, diacritics
/// - Quoted commas and escaped quotation marks
/// - CRLF/LF line endings
/// - Blank optional fields
/// - Alternative column header names
class CsvParser {
  /// Known header name aliases for each field
  static const Map<String, List<String>> headerAliases = {
    'word': [
      'word',
      'term',
      'vocabulary',
      'vocab',
      'front',
      'question',
      'target',
      'target_word',
      'foreign',
      'original',
    ],
    'meaning': [
      'meaning',
      'definition',
      'translation',
      'back',
      'answer',
      'english',
      'native',
      'translated',
    ],
    'transliteration': [
      'transliteration',
      'romanization',
      'romaji',
      'pinyin',
      'romanized',
      'latin',
      'reading',
    ],
    'pronunciation': [
      'pronunciation',
      'ipa',
      'phonetic',
      'phonetics',
      'sound',
      'phonemic',
    ],
  };

  /// Parse a CSV string into rows.
  ///
  /// [content] - The CSV string content.
  /// [hasHeader] - Whether the first row is a header row.
  /// [customMapping] - Optional custom column mapping override.
  CsvParseResult parse(
    String content, {
    bool hasHeader = true,
    ColumnMapping? customMapping,
  }) {
    // Normalize line endings
    final normalized =
        content.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

    if (normalized.isEmpty) {
      return const CsvParseResult(
        rows: [],
        headers: [],
        mapping: ColumnMapping(wordIndex: 0, meaningIndex: 1),
        errors: [
          CsvError(
            lineNumber: 0,
            message: 'CSV file is empty',
            type: CsvErrorType.invalidFormat,
          ),
        ],
        totalRowCount: 0,
      );
    }

    // Use the csv package for proper RFC 4180 parsing
    final List<List<dynamic>> allRows;
    try {
      allRows =
          Csv(dynamicTyping: false, skipEmptyLines: false).decode(normalized);
    } catch (e) {
      return CsvParseResult(
        rows: const [],
        headers: const [],
        mapping: const ColumnMapping(wordIndex: 0, meaningIndex: 1),
        errors: [
          CsvError(
            lineNumber: 0,
            message: 'Failed to parse CSV: $e',
            type: CsvErrorType.invalidFormat,
          ),
        ],
        totalRowCount: 0,
      );
    }

    if (allRows.isEmpty) {
      return const CsvParseResult(
        rows: [],
        headers: [],
        mapping: ColumnMapping(wordIndex: 0, meaningIndex: 1),
        errors: [
          CsvError(
            lineNumber: 0,
            message: 'No rows found in CSV',
            type: CsvErrorType.invalidFormat,
          ),
        ],
        totalRowCount: 0,
      );
    }

    // Extract headers and determine mapping
    List<String> headers = [];
    ColumnMapping mapping;
    int dataStartRow;

    if (hasHeader && customMapping == null) {
      headers = allRows[0].map((e) => e.toString().trim()).toList();
      mapping = _detectMapping(headers);
      dataStartRow = 1;
    } else if (customMapping != null) {
      mapping = customMapping;
      if (hasHeader) {
        headers = allRows[0].map((e) => e.toString().trim()).toList();
        dataStartRow = 1;
      } else {
        dataStartRow = 0;
      }
    } else {
      // No header, default mapping: col 0 = word, col 1 = meaning
      mapping = const ColumnMapping(wordIndex: 0, meaningIndex: 1);
      dataStartRow = 0;
    }

    // Parse data rows
    final parsedRows = <CsvRow>[];
    final errors = <CsvError>[];

    for (var i = dataStartRow; i < allRows.length; i++) {
      final row = allRows[i];
      final lineNumber = i + 1; // 1-indexed for user display
      final fields = row.map((e) => e.toString().trim()).toList();

      // Skip completely empty rows
      if (fields.every((f) => f.isEmpty)) {
        continue;
      }

      // Check minimum column count
      final requiredCols = [mapping.wordIndex, mapping.meaningIndex];
      final maxRequired = requiredCols.reduce((a, b) => a > b ? a : b);

      if (fields.length <= maxRequired) {
        errors.add(
          CsvError(
            lineNumber: lineNumber,
            message:
                'Row has ${fields.length} columns, but needs at least ${maxRequired + 1}',
            type: CsvErrorType.tooFewColumns,
          ),
        );
        parsedRows.add(
          CsvRow(
            lineNumber: lineNumber,
            word: '',
            meaning: '',
            status: ImportRowStatus.invalid,
            errorMessage:
                'Too few columns (${fields.length}/${maxRequired + 1})',
            rawFields: fields,
          ),
        );
        continue;
      }

      final word = fields[mapping.wordIndex];
      final meaning = fields[mapping.meaningIndex];

      // Validate required fields
      if (word.isEmpty) {
        errors.add(
          CsvError(
            lineNumber: lineNumber,
            message: 'Word field is empty',
            type: CsvErrorType.missingRequiredField,
          ),
        );
        parsedRows.add(
          CsvRow(
            lineNumber: lineNumber,
            word: word,
            meaning: meaning,
            status: ImportRowStatus.invalid,
            errorMessage: 'Word is required',
            rawFields: fields,
          ),
        );
        continue;
      }

      if (meaning.isEmpty) {
        errors.add(
          CsvError(
            lineNumber: lineNumber,
            message: 'Meaning field is empty',
            type: CsvErrorType.missingRequiredField,
          ),
        );
        parsedRows.add(
          CsvRow(
            lineNumber: lineNumber,
            word: word,
            meaning: meaning,
            status: ImportRowStatus.invalid,
            errorMessage: 'Meaning is required',
            rawFields: fields,
          ),
        );
        continue;
      }

      // Extract optional fields
      String? transliteration;
      if (mapping.transliterationIndex != null &&
          fields.length > mapping.transliterationIndex!) {
        final val = fields[mapping.transliterationIndex!];
        transliteration = val.isNotEmpty ? val : null;
      }

      String? pronunciation;
      if (mapping.pronunciationIndex != null &&
          fields.length > mapping.pronunciationIndex!) {
        final val = fields[mapping.pronunciationIndex!];
        pronunciation = val.isNotEmpty ? val : null;
      }

      parsedRows.add(
        CsvRow(
          lineNumber: lineNumber,
          word: word,
          meaning: meaning,
          transliteration: transliteration,
          pronunciation: pronunciation,
          status: ImportRowStatus.valid,
          rawFields: fields,
        ),
      );
    }

    return CsvParseResult(
      rows: parsedRows,
      headers: headers,
      mapping: mapping,
      errors: errors,
      totalRowCount: allRows.length - (hasHeader ? 1 : 0),
    );
  }

  /// Auto-detect column mapping from header names.
  ColumnMapping _detectMapping(List<String> headers) {
    int wordIdx = -1;
    int meaningIdx = -1;
    int? translitIdx;
    int? pronIdx;

    for (var i = 0; i < headers.length; i++) {
      final header =
          headers[i].toLowerCase().replaceAll(RegExp(r'[_\s-]+'), '');

      if (wordIdx < 0 && _matchesAliases(header, 'word')) {
        wordIdx = i;
      } else if (meaningIdx < 0 && _matchesAliases(header, 'meaning')) {
        meaningIdx = i;
      } else if (translitIdx == null &&
          _matchesAliases(header, 'transliteration')) {
        translitIdx = i;
      } else if (pronIdx == null && _matchesAliases(header, 'pronunciation')) {
        pronIdx = i;
      }
    }

    // Fallback: first two columns if headers don't match
    if (wordIdx < 0) wordIdx = 0;
    if (meaningIdx < 0) meaningIdx = wordIdx == 0 ? 1 : 0;

    return ColumnMapping(
      wordIndex: wordIdx,
      meaningIndex: meaningIdx,
      transliterationIndex: translitIdx,
      pronunciationIndex: pronIdx,
    );
  }

  bool _matchesAliases(String normalized, String field) {
    final aliases = headerAliases[field] ?? [];
    return aliases
        .any((alias) => normalized == alias.replaceAll(RegExp(r'[_\s-]+'), ''));
  }

  /// Decodes raw file bytes into a clean Unicode string.
  ///
  /// Correctly handles:
  /// - Multi-byte UTF-8 sequences (Japanese, Chinese, Arabic, Cyrillic, Hindi, IPA phonetics, etc.)
  /// - UTF-8 with Byte Order Mark (BOM `\uFEFF` / `0xEF, 0xBB, 0xBF`)
  /// - Graceful fallback to Latin-1 if file is not UTF-8 encoded
  static String decodeBytes(List<int> bytes) {
    if (bytes.isEmpty) return '';

    List<int> effectiveBytes = bytes;
    // Strip UTF-8 BOM if present at byte level (0xEF, 0xBB, 0xBF)
    if (bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF) {
      effectiveBytes = bytes.sublist(3);
    }

    try {
      String decoded = utf8.decode(effectiveBytes, allowMalformed: false);
      if (decoded.startsWith('\uFEFF')) {
        decoded = decoded.substring(1);
      }
      return decoded;
    } catch (_) {
      try {
        String decoded = utf8.decode(effectiveBytes, allowMalformed: true);
        if (decoded.startsWith('\uFEFF')) {
          decoded = decoded.substring(1);
        }
        return decoded;
      } catch (_) {
        return latin1.decode(effectiveBytes);
      }
    }
  }

  /// Generate a sample CSV string for testing or onboarding
  static String generateSampleCsv([String? language]) {
    if (language?.toLowerCase() == 'japanese') {
      return '''term,definition,reading,phonetics
約束,A promise or appointment,やくそく (yakusoku),[ja.kɯ̟ᵝ.so̞.kɯ̟ᵝ]
木漏れ日,Sunlight filtering through trees,こもれび (komorebi),[ko̞.mo̞.ɾe̞.bi]
一期一会,Once-in-a-lifetime encounter,いちごいちえ (ichigo ichie),[i.t͡ɕi.ɡo̞ i.t͡ɕi.e̞]
風情,Atmosphere / seasonal charm,ふぜい (fuzei),[ɸɯ̟ᵝ.ze̞ː]
忘れ物,Forgotten item / lost property,わすれもの (wasuremono),[wa.sɯ̟ᵝ.ɾe̞.mo̞.no̞]
思いやり,Thoughtfulness / empathy / compassion,おもいやり (omoiyari),[o̞.mo̞.i.ja.ɾi]
青空,Clear blue open sky,あおぞら (aozora),[a.o̞.zo̞.ɾa]
時間,Time / hours,じかん (jikan),[d͡ʑi.kã̠ɴ]
水,Water / cold water,みず (mizu),[mʲi.zɨᵝ]
''';
    }
    return '''word,meaning,transliteration,pronunciation
sobremesa,after-meal conversation,so-bre-me-sa,[so.βɾe.ˈme.sa]
madrugada,early dawn / wee hours,ma-dru-ga-da,[ma.ðɾu.ˈɣa.ða]
estrenar,to use for the first time,es-tre-nar,[es.tɾe.ˈnaɾ]
desvelado,sleepless / unable to sleep,des-ve-la-do,[des.βe.ˈla.ðo]
empalagar,to be sickeningly sweet,em-pa-la-gar,[em.pa.la.ˈɣaɾ]
''';
  }

  /// Convert cards to CSV string for export
  static String toCsv(List<Map<String, String>> cards) {
    final buffer = StringBuffer();
    buffer.writeln('word,meaning,transliteration,pronunciation');
    for (final card in cards) {
      final word = _escapeCsvField(card['word'] ?? '');
      final meaning = _escapeCsvField(card['meaning'] ?? '');
      final translit = _escapeCsvField(card['transliteration'] ?? '');
      final pron = _escapeCsvField(card['pronunciation'] ?? '');
      buffer.writeln('$word,$meaning,$translit,$pron');
    }
    return buffer.toString();
  }

  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }
}
