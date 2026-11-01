import 'dart:math';
import '../../models/enums.dart';
import '../../models/flash_card.dart';

/// Spaced Repetition Scheduler — SM-2 Variant
///
/// A simple, deterministic scheduling algorithm based on SuperMemo SM-2.
///
/// ### Algorithm Overview:
/// - Each card has an ease factor (EF) starting at 2.5
/// - Intervals grow based on rating and EF
/// - **Again**: Reset to learning, interval = step minutes
/// - **Hard**: Interval * 1.2, EF decreases
/// - **Good**: Interval * EF, EF stays or increases slightly
/// - **Easy**: Interval * EF * 1.3, EF increases
///
/// ### Interval Schedule:
/// - First review: 1 minute (learning step 1)
/// - Second review: 10 minutes (learning step 2)
/// - Graduation: 1 day
/// - Subsequent: interval * EF, growing as configured
///
/// ### Configurable Parameters:
/// - [learningStepMinutes]: Steps for learning phase [1, 10]
/// - [graduatingIntervalDays]: Days for first real interval [1]
/// - [easyIntervalDays]: Days when rated easy on first encounter [4]
/// - [maxIntervalDays]: Upper bound on intervals [365]
/// - [minEaseFactor]: Floor for ease factor [1.3]
class SpacedRepetitionScheduler {
  /// Learning steps in minutes (before graduation to review)
  final List<int> learningStepMinutes;

  /// Interval after graduating from learning phase
  final int graduatingIntervalDays;

  /// Interval when rated Easy during learning
  final int easyIntervalDays;

  /// Maximum possible interval
  final int maxIntervalDays;

  /// Minimum ease factor (floor)
  final double minEaseFactor;

  const SpacedRepetitionScheduler({
    this.learningStepMinutes = const [1, 10],
    this.graduatingIntervalDays = 1,
    this.easyIntervalDays = 4,
    this.maxIntervalDays = 365,
    this.minEaseFactor = 1.3,
  });

  /// Calculate the next review state after a rating.
  ///
  /// Returns a [ScheduleResult] with the new status, interval,
  /// due date, and ease factor.
  ScheduleResult schedule(FlashCard card, ReviewRating rating) {
    switch (card.reviewStatus) {
      case ReviewStatus.newCard:
      case ReviewStatus.learning:
        return _scheduleLearning(card, rating);
      case ReviewStatus.review:
      case ReviewStatus.mastered:
        return _scheduleReview(card, rating);
    }
  }

  /// Get preview intervals for all ratings (for UI display)
  Map<ReviewRating, String> getIntervalPreview(FlashCard card) {
    final previews = <ReviewRating, String>{};
    for (final rating in ReviewRating.values) {
      final result = schedule(card, rating);
      previews[rating] = _formatInterval(result.intervalDays);
    }
    return previews;
  }

  ScheduleResult _scheduleLearning(FlashCard card, ReviewRating rating) {
    final now = DateTime.now();

    switch (rating) {
      case ReviewRating.again:
        // Reset to first learning step
        final stepMinutes = learningStepMinutes.first;
        return ScheduleResult(
          status: ReviewStatus.learning,
          intervalDays: 0,
          dueDate: now.add(Duration(minutes: stepMinutes)),
          easeFactor: max(card.easeFactor - 0.2, minEaseFactor),
        );

      case ReviewRating.hard:
        // Stay in learning, advance to next step or repeat
        final currentStep = _getCurrentLearningStep(card);
        final stepMinutes = learningStepMinutes[currentStep];
        final adjustedMinutes = (stepMinutes * 1.5).round();
        return ScheduleResult(
          status: ReviewStatus.learning,
          intervalDays: 0,
          dueDate: now.add(Duration(minutes: adjustedMinutes)),
          easeFactor: max(card.easeFactor - 0.15, minEaseFactor),
        );

      case ReviewRating.good:
        // Graduate to review with graduating interval
        return ScheduleResult(
          status: ReviewStatus.review,
          intervalDays: graduatingIntervalDays,
          dueDate: now.add(Duration(days: graduatingIntervalDays)),
          easeFactor: card.easeFactor,
        );

      case ReviewRating.easy:
        // Graduate immediately with easy interval
        return ScheduleResult(
          status: ReviewStatus.review,
          intervalDays: easyIntervalDays,
          dueDate: now.add(Duration(days: easyIntervalDays)),
          easeFactor: card.easeFactor + 0.15,
        );
    }
  }

  ScheduleResult _scheduleReview(FlashCard card, ReviewRating rating) {
    final now = DateTime.now();
    final currentInterval = max(card.intervalDays, 1);
    final ef = card.easeFactor;

    switch (rating) {
      case ReviewRating.again:
        // Lapse — send back to learning
        return ScheduleResult(
          status: ReviewStatus.learning,
          intervalDays: 0,
          dueDate: now.add(Duration(minutes: learningStepMinutes.first)),
          easeFactor: max(ef - 0.2, minEaseFactor),
        );

      case ReviewRating.hard:
        // Interval grows slowly
        final newInterval = min(
          (currentInterval * 1.2).round(),
          maxIntervalDays,
        );
        return ScheduleResult(
          status: _statusForInterval(newInterval),
          intervalDays: newInterval,
          dueDate: now.add(Duration(days: newInterval)),
          easeFactor: max(ef - 0.15, minEaseFactor),
        );

      case ReviewRating.good:
        // Normal growth
        final newInterval = min(
          (currentInterval * ef).round(),
          maxIntervalDays,
        );
        return ScheduleResult(
          status: _statusForInterval(newInterval),
          intervalDays: newInterval,
          dueDate: now.add(Duration(days: newInterval)),
          easeFactor: max(ef + 0.0, minEaseFactor),
        );

      case ReviewRating.easy:
        // Accelerated growth
        final newInterval = min(
          (currentInterval * ef * 1.3).round(),
          maxIntervalDays,
        );
        return ScheduleResult(
          status: _statusForInterval(newInterval),
          intervalDays: newInterval,
          dueDate: now.add(Duration(days: newInterval)),
          easeFactor: ef + 0.15,
        );
    }
  }

  int _getCurrentLearningStep(FlashCard card) {
    // Estimate which learning step the card is on based on review count
    if (card.reviewCount == 0) return 0;
    return min(card.reviewCount, learningStepMinutes.length - 1);
  }

  ReviewStatus _statusForInterval(int days) {
    if (days >= 21) return ReviewStatus.mastered;
    return ReviewStatus.review;
  }

  String _formatInterval(int days) {
    if (days == 0) return '< 1 day';
    if (days == 1) return '1 day';
    if (days < 30) return '$days days';
    if (days < 365) {
      final months = (days / 30).round();
      return '$months mo';
    }
    final years = (days / 365).round();
    return '$years yr';
  }
}

/// Result of scheduling a card review.
class ScheduleResult {
  final ReviewStatus status;
  final int intervalDays;
  final DateTime dueDate;
  final double easeFactor;

  const ScheduleResult({
    required this.status,
    required this.intervalDays,
    required this.dueDate,
    required this.easeFactor,
  });

  @override
  String toString() =>
      'ScheduleResult(status: $status, interval: $intervalDays days, '
      'due: $dueDate, ef: $easeFactor)';
}
