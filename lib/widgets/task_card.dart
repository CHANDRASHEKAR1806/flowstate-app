import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = task.isCompleted
        ? (isDark ? AppColors.surfaceContainerLowDark : AppColors.surfaceContainerLowLight)
        : (isDark ? AppColors.surfaceContainerLowestDark : AppColors.surfaceContainerLowestLight);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: task.isCompleted
                ? Colors.transparent
                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
          ),
          boxShadow: task.isCompleted
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: task.isCompleted ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: task.isCompleted ? AppColors.primary : AppColors.outlineVariant,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: task.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row & Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _CategoryBadge(category: task.category),
                          if (task.isInProgress && !task.isCompleted) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'In Progress',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                          if (task.priority.toLowerCase() == 'high' && !task.isCompleted) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.flag, size: 10, color: AppColors.error),
                                  SizedBox(width: 3),
                                  Text(
                                    'Urgent',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onErrorContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      // More Actions Dropdown
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onSelected: (val) {
                          if (val == 'toggle') onToggle();
                          if (val == 'edit' && onEdit != null) onEdit!();
                          if (val == 'delete') onDelete();
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(task.isCompleted ? 'Mark Pending' : 'Mark Completed'),
                          ),
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit Task'),
                            ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete Task', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? Colors.grey : Theme.of(context).colorScheme.onSurface,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Meta Row
                  Row(
                    children: [
                      if (task.isCompleted && task.completedAt != null) ...[
                        const Icon(Icons.check_circle, size: 13, color: AppColors.tertiary),
                        const SizedBox(width: 4),
                        Text(
                          'Done at ${task.completedAt}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.tertiary),
                        ),
                      ] else ...[
                        Icon(
                          task.priority.toLowerCase() == 'high' ? Icons.schedule : Icons.calendar_today,
                          size: 13,
                          color: task.priority.toLowerCase() == 'high' ? AppColors.error : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.dueDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: task.priority.toLowerCase() == 'high' ? AppColors.error : AppColors.primary,
                          ),
                        ),
                      ],

                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),

                      Icon(
                        _getMetaIcon(task.subMeta),
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.subMeta,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  IconData _getMetaIcon(String subMeta) {
    final lower = subMeta.toLowerCase();
    if (lower.contains('team') || lower.contains('pod')) return Icons.group;
    if (lower.contains('food') || lower.contains('market')) return Icons.shopping_basket;
    if (lower.contains('deck') || lower.contains('slide')) return Icons.attachment;
    if (lower.contains('trail') || lower.contains('jog')) return Icons.directions_run;
    if (lower.contains('ssl') || lower.contains('cloud')) return Icons.lock;
    return Icons.folder_outlined;
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (category.toLowerCase()) {
      'work' => (AppColors.secondaryFixed, AppColors.onSecondaryFixed, Icons.apartment),
      'personal' => (AppColors.tertiaryFixed, AppColors.onTertiaryFixed, Icons.eco),
      'urgent' => (AppColors.errorContainer, AppColors.onErrorContainer, Icons.flag),
      'tech' => (AppColors.primaryFixed, AppColors.onPrimaryFixed, Icons.terminal),
      _ => (AppColors.secondaryFixed, AppColors.onSecondaryFixed, Icons.folder),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }
}
