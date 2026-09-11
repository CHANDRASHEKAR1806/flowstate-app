class DailyProductivityDay {
  final String dayOfWeek;
  final String dayOfMonth;
  final String dateKey;
  final int completedCount;
  final int totalCount;
  final bool isToday;
  final bool isCompleted;

  DailyProductivityDay({
    required this.dayOfWeek,
    required this.dayOfMonth,
    required this.dateKey,
    this.completedCount = 0,
    this.totalCount = 0,
    this.isToday = false,
    this.isCompleted = false,
  });
}

class StreakInfo {
  final int currentStreak;
  final int longestStreak;
  final int totalCompletedTasks;
  final int weeklyProductivityScore;
  final List<DailyProductivityDay> weeklyDays;

  StreakInfo({
    this.currentStreak = 5,
    this.longestStreak = 12,
    this.totalCompletedTasks = 0,
    this.weeklyProductivityScore = 88,
    this.weeklyDays = const [],
  });
}

class MomentumStats {
  final int totalCount;
  final int completedCount;
  final double progressRatio;
  final int percentage;
  final String motivationalMessage;
  final StreakInfo streakInfo;

  MomentumStats({
    this.totalCount = 0,
    this.completedCount = 0,
    this.progressRatio = 0.0,
    this.percentage = 0,
    this.motivationalMessage = "Keep it going, you're halfway there!",
    StreakInfo? streakInfo,
  }) : streakInfo = streakInfo ?? StreakInfo();
}
