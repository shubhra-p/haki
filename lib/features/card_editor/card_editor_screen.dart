import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/providers/providers.dart';
import '../../shared/widgets.dart';

/// Card Editor - add or edit a single flashcard.

/// Supports:
/// - Creating new cards (word + meaning + optional fields)
/// - Editing existing cards
/// - "Save & Add Another" workflow
class CardEditorScreen extends ConsumerStatefulWidget {
  final String deckId;
  final String? cardId;

  const CardEditorScreen({
    super.key,
    required this.deckId,
    this.cardId,
  });

  @override
  ConsumerState<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends ConsumerState<CardEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  late final TextEditingController _meaningController;
  late final TextEditingController _transliterationController;
  late final TextEditingController _pronunciationController;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _meaningController = TextEditingController();
    _transliterationController = TextEditingController();
    _pronunciationController = TextEditingController();
    _isEditing = widget.cardId != null;
    if (_isEditing) {
      _loadCard();
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _transliterationController.dispose();
    _pronunciationController.dispose();
    super.dispose();
  }

  Future<void> _loadCard() async {
    final card = await ref.read(cardDaoProvider).getCardById(widget.cardId!);
    if (card != null && mounted) {
      setState(() {
        _wordController.text = card.word;
        _meaningController.text = card.meaning;
        _transliterationController.text = card.transliteration ?? '';
        _pronunciationController.text = card.pronunciation ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HakiColors.surface,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Card' : 'Add Card'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              HakiSpacing.screenPadding(context).copyWith(top: 24, bottom: 100),
          children: [
            // Word field
            Text(
              'Target Word *',
              style: HakiTypography.labelLg.copyWith(
                color: HakiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _wordController,
              style: HakiTypography.headlineSm,
              autofocus: !_isEditing,
              decoration: const InputDecoration(
                hintText: 'e.g., Sobremesa',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Word is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Meaning field
            Text(
              'Meaning *',
              style: HakiTypography.labelLg.copyWith(
                color: HakiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _meaningController,
              style: HakiTypography.bodyMd,
              decoration: const InputDecoration(
                hintText: 'e.g., after-meal conversation',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Meaning is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Transliteration field
            Text(
              'Transliteration',
              style: HakiTypography.labelLg.copyWith(
                color: HakiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'How the word is written in your familiar script',
              style: HakiTypography.bodySm.copyWith(
                color: HakiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _transliterationController,
              style: HakiTypography.phoneticDisplay,
              decoration: const InputDecoration(
                hintText: 'e.g., so-bre-me-sa',
              ),
            ),
            const SizedBox(height: 20),

            // Pronunciation field
            Text(
              'Pronunciation',
              style: HakiTypography.labelLg.copyWith(
                color: HakiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'IPA or phonetic guide',
              style: HakiTypography.bodySm.copyWith(
                color: HakiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pronunciationController,
              style: HakiTypography.phoneticDisplay,
              decoration: const InputDecoration(
                hintText: 'e.g., [so.βɾe.ˈme.sa]',
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            HakiPillButton(
              label: _isEditing ? 'Save Changes' : 'Save Card',
              icon: Icons.check,
              onPressed: _isLoading ? null : _save,
              isLoading: _isLoading,
            ),

            if (!_isEditing) ...[
              const SizedBox(height: 12),
              HakiPillButton(
                label: 'Save & Add Another',
                icon: Icons.add,
                onPressed: _isLoading ? null : _saveAndAddAnother,
                backgroundColor: HakiColors.surfaceContainerHigh,
                foregroundColor: HakiColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await ref.read(cardDaoProvider).updateCardContent(
              id: widget.cardId!,
              word: _wordController.text.trim(),
              meaning: _meaningController.text.trim(),
              transliteration: _transliterationController.text.trim().isNotEmpty
                  ? _transliterationController.text.trim()
                  : null,
              pronunciation: _pronunciationController.text.trim().isNotEmpty
                  ? _pronunciationController.text.trim()
                  : null,
              clearTransliteration:
                  _transliterationController.text.trim().isEmpty,
              clearPronunciation: _pronunciationController.text.trim().isEmpty,
            );
      } else {
        await ref.read(cardDaoProvider).createCard(
              deckId: widget.deckId,
              word: _wordController.text.trim(),
              meaning: _meaningController.text.trim(),
              transliteration: _transliterationController.text.trim().isNotEmpty
                  ? _transliterationController.text.trim()
                  : null,
              pronunciation: _pronunciationController.text.trim().isNotEmpty
                  ? _pronunciationController.text.trim()
                  : null,
            );
      }

      _invalidateProviders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Card updated' : 'Card added',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAndAddAnother() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(cardDaoProvider).createCard(
            deckId: widget.deckId,
            word: _wordController.text.trim(),
            meaning: _meaningController.text.trim(),
            transliteration: _transliterationController.text.trim().isNotEmpty
                ? _transliterationController.text.trim()
                : null,
            pronunciation: _pronunciationController.text.trim().isNotEmpty
                ? _pronunciationController.text.trim()
                : null,
          );

      _invalidateProviders();

      // Clear fields for next card
      _wordController.clear();
      _meaningController.clear();
      _transliterationController.clear();
      _pronunciationController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card added! Add another →')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _invalidateProviders() {
    ref.invalidate(cardsForDeckProvider(widget.deckId));
    ref.invalidate(deckByIdProvider(widget.deckId));
    ref.invalidate(allDecksProvider);
  }
}
