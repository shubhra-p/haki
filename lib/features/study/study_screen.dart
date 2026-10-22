import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/elevation.dart';
import '../../core/providers/providers.dart';
import '../../models/models.dart';
import '../../shared/widgets.dart';

// STUDY HOME SCREEN

/// Home screen for the Study tab when no specific deck is selected.
class StudyHomeScreen extends ConsumerWidget {
  const StudyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(allDecksProvider);
    final dueCardsAsync = ref.watch(totalDueCardsProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final padding = HakiSpacing.screenPadding(context);

    return Scaffold(
      backgroundColor: HakiColors.surface,
      appBar: AppBar(
        title: Text(
          'Daily Study',
          style:
              HakiTypography.headlineSm.copyWith(color: HakiColors.textPrimary),
        ),
        backgroundColor: HakiColors.surface,
        elevation: 0,
        actions: [
          streakAsync.when(
            data: (streak) => Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: HakiColors.secondary.withValues(alpha: 0.12),
                borderRadius: HakiRadius.fullAll,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: HakiColors.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: HakiTypography.labelMd.copyWith(
                      color: HakiColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return Center(
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: HakiColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        size: 48,
                        color: HakiColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No flashcards yet',
                      style: HakiTypography.headlineMd,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Import a CSV or create your first vocabulary deck to start studying with spaced repetition.',
                      style: HakiTypography.bodyMd
                          .copyWith(color: HakiColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    HakiButton(
                      label: 'Create or Import Deck',
                      icon: Icons.add,
                      onPressed: () => context.go('/create'),
                    ),
                  ],
                ),
              ),
            );
          }

          final dueDecks = decks.where((d) => d.dueCards > 0).toList();
          final totalDue = dueCardsAsync.valueOrNull ?? 0;

          return ListView(
            padding: padding.copyWith(top: 8, bottom: 40),
            children: [
              // Hero Daily Blast Card
              if (totalDue > 0)
                _DailyBlastBanner(
                  dueCount: totalDue,
                  activeDeckCount: dueDecks.length,
                  streak: streakAsync.valueOrNull ?? 0,
                  onStart: () {
                    if (dueDecks.isNotEmpty) {
                      context.push('/study/${dueDecks.first.id}');
                    }
                  },
                )
              else
                _AllCaughtUpBanner(),

              const SizedBox(height: 24),

              Text(
                'Select a Deck to Study',
                style: HakiTypography.headlineSm.copyWith(
                  fontSize: 18,
                  color: HakiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ...decks.map((deck) => _StudyDeckTile(deck: deck)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DailyBlastBanner extends StatelessWidget {
  final int dueCount;
  final int activeDeckCount;
  final int streak;
  final VoidCallback onStart;

  const _DailyBlastBanner({
    required this.dueCount,
    required this.activeDeckCount,
    required this.streak,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: HakiColors.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: HakiElevation.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HakiColors.secondary.withValues(alpha: 0.2),
                  borderRadius: HakiRadius.fullAll,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: HakiColors.secondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SPACED REPETITION',
                      style: HakiTypography.labelSm.copyWith(
                        color: HakiColors.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (streak > 0)
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: HakiColors.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak Days Hot',
                      style: HakiTypography.labelSm.copyWith(
                        color: HakiColors.textInverse,
                        fontWeight: FontWeight.w600,
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
              color: HakiColors.textInverse,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$dueCount cards across $activeDeckCount active decks are slipping your memory curve.',
            style: HakiTypography.bodySm.copyWith(
              color: HakiColors.textInverse.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Start Daily Blast (${math.max(1, (dueCount * 0.4).round())} min)',
                style: HakiTypography.labelLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HakiColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: HakiRadius.fullAll),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllCaughtUpBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HakiColors.tertiaryFixed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HakiColors.tertiary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: HakiColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: HakiColors.tertiary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Caught Up!',
                  style: HakiTypography.headlineSm
                      .copyWith(color: HakiColors.tertiary),
                ),
                Text(
                  'Zero cards are currently due. Select any deck below to quick-flip or review ahead.',
                  style: HakiTypography.bodySm
                      .copyWith(color: HakiColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyDeckTile extends StatelessWidget {
  final Deck deck;

  const _StudyDeckTile({required this.deck});

  @override
  Widget build(BuildContext context) {
    final due = deck.dueCards;
    final total = deck.totalCards;
    final mastered = deck.masteredCards;
    final percent = total > 0 ? ((mastered / total) * 100).round() : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: HakiCard(
        padding: const EdgeInsets.all(16),
        onTap: () => context.push('/study/${deck.id}'),
        child: Row(
          children: [
            // Circular progress or deck badge
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    value: total > 0 ? (mastered / total) : 0,
                    strokeWidth: 4,
                    backgroundColor: HakiColors.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      HakiColors.tertiary,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: HakiTypography.labelSm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: HakiColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      HakiPill(
                        label: deck.sourceLanguage ?? 'General',
                        backgroundColor: HakiColors.surfaceContainerLow,
                        textColor: HakiColors.primary,
                        fontSize: 10,
                      ),
                      if (due > 0)
                        HakiPill(
                          label: '$due Due',
                          backgroundColor:
                              HakiColors.secondary.withValues(alpha: 0.12),
                          textColor: HakiColors.secondary,
                          icon: Icons.schedule,
                          fontSize: 10,
                        )
                      else
                        HakiPill(
                          label: 'Completed',
                          backgroundColor:
                              HakiColors.tertiaryFixed.withValues(alpha: 0.3),
                          textColor: HakiColors.tertiary,
                          icon: Icons.check,
                          fontSize: 10,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    deck.name,
                    style: HakiTypography.headlineSm.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$total cards  •  $mastered mastered',
                    style: HakiTypography.bodySm.copyWith(
                      color: HakiColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/study/${deck.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: due > 0
                    ? HakiColors.primary
                    : HakiColors.surfaceContainerHigh,
                foregroundColor:
                    due > 0 ? HakiColors.textInverse : HakiColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: HakiRadius.fullAll),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                due > 0 ? 'Study' : 'Flip',
                style: HakiTypography.labelSm
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full study experience with 3D card flip, gesture swiping, and SM-2 feedback.
class StudySessionScreen extends ConsumerStatefulWidget {
  final String deckId;

  const StudySessionScreen({super.key, required this.deckId});

  @override
  ConsumerState<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  List<FlashCard> _cards = [];
  int _currentIndex = 0;
  bool _isBackVisible = false;
  bool _isLoading = true;
  bool _isCompleted = false;

  // Drag physics state
  Offset _dragOffset = Offset.zero;
  double _dragAngle = 0.0;

  // Session analytics
  int _xpEarned = 0;
  int _secondsElapsed = 0;
  Timer? _sessionTimer;
  final List<ReviewRating> _sessionRatings = [];
  DateTime _cardStartTime = DateTime.now();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    )..addListener(() {
        if (_flipAnimation.value >= 0.5 && !_isBackVisible) {
          setState(() => _isBackVisible = true);
        } else if (_flipAnimation.value < 0.5 && _isBackVisible) {
          setState(() => _isBackVisible = false);
        }
      });

    _startTimer();
    _loadCards();
  }

  void _startTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_isCompleted) {
        setState(() => _secondsElapsed++);
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final dueCards = await ref.read(cardDaoProvider).getDueCards(widget.deckId);
    List<FlashCard> cardsToStudy = dueCards;

    // If no due cards, load all cards for quick practice
    if (cardsToStudy.isEmpty) {
      cardsToStudy =
          await ref.read(cardDaoProvider).getCardsForDeck(widget.deckId);
    }

    if (mounted) {
      setState(() {
        _cards = cardsToStudy;
        _isLoading = false;
        _currentIndex = 0;
        _cardStartTime = DateTime.now();
      });
    }
  }

  void _flipCard() {
    HapticFeedback.lightImpact();
    if (_flipController.isAnimating) return;
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  Future<void> _submitRating(ReviewRating rating) async {
    if (_isSubmitting || _cards.isEmpty || _currentIndex >= _cards.length) {
      return;
    }
    _isSubmitting = true;

    try {
      final card = _cards[_currentIndex];
      final scheduler = ref.read(schedulerProvider);
      final scheduleResult = scheduler.schedule(card, rating);
      final responseTimeMs =
          DateTime.now().difference(_cardStartTime).inMilliseconds;

      // Persist rating & review event
      await ref.read(cardDaoProvider).updateCardReview(
            id: card.id,
            status: scheduleResult.status,
            dueDate: scheduleResult.dueDate,
            intervalDays: scheduleResult.intervalDays,
            easeFactor: scheduleResult.easeFactor,
            reviewCount: card.reviewCount + 1,
            correctCount:
                card.correctCount + (rating != ReviewRating.again ? 1 : 0),
            incorrectCount:
                card.incorrectCount + (rating == ReviewRating.again ? 1 : 0),
          );

      await ref.read(reviewDaoProvider).createReviewEvent(
            cardId: card.id,
            deckId: card.deckId,
            rating: rating,
            previousIntervalDays: card.intervalDays,
            newIntervalDays: scheduleResult.intervalDays,
            previousEaseFactor: card.easeFactor,
            newEaseFactor: scheduleResult.easeFactor,
            responseTimeMs: responseTimeMs,
          );

      // Provide haptic feedback
      if (rating == ReviewRating.again) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }

      // Update state
      if (mounted) {
        setState(() {
          _sessionRatings.add(rating);
          _xpEarned += rating == ReviewRating.again ? 5 : 15;

          if (_currentIndex + 1 < _cards.length) {
            _currentIndex++;
            _cardStartTime = DateTime.now();
            _isBackVisible = false;
            _flipController.reset();
            _dragOffset = Offset.zero;
            _dragAngle = 0.0;
          } else {
            _isCompleted = true;
          }
        });
      }
    } finally {
      _isSubmitting = false;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _dragAngle = (_dragOffset.dx / 300) * (math.pi / 16);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 120.0;
    if (_dragOffset.dx > threshold) {
      // Swiped right -> Mastered / Good
      _submitRating(ReviewRating.good);
    } else if (_dragOffset.dx < -threshold) {
      // Swiped left -> Retry / Again
      _submitRating(ReviewRating.again);
    } else {
      // Return to center
      setState(() {
        _dragOffset = Offset.zero;
        _dragAngle = 0.0;
      });
    }
  }

  String _formatTimer(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final deckAsync = ref.watch(deckByIdProvider(widget.deckId));
    final showReadingOnFront = deckAsync.valueOrNull?.showReadingOnFront ?? true;
    final streakAsync = ref.watch(currentStreakProvider);
    final streak = streakAsync.valueOrNull ?? 0;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: HakiColors.surface,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isCompleted) {
      return _buildCompletionView(deckAsync.valueOrNull?.name ?? 'Deck');
    }

    if (_cards.isEmpty) {
      return Scaffold(
        backgroundColor: HakiColors.surface,
        appBar: AppBar(title: const Text('Study')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: HakiColors.tertiary,
              ),
              const SizedBox(height: 16),
              Text('No cards to review!', style: HakiTypography.headlineMd),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Decks'),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    // Swiping aura colors
    Color? auraColor;
    if (_dragOffset.dx > 40) {
      auraColor = HakiColors.tertiary
          .withValues(alpha: math.min(1.0, _dragOffset.dx / 200));
    } else if (_dragOffset.dx < -40) {
      auraColor = HakiColors.rose
          .withValues(alpha: math.min(1.0, -_dragOffset.dx / 200));
    }

    return Scaffold(
      backgroundColor: HakiColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header Top Bar ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Deck pill - Expanded + Align + Flexible text ensures long deck names never overflow
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: HakiColors.surfaceContainerLow,
                          borderRadius: HakiRadius.fullAll,
                          border: Border.all(color: HakiColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.style,
                              size: 14,
                              color: HakiColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                deckAsync.valueOrNull?.name ?? 'Deck',
                                style: HakiTypography.labelSm.copyWith(
                                  color: HakiColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Reading placement quick toggle
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: Icon(
                      showReadingOnFront
                          ? Icons.subtitles_outlined
                          : Icons.subtitles_off_outlined,
                      color: showReadingOnFront
                          ? HakiColors.primary
                          : HakiColors.secondary,
                      size: 20,
                    ),
                    tooltip: showReadingOnFront
                        ? 'Readings on Front (tap to hide on front)'
                        : 'Readings on Back (tap to show on front)',
                    onPressed: () async {
                      final next = !showReadingOnFront;
                      await ref.read(deckDaoProvider).updateDeck(
                            id: widget.deckId,
                            showReadingOnFront: next,
                          );
                      ref.invalidate(deckByIdProvider(widget.deckId));
                      ref.invalidate(allDecksProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              next
                                  ? 'Readings placed on Card Front'
                                  : 'Character recognition mode: Readings on Back',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  // Streak pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: HakiColors.secondary.withValues(alpha: 0.12),
                      borderRadius: HakiRadius.fullAll,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: HakiColors.secondary,
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '$streak',
                          style: HakiTypography.labelMd.copyWith(
                            color: HakiColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Exit button
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: const Icon(
                      Icons.close,
                      color: HakiColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            // ─── Progress & Stats Subheader ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.content_copy,
                          size: 16,
                          color: HakiColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Card ${_currentIndex + 1} ',
                            style: HakiTypography.headlineSm.copyWith(
                              fontSize: 16,
                              color: HakiColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '/ ${_cards.length}',
                          style: HakiTypography.bodySm.copyWith(
                            color: HakiColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HakiColors.secondary.withValues(alpha: 0.12),
                          borderRadius: HakiRadius.fullAll,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: HakiColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+$_xpEarned XP',
                              style: HakiTypography.labelSm.copyWith(
                                color: HakiColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HakiColors.surfaceContainerLow,
                          borderRadius: HakiRadius.fullAll,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 12,
                              color: HakiColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimer(_secondsElapsed),
                              style: HakiTypography.labelSm.copyWith(
                                color: HakiColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Animated Gradient Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ClipRRect(
                borderRadius: HakiRadius.fullAll,
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      Container(color: HakiColors.surfaceContainerHigh),
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                HakiColors.primary,
                                HakiColors.secondary,
                                HakiColors.tertiary,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ─── 3D Flashcard Stage ─────────────────────────────
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    onTap: _flipCard,
                    child: Transform(
                      transform: Matrix4.translationValues(
                        _dragOffset.dx,
                        _dragOffset.dy,
                        0.0,
                      )..rotateZ(_dragAngle),
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          final angle = _flipAnimation.value * math.pi;
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // 3D perspective
                              ..rotateY(angle),
                            alignment: Alignment.center,
                            child: _isBackVisible
                                ? Transform(
                                    transform: Matrix4.identity()
                                      ..rotateY(math.pi),
                                    alignment: Alignment.center,
                                    child: _buildCardBack(
                                      currentCard,
                                      auraColor,
                                      showReadingOnBack: !showReadingOnFront,
                                    ),
                                  )
                                : _buildCardFront(
                                    currentCard,
                                    auraColor,
                                    showReading: showReadingOnFront,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ─── Directional Feedback Indicators ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          size: 14,
                          color: HakiColors.rose,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Swipe Left: Retry',
                            style: HakiTypography.labelSm.copyWith(
                              color: HakiColors.rose,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            'Swipe Right: Mastered',
                            style: HakiTypography.labelSm.copyWith(
                              color: HakiColors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: HakiColors.tertiary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─── Bottom 4 Rating Buttons ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _RatingButton(
                      label: 'Again',
                      interval: '1 min',
                      icon: Icons.close,
                      bgColor: HakiColors.roseTint,
                      borderColor: HakiColors.roseBorder,
                      textColor: HakiColors.rose,
                      onTap: () => _submitRating(ReviewRating.again),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _RatingButton(
                      label: 'Hard',
                      interval: '10 min',
                      icon: Icons.priority_high,
                      bgColor: HakiColors.surfaceContainerLow,
                      borderColor: HakiColors.cardBorder,
                      textColor: HakiColors.textPrimary,
                      onTap: () => _submitRating(ReviewRating.hard),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _RatingButton(
                      label: 'Good',
                      interval: '1 day',
                      icon: Icons.check,
                      bgColor: const Color(0xFFEEF2FF),
                      borderColor: const Color(0xFFC7D2FE),
                      textColor: HakiColors.primary,
                      onTap: () => _submitRating(ReviewRating.good),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _RatingButton(
                      label: 'Easy',
                      interval: '4 days',
                      icon: Icons.star,
                      bgColor: HakiColors.emeraldTint,
                      borderColor: HakiColors.emeraldBorder,
                      textColor: HakiColors.tertiary,
                      onTap: () => _submitRating(ReviewRating.easy),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStatusBadge(ReviewStatus status) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case ReviewStatus.newCard:
        bg = HakiColors.primary.withValues(alpha: 0.08);
        fg = HakiColors.primary;
        icon = Icons.fiber_new;
        label = 'NEW CARD';
        break;
      case ReviewStatus.learning:
        bg = HakiColors.secondary.withValues(alpha: 0.1);
        fg = HakiColors.secondary;
        icon = Icons.school_outlined;
        label = 'LEARNING';
        break;
      case ReviewStatus.review:
        bg = HakiColors.tertiaryFixed.withValues(alpha: 0.3);
        fg = HakiColors.tertiary;
        icon = Icons.schedule;
        label = 'REVIEW';
        break;
      case ReviewStatus.mastered:
        bg = HakiColors.emeraldTint;
        fg = HakiColors.emerald;
        icon = Icons.check_circle_outline;
        label = 'MASTERED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: HakiRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: HakiTypography.labelSm.copyWith(
              color: fg,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(
    FlashCard card,
    Color? auraColor, {
    bool showReading = true,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 380, maxHeight: 460),
      decoration: BoxDecoration(
        color: HakiColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: auraColor ?? HakiColors.cardBorder,
          width: auraColor != null ? 2.5 : 1.0,
        ),
        boxShadow: auraColor != null
            ? [
                BoxShadow(
                  color: auraColor.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
                ...HakiElevation.level2,
              ]
            : HakiElevation.level2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Card status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReviewStatusBadge(card.reviewStatus),
            ],
          ),

          // Center Word & Pronunciation
          Column(
            children: [
              // Speaker button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Playing pronunciation for "${card.word}"'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: HakiColors.primary.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: HakiColors.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Word
              Text(
                card.word,
                style: HakiTypography.headlineXl.copyWith(
                  color: HakiColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: card.word.length > 14 ? 30 : 36,
                ),
                textAlign: TextAlign.center,
              ),
              if (showReading) ...[
                const SizedBox(height: 10),
                _buildReadingDetails(card),
              ] else if ((card.pronunciation != null &&
                      card.pronunciation!.isNotEmpty) ||
                  (card.transliteration != null &&
                      card.transliteration!.isNotEmpty)) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: HakiColors.surfaceContainerLow,
                    borderRadius: HakiRadius.fullAll,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility_off_outlined,
                        size: 13,
                        color: HakiColors.textDisabled,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Readings on back',
                        style: HakiTypography.labelSm.copyWith(
                          color: HakiColors.textDisabled,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Flip hint
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.touch_app_outlined,
                    size: 16,
                    color: HakiColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Tap card to flip & reveal ↺',
                      style: HakiTypography.labelMd.copyWith(
                        color: HakiColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'or swipe left / right to score',
                style: HakiTypography.bodySm.copyWith(
                  color: HakiColors.textDisabled,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(
    FlashCard card,
    Color? auraColor, {
    bool showReadingOnBack = false,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 380, maxHeight: 460),
      decoration: BoxDecoration(
        color: HakiColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: auraColor ?? HakiColors.tertiaryFixed,
          width: auraColor != null ? 2.5 : 1.5,
        ),
        boxShadow: auraColor != null
            ? [
                BoxShadow(
                  color: auraColor.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
                ...HakiElevation.level2,
              ]
            : HakiElevation.level2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: HakiColors.tertiaryFixed.withValues(alpha: 0.3),
                  borderRadius: HakiRadius.fullAll,
                ),
                child: Text(
                  'TRANSLATION & MEANING',
                  style: HakiTypography.labelSm.copyWith(
                    color: HakiColors.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              // Word / Character
              Text(
                card.word,
                style: HakiTypography.headlineSm.copyWith(
                  color: HakiColors.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Meaning directly below character/word
              Text(
                card.meaning,
                style: HakiTypography.headlineMd.copyWith(
                  color: HakiColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              // Pronunciation & Reading below meaning
              _buildReadingDetails(card),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flip_to_front,
                size: 16,
                color: HakiColors.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Tap card to flip back ↻',
                  style: HakiTypography.labelMd.copyWith(
                    color: HakiColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingDetails(FlashCard card) {
    final hasPronunciation =
        card.pronunciation != null && card.pronunciation!.isNotEmpty;
    final hasTransliteration =
        card.transliteration != null && card.transliteration!.isNotEmpty;

    if (!hasPronunciation && !hasTransliteration) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Phonetic IPA badge
        if (hasPronunciation)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: HakiColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              card.pronunciation!,
              style: HakiTypography.phoneticDisplay.copyWith(
                color: HakiColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
        if (hasTransliteration) ...[
          if (hasPronunciation) const SizedBox(height: 6),
          Text(
            card.transliteration!,
            style: HakiTypography.bodySm.copyWith(
              color: HakiColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompletionView(String deckName) {
    final total = _sessionRatings.length;
    final correct =
        _sessionRatings.where((r) => r != ReviewRating.again).length;
    final accuracy = total > 0 ? ((correct / total) * 100).round() : 100;

    return Scaffold(
      backgroundColor: HakiColors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: HakiColors.tertiaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 50,
                    color: HakiColors.tertiary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Daily Blast Finished!',
                  style: HakiTypography.headlineLgMobile.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great session! You reinforced $total cards from $deckName.',
                  style: HakiTypography.bodyMd
                      .copyWith(color: HakiColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Metrics Row
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HakiColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: HakiElevation.level1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Retention',
                        value: '$accuracy%',
                        icon: Icons.psychology,
                        color: HakiColors.tertiary,
                      ),
                      _StatColumn(
                        label: 'Time Spent',
                        value: _formatTimer(_secondsElapsed),
                        icon: Icons.timer,
                        color: HakiColors.primary,
                      ),
                      _StatColumn(
                        label: 'XP Gained',
                        value: '+$_xpEarned',
                        icon: Icons.star,
                        color: HakiColors.secondary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
                HakiButton(
                  label: 'Back to Deck Library',
                  icon: Icons.arrow_back,
                  onPressed: () => context.go('/decks'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isCompleted = false;
                      _currentIndex = 0;
                      _isBackVisible = false;
                      _sessionRatings.clear();
                      _loadCards();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HakiColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: HakiRadius.fullAll,
                    ),
                  ),
                  child: const Text('Review Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final String interval;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.interval,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              interval,
              style: HakiTypography.labelSm.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: textColor, size: 16),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: HakiTypography.labelSm.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: HakiTypography.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: HakiColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: HakiTypography.labelSm.copyWith(
            color: HakiColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
