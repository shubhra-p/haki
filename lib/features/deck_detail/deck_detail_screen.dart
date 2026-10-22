import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/providers/providers.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/csv_parser.dart';
import '../../shared/widgets.dart';
import '../../models/models.dart';

/// Deck Detail - shows all cards in a deck with management actions.
class DeckDetailScreen extends ConsumerStatefulWidget {
  final String deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  @override
  ConsumerState<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends ConsumerState<DeckDetailScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final deckAsync = ref.watch(deckByIdProvider(widget.deckId));
    final cardsAsync = ref.watch(cardsForDeckProvider(widget.deckId));
    final padding = HakiSpacing.screenPadding(context);

    return Scaffold(
      backgroundColor: HakiColors.surface,
      appBar: AppBar(
        title: deckAsync.when(
          data: (deck) => Text(
            deck?.name ?? 'Deck',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Import CSV',
            onPressed: () => context.push('/import/${widget.deckId}'),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export CSV',
            onPressed: () => _exportDeck(),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(
                value: 'togglePlacement',
                child: Text(
                  (deckAsync.valueOrNull?.showReadingOnFront ?? true)
                      ? 'Move Readings to Back'
                      : 'Move Readings to Front',
                ),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete Deck')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Deck stats header
          deckAsync.when(
            data: (deck) {
              if (deck == null) return const SizedBox.shrink();
              return _DeckStatsHeader(deck: deck);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Reading Placement Setting Card
          deckAsync.when(
            data: (deck) {
              if (deck == null) return const SizedBox.shrink();
              return _ReadingPlacementCard(
                showReadingOnFront: deck.showReadingOnFront,
                onChanged: (val) async {
                  await ref.read(deckDaoProvider).updateDeck(
                        id: widget.deckId,
                        showReadingOnFront: val,
                      );
                  ref.invalidate(deckByIdProvider(widget.deckId));
                  ref.invalidate(allDecksProvider);
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Search
          Padding(
            padding: padding.copyWith(top: 8, bottom: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: HakiTypography.bodyMd,
              decoration: InputDecoration(
                hintText: 'Search cards...',
                prefixIcon:
                    Icon(Icons.search, color: HakiColors.textDisabled),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: HakiRadius.fullAll,
                  borderSide: BorderSide(color: HakiColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: HakiRadius.fullAll,
                  borderSide: BorderSide(color: HakiColors.cardBorder),
                ),
              ),
            ),
          ),

          // Card list
          Expanded(
            child: cardsAsync.when(
              data: (cards) {
                final filtered = _searchQuery.isEmpty
                    ? cards
                    : cards
                        .where(
                          (c) =>
                              c.word
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              c.meaning
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()),
                        )
                        .toList();

                if (filtered.isEmpty && cards.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.style_outlined,
                    title: 'No cards yet',
                    subtitle: 'Add cards manually or import a CSV file',
                    actionLabel: 'Add Card',
                    onAction: () => context.push('/decks/${widget.deckId}/add'),
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No cards match your search'),
                  );
                }

                return ListView.builder(
                  padding: padding.copyWith(bottom: 100),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _CardListTile(
                      card: filtered[index],
                      onTap: () => context.push(
                        '/decks/${widget.deckId}/edit/${filtered[index].id}',
                      ),
                      onDelete: () => _confirmDeleteCard(filtered[index]),
                      onDuplicate: () => _duplicateCard(filtered[index]),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/decks/${widget.deckId}/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'rename':
        _showRenameDialog();
        break;
      case 'togglePlacement':
        _toggleReadingPlacement();
        break;
      case 'delete':
        _confirmDeleteDeck();
        break;
    }
  }

  Future<void> _toggleReadingPlacement() async {
    final deck = ref.read(deckByIdProvider(widget.deckId)).valueOrNull;
    if (deck == null) return;
    final next = !deck.showReadingOnFront;
    await ref.read(deckDaoProvider).updateDeck(
          id: widget.deckId,
          showReadingOnFront: next,
        );
    ref.invalidate(deckByIdProvider(widget.deckId));
    ref.invalidate(allDecksProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            next
                ? 'Readings placed on Front of card'
                : 'Readings placed on Back (revealed on flip)',
          ),
        ),
      );
    }
  }

  Future<void> _showRenameDialog() async {
    final deck = ref.read(deckByIdProvider(widget.deckId)).valueOrNull;
    if (deck == null) return;

    final controller = TextEditingController(text: deck.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Deck'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Deck Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    if (result != null && result.trim().isNotEmpty && mounted) {
      await ref.read(deckDaoProvider).updateDeck(
            id: widget.deckId,
            name: result.trim(),
          );
      ref.invalidate(deckByIdProvider(widget.deckId));
      ref.invalidate(allDecksProvider);
    }
  }

  Future<void> _confirmDeleteDeck() async {
    final deck = ref.read(deckByIdProvider(widget.deckId)).valueOrNull;
    if (deck == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Deck'),
        content: Text(
          'Permanently delete "${deck.name}" and all ${deck.totalCards} cards?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: HakiColors.rose),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(deckDaoProvider).deleteDeck(widget.deckId);
      ref.invalidate(allDecksProvider);
      if (mounted) context.pop();
    }
  }

  Future<void> _confirmDeleteCard(FlashCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Card'),
        content: Text('Delete "${card.word}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: HakiColors.rose),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(cardDaoProvider).deleteCard(card.id);
      ref.invalidate(cardsForDeckProvider(widget.deckId));
      ref.invalidate(deckByIdProvider(widget.deckId));
      ref.invalidate(allDecksProvider);
    }
  }

  Future<void> _duplicateCard(FlashCard card) async {
    await ref.read(cardDaoProvider).duplicateCard(card.id);
    ref.invalidate(cardsForDeckProvider(widget.deckId));
    ref.invalidate(deckByIdProvider(widget.deckId));
    ref.invalidate(allDecksProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Duplicated "${card.word}"')),
      );
    }
  }

  void _exportDeck() async {
    final deck = ref.read(deckByIdProvider(widget.deckId)).valueOrNull;
    final cards = ref.read(cardsForDeckProvider(widget.deckId)).valueOrNull;
    if (cards == null || cards.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cards to export in this deck.')),
        );
      }
      return;
    }

    final csvRows = cards
        .map(
          (c) => {
            'word': c.word,
            'meaning': c.meaning,
            'transliteration': c.transliteration ?? '',
            'pronunciation': c.pronunciation ?? '',
          },
        )
        .toList();

    final csvContent = CsvParser.toCsv(csvRows);
    final deckName = deck?.name ?? 'deck';

    try {
      await Share.share(
        csvContent,
        subject: '$deckName Export.csv',
      );
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: csvContent));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${cards.length} cards exported and copied to clipboard as CSV!',
            ),
            backgroundColor: HakiColors.tertiary,
          ),
        );
      }
    }
  }
}

class _DeckStatsHeader extends StatelessWidget {
  final Deck deck;
  const _DeckStatsHeader({required this.deck});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HakiSpacing.screenPadding(context).copyWith(top: 8),
      child: HakiCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircularProgressBadge(
              progress: deck.progressPercent,
              size: 56,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HakiProgressBar(progress: deck.progressPercent),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatChip(
                        label: 'New',
                        count: deck.newCards,
                        color: HakiColors.primary,
                      ),
                      _StatChip(
                        label: 'Learning',
                        count: deck.learningCards,
                        color: HakiColors.secondary,
                      ),
                      _StatChip(
                        label: 'Mastered',
                        count: deck.masteredCards,
                        color: HakiColors.emerald,
                      ),
                      _StatChip(
                        label: 'Due',
                        count: deck.dueCards,
                        color: HakiColors.rose,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingPlacementCard extends StatelessWidget {
  final bool showReadingOnFront;
  final ValueChanged<bool> onChanged;

  const _ReadingPlacementCard({
    required this.showReadingOnFront,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HakiSpacing.screenPadding(context).copyWith(top: 8, bottom: 4),
      child: HakiCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: showReadingOnFront
                    ? HakiColors.primary.withValues(alpha: 0.1)
                    : HakiColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                showReadingOnFront
                    ? Icons.subtitles_outlined
                    : Icons.subtitles_off_outlined,
                color: showReadingOnFront
                    ? HakiColors.primary
                    : HakiColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Readings',
                    style: HakiTypography.labelLg.copyWith(
                      color: HakiColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    showReadingOnFront
                        ? 'Shown on Front'
                        : 'Shown on Back (flip to reveal)',
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
                  icon: Icon(Icons.crop_portrait, size: 15),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Back'),
                  icon: Icon(Icons.flip, size: 15),
                ),
              ],
              selected: {showReadingOnFront},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  onChanged(set.first);
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
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: HakiTypography.labelLg.copyWith(color: color),
        ),
        Text(
          label,
          style: HakiTypography.labelSm.copyWith(
            color: HakiColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CardListTile extends StatelessWidget {
  final FlashCard card;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _CardListTile({
    required this.card,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: HakiCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _statusColor(card.reviewStatus),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Word and meaning
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.word,
                    style: HakiTypography.headlineSm.copyWith(
                      color: HakiColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.meaning,
                    style: HakiTypography.bodySm.copyWith(
                      color: HakiColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (card.transliteration != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      card.transliteration!,
                      style: HakiTypography.phoneticDisplay.copyWith(
                        color: HakiColors.textDisabled,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Actions
            PopupMenuButton<String>(
              onSelected: (action) {
                switch (action) {
                  case 'edit':
                    onTap();
                    break;
                  case 'duplicate':
                    onDuplicate();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Text('Duplicate'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              icon: Icon(
                Icons.more_horiz,
                color: HakiColors.textDisabled,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(ReviewStatus status) {
    return switch (status) {
      ReviewStatus.newCard => HakiColors.primary,
      ReviewStatus.learning => HakiColors.secondary,
      ReviewStatus.review => HakiColors.surfaceTint,
      ReviewStatus.mastered => HakiColors.emerald,
    };
  }
}
