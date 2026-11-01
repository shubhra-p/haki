import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/elevation.dart';
import '../../core/providers/providers.dart';
import '../../core/database/database.dart';
import '../../models/models.dart';
import '../../services/csv_parser.dart';
import 'package:uuid/uuid.dart';
import '../../shared/widgets.dart';

/// CSV Import Screen — CSV-based deck creation and row appending.

/// Supports:
/// - File picker & raw text pasting
/// - One-tap sample CSV load
/// - Auto-detected column headers with manual overrides
/// - Duplicate handling options (Skip, Keep Both, Overwrite)
/// - Interactive live preview of parsed rows
/// - Validation error callouts
class CsvImportScreen extends ConsumerStatefulWidget {
  final String? existingDeckId;

  const CsvImportScreen({super.key, this.existingDeckId});

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  final _parser = CsvParser();
  late final TextEditingController _deckNameController;
  late final TextEditingController _csvTextController;

  String _selectedLanguage = 'Spanish';
  String _selectedTargetLanguage = 'English';
  bool _showReadingOnFront = true;
  DuplicateResolution _duplicateMode = DuplicateResolution.skip;

  String? _loadedFileName;
  CsvParseResult? _parseResult;
  bool _isParsing = false;
  bool _isImporting = false;
  bool _showRawTextInput = false;

