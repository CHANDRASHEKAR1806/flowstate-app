import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';

class ListsScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const ListsScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.allTasks;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      (
        name: 'Work',
        description: 'Sprints, client decks & design tokens',
        icon: Icons.apartment,
        color: AppColors.secondary,
        bgColor: AppColors.secondaryFixed,
        tasks: allTasks.where((t) => t.category.toLowerCase() == 'work').toList(),
      ),
      (
        name: 'Personal',
        description: 'Errands, wellness & budget routines',
        icon: Icons.eco,
        color: AppColors.tertiary,
        bgColor: AppColors.tertiaryFixed,
        tasks: allTasks.where((t) => t.category.toLowerCase() == 'personal').toList(),
      ),
      (
        name: 'Urgent',
        description: 'High priority items due immediately',
        icon: Icons.flag,
        color: AppColors.error,
        bgColor: AppColors.errorContainer,
        tasks: allTasks.where((t) => t.priority.toLowerCase() == 'high' || t.category.toLowerCase() == 'urgent').toList(),
      ),
      (
        name: 'Tech',
        description: 'Infrastructure, SSL certificates & DevOps',
        icon: Icons.terminal,
        color: AppColors.primary,
        bgColor: AppColors.primaryFixed,
        tasks: allTasks.where((t) => t.category.toLowerCase() == 'tech').toList(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => onNavigate('dashboard'),
        ),
        title: const Text('Lists & Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(
            'CATEGORIES OVERVIEW',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          ...categories.map((cat) {
            final total = cat.tasks.length;
            final completed = cat.tasks.where((t) => t.isCompleted).length;
            final ratio = total > 0 ? completed / total : 0.0;
            final pct = (ratio * 100).toInt();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? AppColors.surfaceContainerLowestDark : AppColors.surfaceContainerLowestLight,
              child: InkWell(
                onTap: () {
                  taskProvider.setFilter(cat.name);
                  onNavigate('dashboard');
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: cat.bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(cat.icon, color: cat.color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  cat.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: ratio.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
                          color: cat.color,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completed of $total tasks finished',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            '$pct%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cat.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentScreen: 'lists',
        onNavigate: onNavigate,
      ),
    );
  }
}
