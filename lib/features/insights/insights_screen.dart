import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/elevation.dart';
import '../../core/providers/providers.dart';
import '../../models/models.dart';
import '../../shared/widgets.dart';

/// Mastery & Insights Screen — genuine retention analytics, momentum streak,
/// forgetting curve visualization, and memory health engine.
/// Traces all displayed metrics back to persisted database records.
/// Provides an encouraging empty state when no review activity has occurred.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalReviewsAsync = ref.watch(totalReviewCountProvider);
    final totalStudyTimeAsync = ref.watch(totalStudyTimeProvider);
    final totalMasteredAsync = ref.watch(totalMasteredProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final retentionRateAsync = ref.watch(retentionRateProvider);
    final studyDaysAsync = ref.watch(studyDaysProvider);
    final needsAttentionAsync = ref.watch(needsAttentionCardsProvider);
    final padding = HakiSpacing.screenPadding(context);

    final totalReviews = totalReviewsAsync.valueOrNull ?? 0;
    final totalStudySeconds = totalStudyTimeAsync.valueOrNull ?? 0;
    final totalMastered = totalMasteredAsync.valueOrNull ?? 0;
    final currentStreak = currentStreakAsync.valueOrNull ?? 0;
    final retentionRate = (retentionRateAsync.valueOrNull ?? 0.0) * 100;
    final studyDays = studyDaysAsync.valueOrNull ?? [];
    final needsAttentionCards = needsAttentionAsync.valueOrNull ?? [];

    final hasActivity = totalReviews > 0;

    return Scaffold(
      backgroundColor: HakiColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding.copyWith(top: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: HakiColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'MEMORY HEALTH ENGINE',
                                style: HakiTypography.labelSm.copyWith(
                                  color: HakiColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mastery & Insights',
                          style: HakiTypography.headlineLgMobile.copyWith(
                            fontWeight: FontWeight.w800,
                            color: HakiColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HakiColors.primary.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: HakiColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (!hasActivity) ...[
                // Empty state for fresh installation
                _buildEmptyActivityCard(context),
              ] else ...[
                // 14 Day Momentum Card
                _buildMomentumCard(currentStreak, studyDays),

                const SizedBox(height: 20),

                // 4 Metric Grid Cards
                _buildMetricGrid(
                  totalReviews: totalReviews,
                  retentionRate: retentionRate,
                  masteredWords: totalMastered,
                  totalStudySeconds: totalStudySeconds,
                ),

                const SizedBox(height: 24),

                // Forgetting Curve Visualization
                _buildForgettingCurveCard(),

                const SizedBox(height: 28),

                // Needs Attention Section
                _buildNeedsAttentionSection(context, needsAttentionCards),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyActivityCard(BuildContext context) {
    return HakiCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: HakiColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_outlined,
              size: 44,
              color: HakiColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Memory Engine Idle',
            style: HakiTypography.headlineSm.copyWith(
              fontWeight: FontWeight.bold,
              color: HakiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your retention rate, 14-day momentum streak, and forgetting curve projections will activate as soon as you review your first flashcard.',
            style: HakiTypography.bodySm.copyWith(
              color: HakiColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go('/study'),
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: const Text('Start First Study Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HakiColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: HakiRadius.fullAll),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentumCard(int streakDays, List<DateTime> studyDays) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Map the current week's 7 days
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final studyDaySet = {
      for (final d in studyDays) DateTime(d.year, d.month, d.day),
    };

    return HakiCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: HakiColors.secondary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '14 Day Momentum',
                        style: HakiTypography.headlineSm.copyWith(
                          fontSize: 17,
                          color: HakiColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HakiColors.roseTint,
                  borderRadius: HakiRadius.fullAll,
                ),
                child: Text(
                  streakDays > 0 ? '$streakDays Day Streak' : 'Start Today',
                  style: HakiTypography.labelSm.copyWith(
                    color: HakiColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));
              final isToday = date.isAtSameMomentAs(today);
              final isFuture = date.isAfter(today);
              final studied = studyDaySet.contains(date);

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 6 ? 4 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isToday
                        ? HakiColors.primary
                        : HakiColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    border: isToday
                        ? Border.all(color: HakiColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Column(
                  children: [
                    Text(
                      dayNames[index],
                      style: HakiTypography.labelSm.copyWith(
                        color:
                            isToday ? Colors.white : HakiColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isToday)
                      Icon(
                        studied
                            ? Icons.local_fire_department
                            : Icons.circle_outlined,
                        size: 18,
                        color: HakiColors.secondary,
                      )
                    else if (isFuture)
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: HakiColors.textDisabled,
                      )
                    else if (studied)
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: HakiColors.roseTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: HakiColors.secondary,
                        ),
                      )
                    else
                      const Icon(
                        Icons.remove,
                        size: 16,
                        color: HakiColors.textDisabled,
                      ),
                    const SizedBox(height: 6),
                    Text(
                      isToday
                          ? 'Today'
                          : (isFuture ? 'Goal' : (studied ? 'Done' : '—')),
                      style: HakiTypography.labelSm.copyWith(
                        fontSize: 9,
                        color: isToday
                            ? Colors.white
                            : (isFuture
                                ? HakiColors.textDisabled
                                : HakiColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        ],
      ),
    );
  }

  Widget _buildMetricGrid({
    required int totalReviews,
    required double retentionRate,
    required int masteredWords,
    required int totalStudySeconds,
  }) {
    final hours = totalStudySeconds ~/ 3600;
    final minutes = (totalStudySeconds % 3600) ~/ 60;
    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.content_copy_outlined,
                badgeText: 'Measured',
                badgeBg: HakiColors.emeraldTint,
                badgeColor: HakiColors.tertiary,
                value: totalReviews.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    ),
                label: 'Total Reviewed',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.lightbulb_outline,
                badgeText: totalReviews > 10 ? 'Active' : 'Initial',
                badgeBg: HakiColors.emeraldTint,
                badgeColor: HakiColors.tertiary,
                value: '${retentionRate.toStringAsFixed(1)}%',
                label: 'Retention Rate',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.verified_outlined,
                badgeText: 'Interval ≥ 21d',
                badgeBg: HakiColors.emeraldTint,
                badgeColor: HakiColors.tertiary,
                value: '$masteredWords',
                label: 'Mastered Words',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.schedule_outlined,
                badgeText: 'Total',
                badgeBg: HakiColors.roseTint,
                badgeColor: HakiColors.secondary,
                value: timeStr,
                label: 'Total Study Time',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForgettingCurveCard() {
    return HakiCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgetting Curve',
                      style: HakiTypography.headlineSm.copyWith(
                        fontSize: 18,
                        color: HakiColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Projected stability over review intervals',
                      style: HakiTypography.bodySm.copyWith(
                        color: HakiColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HakiColors.surfaceContainerLow,
                  borderRadius: HakiRadius.fullAll,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.show_chart,
                      size: 14,
                      color: HakiColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SRS v2 (Projected)',
                      style: HakiTypography.labelSm.copyWith(
                        color: HakiColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Custom Painted Forgetting Curve Chart
          SizedBox(
            height: 140,
            width: double.infinity,
            child: CustomPaint(
              painter: _ForgettingCurvePainter(),
            ),
          ),

          const SizedBox(height: 16),

          // 4 Interval Status Columns
          const Row(
            children: [
              Expanded(
                child: _IntervalPill(
                  dayLabel: 'Day 1',
                  count: '1m',
                  status: 'LEARNING 1',
                  dotColor: Color(0xFFB45309),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _IntervalPill(
                  dayLabel: 'Day 3',
                  count: '10m',
                  status: 'LEARNING 2',
                  dotColor: HakiColors.secondary,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _IntervalPill(
                  dayLabel: '1 Week',
                  count: '1d+',
                  status: 'GRADUATED',
                  dotColor: Color(0xFF6366F1),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _IntervalPill(
                  dayLabel: '1 Month',
                  count: '21d+',
                  status: 'MASTERED',
                  dotColor: HakiColors.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeedsAttentionSection(
    BuildContext context,
    List<FlashCard> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: HakiColors.rose,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Needs Attention',
                      style: HakiTypography.headlineSm.copyWith(
                        fontSize: 17,
                        color: HakiColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cards.isNotEmpty
                    ? HakiColors.roseTint
                    : HakiColors.emeraldTint,
                borderRadius: HakiRadius.fullAll,
              ),
              child: Text(
                cards.isNotEmpty
                    ? '${cards.length} cards'
                    : 'All cards healthy',
                style: HakiTypography.labelSm.copyWith(
                  color:
                      cards.isNotEmpty ? HakiColors.rose : HakiColors.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (cards.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HakiColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: HakiColors.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: HakiColors.tertiary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No critical lapses. All reviewed cards are progressing normally along your memory curve.',
                    style: HakiTypography.bodySm
                        .copyWith(color: HakiColors.textSecondary),
                  ),
                ),
              ],
            ),
          )
        else
          ...cards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AttentionCardTile(
                word: card.word,
                phonetic: card.pronunciation ?? '',
                meaning: card.meaning,
                lastRating:
                    'Ease factor: ${card.easeFactor.toStringAsFixed(2)} • ${card.incorrectCount} lapses',
                onPractice: () => context.push('/study/${card.deckId}'),
              ),
            ),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String badgeText;
  final Color badgeBg;
  final Color badgeColor;
  final String value;
  final String label;

  const _MetricCard({
    required this.icon,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HakiColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: HakiElevation.level1,
        border: Border.all(color: HakiColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: HakiColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: HakiColors.primary),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: HakiRadius.fullAll,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      badgeText,
                      style: HakiTypography.labelSm.copyWith(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: HakiTypography.headlineLgMobile.copyWith(
                fontWeight: FontWeight.w800,
                color: HakiColors.textPrimary,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: HakiTypography.bodySm.copyWith(
              color: HakiColors.textSecondary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _IntervalPill extends StatelessWidget {
  final String dayLabel;
  final String count;
  final String status;
  final Color dotColor;

  const _IntervalPill({
    required this.dayLabel,
    required this.count,
    required this.status,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: HakiColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayLabel,
                  style: HakiTypography.labelSm.copyWith(
                    color: HakiColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(Icons.circle, size: 6, color: dotColor),
              ],
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count,
              style: HakiTypography.headlineSm.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: HakiColors.textPrimary,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              status,
              style: HakiTypography.labelSm.copyWith(
                fontSize: 9,
                color: HakiColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionCardTile extends StatelessWidget {
  final String word;
  final String phonetic;
  final String meaning;
  final String lastRating;
  final VoidCallback onPractice;

  const _AttentionCardTile({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.lastRating,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HakiColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HakiColors.cardBorder),
        boxShadow: HakiElevation.level1,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HakiColors.roseTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flash_on, color: HakiColors.rose, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        word,
                        style: HakiTypography.headlineSm.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (phonetic.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          phonetic,
                          style: HakiTypography.phoneticDisplay.copyWith(
                            fontSize: 11,
                            color: HakiColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  meaning,
                  style: HakiTypography.bodySm.copyWith(
                    color: HakiColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  lastRating,
                  style: HakiTypography.labelSm.copyWith(
                    color: HakiColors.rose,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onPractice,
            style: OutlinedButton.styleFrom(
              foregroundColor: HakiColors.primary,
              side: const BorderSide(color: HakiColors.cardBorder),
              shape: RoundedRectangleBorder(borderRadius: HakiRadius.fullAll),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: const Text('Practice', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the Forgetting Curve and Spaced Repetition reinforcement peaks.
class _ForgettingCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw dashed decay curve (unreviewed memory loss)
    final dashedPaint = Paint()
      ..color = HakiColors.outlineVariant.withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dashPath = Path();
    dashPath.moveTo(0, h * 0.25);
    for (double x = 0; x < w; x += 8) {
      final y = h * (0.25 + 0.65 * (x / w) * (x / w));
      if ((x ~/ 8) % 2 == 0) {
        dashPath.lineTo(x, y);
      } else {
        dashPath.moveTo(x, y);
      }
    }
    canvas.drawPath(dashPath, dashedPaint);

    // 2. Draw Spaced Repetition Reinforcement Peaks & Gradient Area
    final fillPath = Path();
    fillPath.moveTo(0, h);
    fillPath.lineTo(0, h * 0.4);

    // Peak 1: Day 1 Review
    fillPath.quadraticBezierTo(w * 0.08, h * 0.45, w * 0.18, h * 0.22);
    // Decay & Peak 2: Day 3 Review
    fillPath.quadraticBezierTo(w * 0.28, h * 0.35, w * 0.45, h * 0.20);
    // Decay & Peak 3: 1 Week Review
    fillPath.quadraticBezierTo(w * 0.58, h * 0.32, w * 0.75, h * 0.18);
    // Decay & Peak 4: 1 Month Review (Mastered level)
    fillPath.quadraticBezierTo(w * 0.88, h * 0.24, w, h * 0.15);

    fillPath.lineTo(w, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HakiColors.tertiary.withValues(alpha: 0.25),
          HakiColors.primaryContainer.withValues(alpha: 0.04),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 3. Draw curve stroke
    final strokePath = Path();
    strokePath.moveTo(0, h * 0.4);
    strokePath.quadraticBezierTo(w * 0.08, h * 0.45, w * 0.18, h * 0.22);
    strokePath.quadraticBezierTo(w * 0.28, h * 0.35, w * 0.45, h * 0.20);
    strokePath.quadraticBezierTo(w * 0.58, h * 0.32, w * 0.75, h * 0.18);
    strokePath.quadraticBezierTo(w * 0.88, h * 0.24, w, h * 0.15);

    final strokePaint = Paint()
      ..shader = const LinearGradient(
        colors: [HakiColors.secondary, HakiColors.primary, HakiColors.tertiary],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(strokePath, strokePaint);

    // 4. Draw milestone dots at peaks
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final dotPoints = [
      Offset(w * 0.18, h * 0.22),
      Offset(w * 0.45, h * 0.20),
      Offset(w * 0.75, h * 0.18),
      Offset(w, h * 0.15),
    ];

    for (int i = 0; i < dotPoints.length; i++) {
      dotPaint.color =
          i == dotPoints.length - 1 ? HakiColors.tertiary : HakiColors.primary;
      canvas.drawCircle(dotPoints[i], 5, dotPaint);
      dotPaint.color = Colors.white;
      canvas.drawCircle(dotPoints[i], 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
