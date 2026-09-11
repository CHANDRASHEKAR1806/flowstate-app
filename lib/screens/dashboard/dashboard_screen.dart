import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/daily_momentum_card.dart';
import '../../widgets/task_card.dart';
import '../../widgets/task_detail_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final initials = user?.initials ?? 'U';
    final tasks = taskProvider.filteredTasks;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        currentScreen: 'dashboard',
        onNavigate: widget.onNavigate,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Task Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          // Search Toggle Button
          IconButton(
            icon: Icon(
              taskProvider.isSearchVisible ? Icons.close : Icons.search,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              taskProvider.toggleSearchVisible();
              if (!taskProvider.isSearchVisible) {
                _searchController.clear();
              }
            },
          ),

          // Batch Actions Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onSelected: (val) {
              if (val == 'mark_all') {
                taskProvider.markAllCompleted();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All tasks marked as completed!')),
                );
              } else if (val == 'clear_completed') {
                taskProvider.clearCompletedTasks();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completed tasks cleared.')),
                );
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: 'mark_all',
                child: Text('Mark All Completed'),
              ),
              PopupMenuItem(
                value: 'clear_completed',
                child: Text('Clear Completed Tasks'),
              ),
            ],
          ),

          // Profile Avatar
          GestureDetector(
            onTap: () => widget.onNavigate('settings'),
            child: Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar expansion
          if (taskProvider.isSearchVisible) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by title, category, or notes...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            taskProvider.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceContainerLowestDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                ),
                onChanged: (v) => taskProvider.setSearchQuery(v),
              ),
            ),
          ],

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Item 1: Daily Momentum Card
                DailyMomentumCard(stats: taskProvider.momentumStats),

                const SizedBox(height: 14),

                // Item 2: Filter Chips
                _FilterChipsRow(
                  allTasks: taskProvider.allTasks,
                  selectedFilter: taskProvider.selectedFilter,
                  onSelectFilter: (f) => taskProvider.setFilter(f),
                ),

                const SizedBox(height: 14),

                // Main Tasks List
                if (tasks.isEmpty) ...[
                  _EmptyStateView(
                    filter: taskProvider.selectedFilter,
                    onClearFilter: () => taskProvider.setFilter('All'),
                  ),
                ] else ...[
                  ...tasks.map((task) {
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
                  }),
                ],

                const SizedBox(height: 72),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentScreen: 'dashboard',
        onNavigate: widget.onNavigate,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskProvider.clearEditingTask();
          widget.onNavigate('add_task');
        },
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
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

class _FilterChipsRow extends StatelessWidget {
  final List<TaskModel> allTasks;
  final String selectedFilter;
  final Function(String) onSelectFilter;

  const _FilterChipsRow({
    required this.allTasks,
    required this.selectedFilter,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('All', allTasks.length),
      ('Work', allTasks.where((t) => t.category.toLowerCase() == 'work').length),
      ('Personal', allTasks.where((t) => t.category.toLowerCase() == 'personal').length),
      ('Urgent', allTasks.where((t) => t.priority.toLowerCase() == 'high').length),
      ('Tech', allTasks.where((t) => t.category.toLowerCase() == 'tech').length),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter.toLowerCase() == f.$1.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('${f.$1} (${f.$2})'),
              selected: isSelected,
              onSelected: (_) => onSelectFilter(f.$1),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  final String filter;
  final VoidCallback onClearFilter;

  const _EmptyStateView({required this.filter, required this.onClearFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 56, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            filter == 'All' ? 'No tasks yet' : 'No tasks in "$filter"',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add a new task or switch filters to view more items.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (filter != 'All') ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onClearFilter,
              child: const Text('Show All Tasks', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ],
      ),
    );
  }
}
