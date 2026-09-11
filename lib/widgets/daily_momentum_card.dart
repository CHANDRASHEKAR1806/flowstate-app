import 'package:flutter/material.dart';
import '../models/streak_model.dart';
import '../theme/app_theme.dart';

class DailyMomentumCard extends StatefulWidget {
  final MomentumStats stats;

  const DailyMomentumCard({super.key, required this.stats});

  @override
  State<DailyMomentumCard> createState() => _DailyMomentumCardState();
}

class _DailyMomentumCardState extends State<DailyMomentumCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    final streak = stats.streakInfo;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: isDark ? AppColors.surfaceContainerLowestDark : AppColors.surfaceContainerLowestLight,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon, Title & Streak Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.task_alt,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Momentum',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${stats.completedCount} of ${stats.totalCount} tasks completed today',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Streak Flame Badge
                GestureDetector(
                  onTap: () => _showBreakdownDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: streak.currentStreak > 0
                          ? Colors.orange.withOpacity(0.15)
                          : Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: streak.currentStreak > 0 ? Colors.deepOrange : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          streak.currentStreak > 0 ? '${streak.currentStreak}d streak' : 'Start streak',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: streak.currentStreak > 0 ? Colors.deepOrange : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Row 2: Progress Bar & Percentage
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: stats.progressRatio.clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${stats.percentage}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Row 3: Weekly Activity Bubble Row
            Text(
              'Weekly Activity & Consistency',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceContainerLowDark : AppColors.surfaceContainerLowLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: streak.weeklyDays.map((day) {
                  return Column(
                    children: [
                      Text(
                        day.dayOfWeek,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: day.isToday ? FontWeight.bold : FontWeight.w500,
                          color: day.isToday ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: day.isCompleted && day.isToday
                              ? AppColors.primary
                              : (day.isCompleted
                                  ? AppColors.tertiaryFixed
                                  : (day.isToday
                                      ? AppColors.primaryFixed
                                      : (isDark
                                          ? AppColors.surfaceContainerDark
                                          : AppColors.surfaceContainerLight))),
                          border: day.isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
                        ),
                        alignment: Alignment.center,
                        child: day.isCompleted
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: day.isToday ? Colors.white : AppColors.tertiary,
                              )
                            : Text(
                                day.dayOfMonth,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: day.isToday
                                      ? AppColors.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                                ),
                              ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Row 4: Motivational Message & Expand Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      stats.motivationalMessage,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'Less' : 'Stats',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Expandable Stats
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricItem(label: 'Current Streak', value: '${streak.currentStreak} Days', icon: Icons.local_fire_department, tint: Colors.deepOrange),
                    _MetricItem(label: 'Best Streak', value: '${streak.longestStreak} Days', icon: Icons.stars, tint: AppColors.primary),
                    _MetricItem(label: 'Efficiency', value: '${streak.weeklyProductivityScore}%', icon: Icons.electric_bolt, tint: AppColors.tertiary),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showBreakdownDialog(BuildContext context) {
    final stats = widget.stats;
    final streak = stats.streakInfo;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text('Daily Momentum & Streak'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consistent daily progress builds productivity. Keep completing daily tasks to maintain your streak!',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Current Streak', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('${streak.currentStreak} Days 🔥', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Longest Streak', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('${streak.longestStreak} Days 🏆', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Completed', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('${streak.totalCompletedTasks} Tasks', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got It', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: tint),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