  // Custom column mapping indices (if user overrides)
  int _wordColumnIndex = 0;
  int _meaningColumnIndex = 1;
  int? _translitColumnIndex;
  int? _pronunciationColumnIndex;

  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'Japanese',
    'French',
    'German',
    'Italian',
    'Mandarin',
    'Korean',
    'Portuguese',
    'Russian',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _deckNameController = TextEditingController(
      text: widget.existingDeckId == null
          ? 'Spanish B2 — Gastronomy & Culture'
          : '',
    );
    _csvTextController = TextEditingController();
    if (widget.existingDeckId != null) {
      _loadExistingDeck();
    }
  }

  @override
  void dispose() {
    _deckNameController.dispose();
    _csvTextController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingDeck() async {
    final deck =
        await ref.read(deckDaoProvider).getDeckById(widget.existingDeckId!);
    if (deck != null && mounted) {
      setState(() {
        _deckNameController.text = deck.name;
        _showReadingOnFront = deck.showReadingOnFront;
        final src = deck.sourceLanguage ?? 'Spanish';
        final tgt = deck.targetLanguage ?? 'English';
        if (!_availableLanguages.contains(src)) {
          _availableLanguages.add(src);
        }
        if (!_availableLanguages.contains(tgt)) {
          _availableLanguages.add(tgt);
        }
        _selectedLanguage = src;
        _selectedTargetLanguage = tgt;
      });
    }
  }

  void _loadSampleData() {
    final sample = CsvParser.generateSampleCsv(_selectedLanguage);
    _csvTextController.text = sample;
    _loadedFileName = _selectedLanguage.toLowerCase() == 'japanese'
        ? 'japanese_jlpt_n4_sample.csv'
        : 'sample_vocabulary.csv';
    _parseCsvContent(sample);
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'tsv', 'txt'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        String content = '';
        if (file.bytes != null && file.bytes!.isNotEmpty) {
          content = CsvParser.decodeBytes(file.bytes!);
        } else if (file.path != null && file.path!.isNotEmpty) {
          final ioFile = File(file.path!);
          if (await ioFile.exists()) {
            final bytes = await ioFile.readAsBytes();
            content = CsvParser.decodeBytes(bytes);
          }
        }

        if (content.isNotEmpty) {
          final detectedLang = _detectLanguage(content, file.name);

          setState(() {
            _loadedFileName = file.name;
            _csvTextController.text = content;
            if (detectedLang != null) {
              if (!_availableLanguages.contains(detectedLang)) {
                _availableLanguages.add(detectedLang);
              }
              _selectedLanguage = detectedLang;
            }
            if (widget.existingDeckId == null &&
                _deckNameController.text.isEmpty) {
              _deckNameController.text =
                  file.name.replaceAll(RegExp(r'\.[^.]+$'), '');
            }
          });
          _parseCsvContent(content);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open file picker: $e. You can paste CSV text directly below.',
            ),
            backgroundColor: HakiColors.error,
          ),
        );
        setState(() => _showRawTextInput = true);
      }
    }
  }

  String? _detectLanguage(String content, String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.contains('japanese') ||
        lower.contains('jlpt') ||
        RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]').hasMatch(content)) {
      return 'Japanese';
    }
    if (lower.contains('korean') ||
        RegExp(r'[\uAC00-\uD7AF]').hasMatch(content)) {
      return 'Korean';
    }
    if (lower.contains('chinese') || lower.contains('mandarin')) {
      return 'Mandarin';
    }
    if (lower.contains('russian') ||
        RegExp(r'[\u0400-\u04FF]').hasMatch(content)) {
      return 'Russian';
    }
    if (lower.contains('spanish')) {
      return 'Spanish';
    }
    return null;
  }

  void _parseCsvContent(String content) {
    if (content.trim().isEmpty) return;

    setState(() => _isParsing = true);

    try {
      final result = _parser.parse(
        content,
        hasHeader: true,
      );

      setState(() {
        _parseResult = result;
        _isParsing = false;
        _wordColumnIndex = result.mapping.wordIndex;
        _meaningColumnIndex = result.mapping.meaningIndex;
        _translitColumnIndex = result.mapping.transliterationIndex;
        _pronunciationColumnIndex = result.mapping.pronunciationIndex;
      });
    } catch (e) {
      setState(() => _isParsing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to parse CSV: $e'),
          backgroundColor: HakiColors.error,
        ),
      );
    }
  }

  void _reapplyMapping() {
    if (_csvTextController.text.trim().isEmpty) return;
    final result = _parser.parse(
      _csvTextController.text,
      hasHeader: true,
      customMapping: ColumnMapping(
        wordIndex: _wordColumnIndex,
        meaningIndex: _meaningColumnIndex,
        transliterationIndex: _translitColumnIndex,
        pronunciationIndex: _pronunciationColumnIndex,
      ),
    );
    setState(() => _parseResult = result);
  }

  Future<void> _executeImport() async {
    final result = _parseResult;
    if (result == null || result.validRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid rows found to import.'),
          backgroundColor: HakiColors.error,
        ),
      );
      return;
    }

    final deckName = _deckNameController.text.trim();
    if (widget.existingDeckId == null && deckName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a deck name.'),
          backgroundColor: HakiColors.error,
        ),
      );
      return;
    }

    setState(() => _isImporting = true);

    try {
      String targetDeckId = widget.existingDeckId ?? '';

      // 1. Create deck if not existing
      if (widget.existingDeckId == null) {
        final newDeck = await ref.read(deckDaoProvider).createDeck(
              name: deckName,
              sourceLanguage: _selectedLanguage,
              targetLanguage: _selectedTargetLanguage,
              showReadingOnFront: _showReadingOnFront,
            );
        targetDeckId = newDeck.id;
      }

      // 2. Load existing cards in this deck to detect duplicates
      final existingCards =
          await ref.read(cardDaoProvider).getCardsForDeck(targetDeckId);
      final existingWordMap = {
        for (final c in existingCards) c.word.trim().toLowerCase(): c,
      };

      final companionsToInsert = <CardTableCompanion>[];
      int skippedCount = 0;
      int updatedCount = 0;

      for (final row in result.validRows) {
        final normalizedWord = row.word.trim().toLowerCase();
        final existingCard = existingWordMap[normalizedWord];

        if (existingCard != null) {
          switch (_duplicateMode) {
            case DuplicateResolution.skip:
              skippedCount++;
              continue;
            case DuplicateResolution.replace:
              await ref.read(cardDaoProvider).updateCardContent(
                    id: existingCard.id,
                    word: row.word.trim(),
                    meaning: row.meaning.trim(),
                    transliteration: row.transliteration?.trim(),
                    pronunciation: row.pronunciation?.trim(),
                  );
              updatedCount++;
              continue;
            case DuplicateResolution.keepBoth:
              // Fallthrough to insert
              break;
          }
        }

        companionsToInsert.add(
          CardTableCompanion.insert(
            id: const Uuid().v4(),
            deckId: targetDeckId,
            word: row.word.trim(),
            meaning: row.meaning.trim(),
            transliteration: drift.Value(row.transliteration?.trim()),
            pronunciation: drift.Value(row.pronunciation?.trim()),
            createdAt: drift.Value(DateTime.now()),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      }

      if (companionsToInsert.isNotEmpty) {
        await ref.read(cardDaoProvider).createCards(companionsToInsert);
      }

      setState(() => _isImporting = false);

      if (!mounted) return;

      _showSuccessDialog(
        deckId: targetDeckId,
        deckName: deckName.isNotEmpty ? deckName : 'Deck',
        insertedCount: companionsToInsert.length,
        skippedCount: skippedCount,
        updatedCount: updatedCount,
      );
    } catch (e) {
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import failed: $e'),
          backgroundColor: HakiColors.error,
        ),
      );
    }
  }

  void _showSuccessDialog({
    required String deckId,
    required String deckName,
    required int insertedCount,
    required int skippedCount,
    required int updatedCount,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: HakiColors.cardBackground,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: HakiColors.tertiaryFixed,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, color: HakiColors.tertiary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Import Complete!',
                style: HakiTypography.headlineSm
                    .copyWith(color: HakiColors.textPrimary),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Successfully processed CSV into "$deckName":',
              style: HakiTypography.bodyMd
                  .copyWith(color: HakiColors.textSecondary),
            ),
            const SizedBox(height: 16),
            _SummaryStatRow(
              icon: Icons.add_circle_outline,
              label: 'Cards Added',
              value: '$insertedCount',
              color: HakiColors.tertiary,
            ),
            if (updatedCount > 0)
              _SummaryStatRow(
                icon: Icons.sync,
                label: 'Cards Updated',
                value: '$updatedCount',
                color: HakiColors.primaryFixedDim,
              ),
            if (skippedCount > 0)
              _SummaryStatRow(
                icon: Icons.skip_next_outlined,
                label: 'Duplicates Skipped',
                value: '$skippedCount',
                color: HakiColors.textSecondary,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/decks/$deckId');
            },
            child: Text(
              'View Deck',
              style: HakiTypography.labelLg
                  .copyWith(color: HakiColors.textPrimary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HakiColors.isDarkMode
                  ? const Color(0xFF4F46E5)
                  : HakiColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: HakiRadius.fullAll),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/study/$deckId');
            },
            child: const Text('Study Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final isNewDeck = widget.existingDeckId == null;
    final padding = HakiSpacing.screenPadding(context);

    return Scaffold(
      backgroundColor: HakiColors.surface,
      appBar: AppBar(
        title: Text(
          isNewDeck ? 'Create & Import Deck' : 'Append to Deck',
          style:
              HakiTypography.headlineSm.copyWith(color: HakiColors.textPrimary),
        ),
        backgroundColor: HakiColors.surface,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _loadSampleData,
            icon: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: HakiColors.secondary,
            ),
            label: Text(
              'Try Sample',
              style:
                  HakiTypography.labelMd.copyWith(color: HakiColors.secondary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: padding.copyWith(top: 12, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Deck Configuration (if new deck) ───────────────
            if (isNewDeck) ...[
              _buildSectionTitle('Deck Details'),
              const SizedBox(height: 8),
              HakiCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _deckNameController,
                      style: HakiTypography.headlineSm.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Deck Name',
                        hintText: 'e.g. Spanish B2 Vocabulary',
                        prefixIcon: Icon(
                          Icons.style_outlined,
                          color: HakiColors.primary,
                        ),
                        filled: true,
                        fillColor: HakiColors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Learning',
                              filled: true,
                              fillColor: HakiColors.surfaceContainerLow,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _availableLanguages
                                        .contains(_selectedLanguage)
                                    ? _selectedLanguage
                                    : _availableLanguages.first,
                                isExpanded: true,
                                style: HakiTypography.bodyMd.copyWith(
                                  color: HakiColors.textPrimary,
                                ),
                                items: _availableLanguages.toSet().map((lang) {
                                  return DropdownMenuItem<String>(
                                    value: lang,
                                    child: Text(lang),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedLanguage = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'In Language',
                              filled: true,
                              fillColor: HakiColors.surfaceContainerLow,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _availableLanguages
                                        .contains(_selectedTargetLanguage)
                                    ? _selectedTargetLanguage
                                    : 'English',
                                isExpanded: true,
                                style: HakiTypography.bodyMd.copyWith(
                                  color: HakiColors.textPrimary,
                                ),
                                items: _availableLanguages.toSet().map((lang) {
                                  return DropdownMenuItem<String>(
                                    value: lang,
                                    child: Text(lang),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(
                                      () => _selectedTargetLanguage = val,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Reading Placement Option
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: HakiColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reading Placement',
                                  style: HakiTypography.labelSm.copyWith(
                                    color: HakiColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _showReadingOnFront
                                      ? 'Front (Visible immediately)'
                                      : 'Back (Reveal after flip)',
                                  style: HakiTypography.bodySm.copyWith(
                                    color: HakiColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: true,
                                label: Text('Front'),
                                icon: Icon(Icons.crop_portrait, size: 14),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('Back'),
                                icon: Icon(Icons.flip, size: 14),
                              ),
                            ],
                            selected: {_showReadingOnFront},
                            onSelectionChanged: (set) {
                              if (set.isNotEmpty) {
                                setState(
                                  () => _showReadingOnFront = set.first,
                                );
                              }
                            },
                            style: ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              textStyle: WidgetStateProperty.all(
                                HakiTypography.labelSm.copyWith(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            //CSV Dropzone / Source Picker
            _buildSectionTitle('CSV Source'),
            const SizedBox(height: 8),
            _buildDropZone(),

            const SizedBox(height: 16),

            //Duplicate Handling Strategy
            _buildSectionTitle('Duplicate Detection'),
            const SizedBox(height: 8),
            _buildDuplicateModeSelector(),

            const SizedBox(height: 20),

            //Column Mapping & Preview
            if (_parseResult != null) ...[
              _buildColumnMappingCard(),
              const SizedBox(height: 20),
              _buildPreviewSection(),
              const SizedBox(height: 24),
            ],

            //Action Button
            HakiButton(
              label: _isImporting
                  ? 'Importing Cards...'
                  : _parseResult != null
                      ? 'Import ${_parseResult!.validRows.length} Cards'
                      : 'Load CSV to Import',
              icon: Icons.cloud_download_outlined,
              isLoading: _isImporting || _isParsing,
              onPressed: (_parseResult != null &&
                      _parseResult!.hasValidRows &&
                      !_isImporting &&
                      !_isParsing)
                  ? _executeImport
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: HakiTypography.labelLg.copyWith(
        color: HakiColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropZone() {
    final hasFile = _loadedFileName != null;

    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: HakiColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? HakiColors.tertiary : HakiColors.cardBorder,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: HakiElevation.level1,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: hasFile
                    ? HakiColors.tertiaryFixed.withValues(alpha: 0.3)
                    : HakiColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFile ? Icons.check_circle_outline : Icons.upload_file,
                size: 36,
                color: hasFile ? HakiColors.tertiary : HakiColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasFile ? _loadedFileName! : 'Tap to pick .CSV or .TSV file',
              style: HakiTypography.headlineSm.copyWith(
                fontSize: 16,
                color: HakiColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Supports UTF-8, quotes, diacritics, and Kanji / non-Latin scripts',
              style: HakiTypography.bodySm
                  .copyWith(color: HakiColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.folder_open, size: 16),
                  label: const Text('Browse Files'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HakiColors.isDarkMode
                        ? HakiColors.darkTextPrimary
                        : HakiColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: HakiRadius.fullAll,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() => _showRawTextInput = !_showRawTextInput);
                  },
                  child: Text(
                    _showRawTextInput ? 'Hide Text Input' : 'Paste CSV Text',
                  ),
                ),
              ],
            ),
            if (_showRawTextInput) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _csvTextController,
                maxLines: 5,
                style: HakiTypography.phoneticDisplay.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText:
                      'word,meaning,transliteration,pronunciation\nsobremesa,after-lunch chat,so-bre-me-sa,[so.βɾe.ˈme.sa]',
                  filled: true,
                  fillColor: HakiColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (text) => _parseCsvContent(text),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDuplicateModeSelector() {
    return HakiCard(
      padding: const EdgeInsets.all(12),
      child: RadioGroup<DuplicateResolution>(
        groupValue: _duplicateMode,
        onChanged: (val) {
          if (val != null) {
            setState(() => _duplicateMode = val);
          }
        },
        child: Column(
          children: [
            RadioListTile<DuplicateResolution>(
              title:
                  Text('Skip duplicate words', style: HakiTypography.labelMd),
              subtitle: Text(
                'Keep existing card; do not add duplicates',
                style: HakiTypography.bodySm,
              ),
              value: DuplicateResolution.skip,
              dense: true,
              activeColor: HakiColors.primary,
            ),
            RadioListTile<DuplicateResolution>(
              title: Text(
                'Update / Overwrite existing words',
                style: HakiTypography.labelMd,
              ),
              subtitle: Text(
                'Refresh translation and phonetic data while preserving review history',
                style: HakiTypography.bodySm,
              ),
              value: DuplicateResolution.replace,
              dense: true,
              activeColor: HakiColors.primary,
            ),
            RadioListTile<DuplicateResolution>(
              title: Text(
                'Keep both (Allow duplicates)',
                style: HakiTypography.labelMd,
              ),
              subtitle: Text(
                'Always add rows even if word already exists in deck',
                style: HakiTypography.bodySm,
              ),
              value: DuplicateResolution.keepBoth,
              dense: true,
              activeColor: HakiColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnMappingCard() {
    final result = _parseResult!;
    final headers = result.headers;

    return HakiCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.table_chart_outlined,
                color: HakiColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Column Header Mapping',
                style: HakiTypography.headlineSm.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Confirm which CSV columns correspond to flashcard properties:',
            style:
                HakiTypography.bodySm.copyWith(color: HakiColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _buildMappingDropdown(
            label: 'Word / Front (Required)',
            selectedIndex: _wordColumnIndex,
            headers: headers,
            onChanged: (val) {
              if (val != null) {
                setState(() => _wordColumnIndex = val);
                _reapplyMapping();
              }
            },
          ),
          const SizedBox(height: 8),
          _buildMappingDropdown(
            label: 'Meaning / Back (Required)',
            selectedIndex: _meaningColumnIndex,
            headers: headers,
            onChanged: (val) {
              if (val != null) {
                setState(() => _meaningColumnIndex = val);
                _reapplyMapping();
              }
            },
          ),
          const SizedBox(height: 8),
          _buildMappingDropdown(
            label: 'Transliteration / Reading (Optional)',
            selectedIndex: _translitColumnIndex,
            headers: headers,
            allowNone: true,
            onChanged: (val) {
              setState(() => _translitColumnIndex = val);
              _reapplyMapping();
            },
          ),
          const SizedBox(height: 8),
          _buildMappingDropdown(
            label: 'Pronunciation / IPA (Optional)',
            selectedIndex: _pronunciationColumnIndex,
            headers: headers,
            allowNone: true,
            onChanged: (val) {
              setState(() => _pronunciationColumnIndex = val);
              _reapplyMapping();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMappingDropdown({
    required String label,
    required int? selectedIndex,
    required List<String> headers,
    required ValueChanged<int?> onChanged,
    bool allowNone = false,
  }) {
    final bool hasMatchingItem = (allowNone && selectedIndex == null) ||
        (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < headers.length);
    final int? effectiveValue = hasMatchingItem
        ? selectedIndex
        : (allowNone
            ? null
            : (headers.isNotEmpty ? 0 : null));

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(label, style: HakiTypography.labelSm),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: HakiColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: effectiveValue,
                isExpanded: true,
                style: HakiTypography.bodySm
                    .copyWith(color: HakiColors.textPrimary),
                items: [
                  if (allowNone)
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        '(None)',
                        style: TextStyle(color: HakiColors.textDisabled),
                      ),
                    ),
                  for (int i = 0; i < headers.length; i++)
                    DropdownMenuItem<int?>(
                      value: i,
                      child: Text('Col ${i + 1}: ${headers[i]}'),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    final result = _parseResult!;
    final previewRows = result.rows.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Parsed Preview'),
            Row(
              children: [
                HakiPill(
                  label: '${result.validRows.length} valid',
                  backgroundColor:
                      HakiColors.tertiaryFixed.withValues(alpha: 0.3),
                  textColor: HakiColors.tertiary,
                  icon: Icons.check,
                ),
                if (result.invalidRows.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  HakiPill(
                    label: '${result.invalidRows.length} issues',
                    backgroundColor: HakiColors.roseTint,
                    textColor: HakiColors.rose,
                    icon: Icons.error_outline,
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...previewRows.map((row) => _buildRowCard(row)),
        if (result.rows.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                '+ ${result.rows.length - 5} more rows detected',
                style: HakiTypography.labelSm
                    .copyWith(color: HakiColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRowCard(CsvRow row) {
    final isValid = row.status == ImportRowStatus.valid;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: HakiColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isValid ? HakiColors.cardBorder : HakiColors.roseBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: HakiColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '#${row.lineNumber}',
              style: HakiTypography.labelSm
                  .copyWith(color: HakiColors.textSecondary, fontSize: 10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      row.word.isNotEmpty ? row.word : '(Empty word)',
                      style: HakiTypography.headlineSm.copyWith(
                        fontSize: 15,
                        color: row.word.isEmpty
                            ? HakiColors.rose
                            : HakiColors.textPrimary,
                      ),
                    ),
                    if (row.pronunciation != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        row.pronunciation!,
                        style: HakiTypography.phoneticDisplay.copyWith(
                          fontSize: 12,
                          color: HakiColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  row.meaning.isNotEmpty ? row.meaning : '(Empty meaning)',
                  style: HakiTypography.bodySm.copyWith(
                    color: row.meaning.isEmpty
                        ? HakiColors.rose
                        : HakiColors.textSecondary,
                  ),
                ),
                if (!isValid && row.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '⚠ ${row.errorMessage}',
                      style: HakiTypography.labelSm
                          .copyWith(color: HakiColors.rose, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            isValid ? Icons.check_circle : Icons.warning_amber_rounded,
            size: 18,
            color: isValid ? HakiColors.tertiary : HakiColors.rose,
          ),
        ],
      ),
    );
  }
}

class _SummaryStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryStatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: HakiTypography.bodyMd)),
          Text(
            value,
            style:
                HakiTypography.headlineSm.copyWith(fontSize: 16, color: color),
          ),
        ],
      ),
    );
  }
}
