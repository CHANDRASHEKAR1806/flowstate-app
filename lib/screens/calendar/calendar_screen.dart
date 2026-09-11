import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/task_card.dart';
import '../../widgets/task_detail_sheet.dart';

class CalendarScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const CalendarScreen({super.key, required this.onNavigate});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _weekOffset = 0;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default selected index is today's day of week (Monday = 0, Sunday = 6)
    _selectedDayIndex = DateTime.now().weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.allTasks;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    // Calculate Monday of the selected week
    final baseMonday = now.subtract(Duration(days: now.weekday - 1));
    final currentMonday = baseMonday.add(Duration(days: _weekOffset * 7));

    final monthShortFormat = DateFormat('MMMM');
    final dayNameFormat = DateFormat('EEE');
    final dayNumFormat = DateFormat('d');

    final currentMonthLabel = monthShortFormat.format(currentMonday);

    // Build 7 week days
    final weekDays = List.generate(7, (i) {
      final d = currentMonday.add(Duration(days: i));
      final isToday = d.year == now.year && d.month == now.month && d.day == now.day;
      return (
        dayName: dayNameFormat.format(d),
        dayNum: dayNumFormat.format(d),
        isToday: isToday,
        date: d,
      );
    });

    final selectedDay = weekDays[_selectedDayIndex.clamp(0, 6)];
    final timelineHeader = '${currentMonthLabel.toUpperCase()} ${selectedDay.dayNum} TIMELINE';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onNavigate('dashboard'),
        ),
        title: const Text('Calendar Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _weekOffset--),
              ),
              Text(
                currentMonthLabel,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _weekOffset++),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Strip Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? AppColors.surfaceContainerLowestDark : AppColors.surfaceContainerLowestLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (idx) {
                    final day = weekDays[idx];
                    final isSelected = idx == _selectedDayIndex;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              day.dayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              day.dayNum,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.white
                                    : (day.isToday ? AppColors.tertiary : Colors.transparent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Timeline Header
            Text(
              timelineHeader,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 10),

            // Scheduled Tasks List
            Expanded(
              child: allTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_note, size: 48, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 8),
                          const Text('No scheduled tasks for this date', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: allTasks.length,
                      itemBuilder: (ctx, idx) {
                        final task = allTasks[idx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TaskCard(
                            task: task,
                            onToggle: () => taskProvider.toggleTask(task.id),
                            onDelete: () => taskProvider.deleteTask(task.id),
                            onEdit: () {
                              taskProvider.startEditingTask(task);
                              widget.onNavigate('add_task');
                            },
                            onTap: () => _showTaskDetailSheet(context, task),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentScreen: 'calendar',
        onNavigate: widget.onNavigate,
      ),
    );
  }

  void _showTaskDetailSheet(BuildContext context, TaskModel task) {
    final taskProvider = context.read<TaskProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TaskDetailSheet(
        task: task,
        onDismiss: () => Navigator.of(ctx).pop(),
        onToggle: () {
          taskProvider.toggleTask(task.id);
          Navigator.of(ctx).pop();
        },
        onEdit: () {
          Navigator.of(ctx).pop();
          taskProvider.startEditingTask(task);
          widget.onNavigate('add_task');
        },
        onDelete: () {
          Navigator.of(ctx).pop();
          taskProvider.deleteTask(task.id);
        },
      ),
    );
  }
}
