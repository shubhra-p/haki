import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/providers/providers.dart';
import '../../models/models.dart';
import '../../shared/widgets.dart';

/// Deck Library — main home screen showing all decks.

/// Features:
/// - Review banner with total due cards
/// - Search bar
/// - Deck cards with stats
/// - Quick actions
/// - Empty state for new users
class DeckLibraryScreen extends ConsumerStatefulWidget {
  const DeckLibraryScreen({super.key});

  @override
  ConsumerState<DeckLibraryScreen> createState() => _DeckLibraryScreenState();
}

class _DeckLibraryScreenState extends ConsumerState<DeckLibraryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final decksAsync = ref.watch(filteredDecksProvider);
    final dueCardsAsync = ref.watch(totalDueCardsProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final padding = HakiSpacing.screenPadding(context);

    return Scaffold(
      backgroundColor: HakiColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: padding.copyWith(top: 16, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expand your vocabulary',
                            style: HakiTypography.headlineSm.copyWith(
                              color: HakiColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Instant flashcard learning',
                            style: HakiTypography.bodySm.copyWith(
                              color: HakiColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ImportButton(
                      onTap: () => context.go('/create'),
                    ),
                    const SizedBox(width: 8),
                    _AddButton(
                      onTap: () => _showCreateDeckDialog(context),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Review Banner ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: padding.copyWith(top: 8, bottom: 12),
                child: dueCardsAsync.when(
                  data: (dueCount) {
                    if (dueCount == 0) return const SizedBox.shrink();
                    return _ReviewBanner(
                      dueCount: dueCount,
                      streak: currentStreakAsync.valueOrNull ?? 0,
                      onStart: () => _startDailyReview(),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            // ─── Search Bar ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: padding.copyWith(bottom: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(deckSearchQueryProvider.notifier).state = value;
                  },
                  style: HakiTypography.bodyMd,
                  decoration: InputDecoration(
                    hintText: 'Search decks, tags, or vocabulary...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: HakiColors.textDisabled,
                    ),
                    filled: true,
                    fillColor: HakiColors.cardBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: HakiRadius.fullAll,
                      borderSide: BorderSide(
                        color: HakiColors.cardBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: HakiRadius.fullAll,
                      borderSide: BorderSide(
                        color: HakiColors.cardBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: HakiRadius.fullAll,
                      borderSide: BorderSide(
                        color: HakiColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Deck List ───────────────────────────────────────
            decksAsync.when(
              data: (decks) {
                if (decks.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.library_books_outlined,
                      title: 'No decks yet',
                      subtitle:
                          'Create your first deck or import a CSV to get started',
                      actionLabel: 'Create Deck',
                      onAction: () => _showCreateDeckDialog(context),
                    ),
                  );
                }

                return SliverPadding(
                  padding: padding.copyWith(bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DeckCard(
                          deck: decks[index],
                          onTap: () => context.push(
                            '/decks/${decks[index].id}',
                          ),
                          onStudy: () => context.push(
                            '/study/${decks[index].id}',
                          ),
                          onReviseSeen: () {
                            if (decks[index].seenCards > 0) {
                              context.push(
                                '/study/${decks[index].id}?mode=revise_seen',
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No seen cards yet. Study some cards first to revise them!',
                                  ),
                                ),
                              );
                            }
                          },
                          onDelete: () => _confirmDeleteDeck(decks[index]),
                        ),
                      ),
                      childCount: decks.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Text('Error loading decks: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateDeckDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CreateDeckSheet(
        onCreate: (name, sourceLang, targetLang, showReadingOnFront) async {
          Navigator.pop(ctx);
          if (mounted) {
            await ref.read(deckDaoProvider).createDeck(
                  name: name,
                  sourceLanguage: sourceLang,
                  targetLanguage: targetLang,
                  showReadingOnFront: showReadingOnFront,
                );
            ref.invalidate(allDecksProvider);
          }
        },
      ),
    );
  }

  Future<void> _confirmDeleteDeck(Deck deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Deck'),
        content: Text(
          'Are you sure you want to delete "${deck.name}"?\n'
          'This will permanently remove ${deck.totalCards} cards and all review history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: HakiColors.rose,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(deckDaoProvider).deleteDeck(deck.id);
      ref.invalidate(allDecksProvider);
    }
  }

  void _startDailyReview() async {
    // Find the deck with the most due cards
    final decks = ref.read(allDecksProvider).valueOrNull ?? [];
    if (decks.isEmpty) return;

    final deckWithMostDue = decks.reduce(
      (a, b) => a.dueCards > b.dueCards ? a : b,
    );

    if (mounted) {
      context.push('/study/${deckWithMostDue.id}');
    }
  }
}

// ─── Sub-widgets ───────────────────────────────────────────────────────

class _ImportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ImportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: HakiColors.cardBorder),
          borderRadius: HakiRadius.fullAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.file_upload_outlined, size: 16),
            const SizedBox(width: 4),
            Text('Import CSV', style: HakiTypography.labelMd),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: HakiColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ReviewBanner extends StatelessWidget {
  final int dueCount;
  final int streak;
  final VoidCallback onStart;

  const _ReviewBanner({
    required this.dueCount,
    required this.streak,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: HakiColors.reviewBannerGradient,
        borderRadius: HakiRadius.xlAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HakiColors.secondary,
                  borderRadius: HakiRadius.fullAll,
                ),
                child: Text(
                  '⚡ SPACED REPETITION',
                  style: HakiTypography.labelSm.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              if (streak > 0)
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: HakiColors.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak Days Hot',
                      style: HakiTypography.labelMd.copyWith(
                        color: HakiColors.secondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ready for Review',
            style: HakiTypography.headlineLgMobile.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$dueCount cards are slipping your memory curve.',
            style: HakiTypography.bodySm.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          HakiPillButton(
            label: 'Start Daily Blast',
            icon: Icons.play_arrow,
            onPressed: onStart,
            backgroundColor: HakiColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback onTap;
  final VoidCallback onStudy;
  final VoidCallback? onReviseSeen;
  final VoidCallback onDelete;

  const _DeckCard({
    required this.deck,
    required this.onTap,
    required this.onStudy,
    this.onReviseSeen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return HakiCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: language tags + more menu
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (deck.languagePairLabel != null)
                      HakiPill(
                        label: deck.languagePairLabel!,
                        backgroundColor: HakiColors.isDarkMode
                            ? const Color(0xFF262354)
                            : HakiColors.primary.withValues(alpha: 0.08),
                        textColor: HakiColors.isDarkMode
                            ? const Color(0xFFA5B4FC)
                            : HakiColors.primary,
                      ),
                    if (deck.isCompleted)
                      HakiPill(
                        label: 'Completed',
                        backgroundColor: HakiColors.emeraldTint,
                        textColor: HakiColors.emerald,
                        icon: Icons.check_circle,
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'study':
                      onStudy();
                      break;
                    case 'reviseSeen':
                      onReviseSeen?.call();
                      break;
                    case 'import':
                      context.push('/import/${deck.id}');
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'study',
                    child: Text('Study Now'),
                  ),
                  PopupMenuItem(
                    value: 'reviseSeen',
                    child: Text('Revise Seen (${deck.seenCards})'),
                  ),
                  const PopupMenuItem(
                    value: 'import',
                    child: Text('Import CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert,
                  color: HakiColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Deck name
          Text(
            deck.name,
            style: HakiTypography.headlineSm.copyWith(
              color: HakiColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              CircularProgressBadge(progress: deck.progressPercent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${deck.totalCards} cards',
                      style: HakiTypography.labelLg.copyWith(
                        color: HakiColors.textPrimary,
                      ),
                    ),
                    if (deck.lastStudiedAt != null)
                      Text(
                        'Last studied ${_formatRelativeTime(deck.lastStudiedAt!)}',
                        style: HakiTypography.bodySm.copyWith(
                          color: HakiColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (deck.dueCards > 0) ...[
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color: HakiColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${deck.dueCards} Due',
                  style: HakiTypography.labelMd.copyWith(
                    color: HakiColors.secondary,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                '${deck.masteredCards} Mastered',
                style: HakiTypography.bodySm.copyWith(
                  color: HakiColors.textSecondary,
                ),
              ),
              if (deck.seenCards > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '${deck.seenCards} Seen',
                  style: HakiTypography.bodySm.copyWith(
                    color: HakiColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReviseSeen,
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: Text(
                    'Revise Seen (${deck.seenCards})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: deck.seenCards > 0
                        ? HakiColors.secondary
                        : HakiColors.textDisabled,
                    side: BorderSide(
                      color: deck.seenCards > 0
                          ? HakiColors.secondary.withValues(alpha: 0.5)
                          : HakiColors.cardBorder,
                    ),
                    minimumSize: const Size(0, 40),
                    textStyle: HakiTypography.labelMd,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onStudy,
                  icon: const Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text('Study Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HakiColors.isDarkMode
                        ? const Color(0xFF4F46E5)
                        : HakiColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 40),
                    textStyle:
                        HakiTypography.labelMd.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${diff.inDays ~/ 7} weeks ago';
  }
}

class _CreateDeckSheet extends StatefulWidget {
  final void Function(
    String name,
    String? sourceLang,
    String? targetLang,
    bool showReadingOnFront,
  ) onCreate;

  const _CreateDeckSheet({required this.onCreate});

  @override
  State<_CreateDeckSheet> createState() => _CreateDeckSheetState();
}

class _CreateDeckSheetState extends State<_CreateDeckSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _sourceLangController;
  late final TextEditingController _targetLangController;
  bool _showReadingOnFront = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sourceLangController = TextEditingController();
    _targetLangController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceLangController.dispose();
    _targetLangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: HakiColors.sheetHandle,
                borderRadius: HakiRadius.fullAll,
              ),
            ),
          ),
          Text(
            'Create New Deck',
            style: HakiTypography.headlineMd.copyWith(
              color: HakiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            autofocus: true,
            style: HakiTypography.bodyMd,
            decoration: const InputDecoration(
              labelText: 'Deck Name',
              hintText: 'e.g., Conversational Spanish',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sourceLangController,
                  style: HakiTypography.bodyMd,
                  decoration: const InputDecoration(
                    labelText: 'Source Language',
                    hintText: 'e.g., EN',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _targetLangController,
                  style: HakiTypography.bodyMd,
                  decoration: const InputDecoration(
                    labelText: 'Target Language',
                    hintText: 'e.g., ES',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Reading placement preference
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: HakiColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: HakiColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reading Placement',
                        style: HakiTypography.labelMd.copyWith(
                          color: HakiColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _showReadingOnFront
                            ? 'Pronunciation on Front (standard)'
                            : 'Pronunciation on Back (character recognition)',
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
                      setState(() => _showReadingOnFront = set.first);
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
          const SizedBox(height: 24),
          HakiPillButton(
            label: 'Create Deck',
            icon: Icons.add,
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                final source = _sourceLangController.text.trim();
                final target = _targetLangController.text.trim();
                widget.onCreate(
                  name,
                  source.isNotEmpty ? source.toUpperCase() : null,
                  target.isNotEmpty ? target.toUpperCase() : null,
                  _showReadingOnFront,
                );
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
