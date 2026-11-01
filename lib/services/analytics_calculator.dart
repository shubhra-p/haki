import '../../models/review_event.dart';

/// Analytics calculator — computes metrics from review events and sessions.
///
/// All metrics are derived from persisted data. Projected/estimated values
/// are clearly labeled.
class AnalyticsCalculator {
  const AnalyticsCalculator();

  /// Calculate current streak (consecutive days with study activity)
  int calculateCurrentStreak(List<DateTime> studyDays) {
    if (studyDays.isEmpty) return 0;

    final sorted = List<DateTime>.from(studyDays)
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if user studied today or yesterday
    final lastDay = sorted.first;
    final diff = todayDate.difference(lastDay).inDays;
    if (diff > 1) return 0;

    int streak = 1;
    for (var i = 1; i < sorted.length; i++) {
      final dayDiff = sorted[i - 1].difference(sorted[i]).inDays;
      if (dayDiff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Calculate longest streak
  int calculateLongestStreak(List<DateTime> studyDays) {
    if (studyDays.isEmpty) return 0;

    final sorted = List<DateTime>.from(studyDays)..sort();

    int longest = 1;
    int current = 1;

    for (var i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return longest;
  }

  /// Calculate retention rate from review events
  /// Returns value between 0.0 and 1.0
  double calculateRetentionRate(List<ReviewEvent> events) {
    if (events.isEmpty) return 0.0;

    final correct = events.where((e) => e.isCorrect).length;
    return correct / events.length;
  }

  /// Calculate review accuracy for a time period
  double calculateAccuracy(List<ReviewEvent> events) {
    return calculateRetentionRate(events);
  }

  /// Format study time from seconds
  String formatStudyTime(int totalSeconds) {
    if (totalSeconds < 60) return '${totalSeconds}s';
    if (totalSeconds < 3600) {
      final minutes = totalSeconds ~/ 60;
      return '${minutes}m';
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  /// Calculate review distribution by rating
  Map<String, int> calculateRatingDistribution(List<ReviewEvent> events) {
    final dist = <String, int>{
      'again': 0,
      'hard': 0,
      'good': 0,
      'easy': 0,
    };

    for (final event in events) {
      dist[event.rating.name] = (dist[event.rating.name] ?? 0) + 1;
    }

    return dist;
  }

  /// Calculate daily review counts for the last N days
  Map<DateTime, int> calculateDailyReviews(
    List<ReviewEvent> events,
    int days,
  ) {
    final now = DateTime.now();
    final result = <DateTime, int>{};

    for (var i = 0; i < days; i++) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      result[date] = 0;
    }

    for (final event in events) {
      final date = DateTime(
        event.reviewedAt.year,
        event.reviewedAt.month,
        event.reviewedAt.day,
      );
      if (result.containsKey(date)) {
        result[date] = result[date]! + 1;
      }
    }

    return result;
  }

  /// Get weekly study data for the momentum calendar
  List<DayActivity> getWeeklyActivity(
    List<ReviewEvent> events,
    List<StudySession> sessions,
    int days,
  ) {
    final now = DateTime.now();
    final result = <DayActivity>[];

    for (var i = days - 1; i >= 0; i--) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));

      final dayEvents = events.where((e) {
        final d = DateTime(
          e.reviewedAt.year,
          e.reviewedAt.month,
          e.reviewedAt.day,
        );
        return d == date;
      }).toList();

      final daySessions = sessions.where((s) {
        final d = DateTime(
          s.startedAt.year,
          s.startedAt.month,
          s.startedAt.day,
        );
        return d == date;
      }).toList();

      int studyMinutes = 0;
      for (final session in daySessions) {
        studyMinutes += session.duration.inMinutes;
      }

      result.add(
        DayActivity(
          date: date,
          reviewCount: dayEvents.length,
          studyMinutes: studyMinutes,
          hasActivity: dayEvents.isNotEmpty,
        ),
      );
    }

    return result;
  }
}

/// Activity data for a single day
class DayActivity {
  final DateTime date;
  final int reviewCount;
  final int studyMinutes;
  final bool hasActivity;

  const DayActivity({
    required this.date,
    required this.reviewCount,
    required this.studyMinutes,
    required this.hasActivity,
  });

  String get formattedMinutes {
    if (studyMinutes < 60) return '${studyMinutes}m';
    final hours = studyMinutes ~/ 60;
    final mins = studyMinutes % 60;
    return '${hours}h${mins > 0 ? ' ${mins}m' : ''}';
  }
}
