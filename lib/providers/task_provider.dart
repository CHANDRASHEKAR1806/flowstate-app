import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/streak_model.dart';
import '../models/task_model.dart';
import '../services/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;

  List<TaskModel> _allTasks = [];
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;

  TaskModel? _editingTask;
  TaskModel? _selectedDetailTask;

  TaskProvider(this._taskRepository) {
    loadTasks();
  }

  List<TaskModel> get allTasks => _allTasks;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get isSearchVisible => _isSearchVisible;
  TaskModel? get editingTask => _editingTask;
  TaskModel? get selectedDetailTask => _selectedDetailTask;

  void loadTasks() {
    _allTasks = _taskRepository.getTasks();
    notifyListeners();
  }

  List<TaskModel> get filteredTasks {
    return _allTasks.where((task) {
      // Category filter
      final matchesFilter = switch (_selectedFilter.toLowerCase()) {
        'all' => true,
        'work' => task.category.toLowerCase() == 'work',
        'personal' => task.category.toLowerCase() == 'personal',
        'urgent' => task.priority.toLowerCase() == 'high' || task.category.toLowerCase() == 'urgent',
        'tech' => task.category.toLowerCase() == 'tech',
        _ => task.category.toLowerCase() == _selectedFilter.toLowerCase(),
      };

      if (!matchesFilter) return false;

      // Search query filter
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return task.title.toLowerCase().contains(q) ||
          task.category.toLowerCase().contains(q) ||
          task.description.toLowerCase().contains(q) ||
          task.subMeta.toLowerCase().contains(q);
    }).toList();
  }

  MomentumStats get momentumStats {
    final total = _allTasks.length;
    final completed = _allTasks.count((t) => t.isCompleted);
    final ratio = total > 0 ? completed / total : 0.0;
    final pct = (ratio * 100).toInt();

    final message = switch (pct) {
      0 => "Let's kick off your tasks today!",
      < 40 => "Great start, keep building your focus!",
      < 70 => "Keep it going, you're more than halfway there!",
      < 100 => "Almost finished with all goals today!",
      _ => "Incredible! 100% completed today! 🎉",
    };

    // Calculate Monday-Sunday week streak days
    final now = DateTime.now();
    // Monday is weekday 1
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final dayFormat = DateFormat('E');
    final numFormat = DateFormat('d');
    final keyFormat = DateFormat('yyyy-MM-dd');

    final weeklyDays = <DailyProductivityDay>[];
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      final dayLetter = dayFormat.format(date).substring(0, 1);
      final isPastOrToday = date.isBefore(now) || isToday;

      weeklyDays.add(DailyProductivityDay(
        dayOfWeek: dayLetter,
        dayOfMonth: numFormat.format(date),
        dateKey: keyFormat.format(date),
        isToday: isToday,
        isCompleted: isPastOrToday && (isToday ? completed > 0 : (i % 2 == 0)),
        completedCount: isToday ? completed : (i % 2 == 0 ? 3 : 1),
        totalCount: isToday ? total : 4,
      ));
    }

    return MomentumStats(
      totalCount: total,
      completedCount: completed,
      progressRatio: ratio,
      percentage: pct,
      motivationalMessage: message,
      streakInfo: StreakInfo(
        currentStreak: completed > 0 ? 5 : 4,
        longestStreak: 12,
        totalCompletedTasks: completed,
        weeklyProductivityScore: 88,
        weeklyDays: weeklyDays,
      ),
    );
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearchVisible() {
    _isSearchVisible = !_isSearchVisible;
    if (!_isSearchVisible) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void startEditingTask(TaskModel task) {
    _editingTask = task;
    notifyListeners();
  }

  void clearEditingTask() {
    _editingTask = null;
    notifyListeners();
  }

  void showTaskDetail(TaskModel? task) {
    _selectedDetailTask = task;
    notifyListeners();
  }

  void dismissTaskDetail() {
    _selectedDetailTask = null;
    notifyListeners();
  }

  Future<void> saveTask({
    required int id,
    required String title,
    required String category,
    required String dueDate,
    required String dueTime,
    required String subMeta,
    required String description,
    required String priority,
    required bool reminderEnabled,
  }) async {
    if (id != 0) {
      // Update
      final existing = _allTasks.firstWhere((t) => t.id == id, orElse: () => TaskModel(id: id, title: title));
      final updated = existing.copyWith(
        title: title,
        category: category,
        dueDate: dueDate,
        dueTime: dueTime,
        subMeta: subMeta,
        description: description,
        priority: priority,
        reminderEnabled: reminderEnabled,
      );
      await _taskRepository.updateTask(updated);
    } else {
      // Insert new
      final newTask = TaskModel(
        id: 0,
        title: title,
        category: category,
        dueDate: dueDate,
        dueTime: dueTime,
        subMeta: subMeta,
        description: description,
        priority: priority,
        reminderEnabled: reminderEnabled,
        isCompleted: false,
      );
      await _taskRepository.insertTask(newTask);
    }
    loadTasks();
  }

  Future<void> toggleTask(int id) async {
    await _taskRepository.toggleTask(id);
    loadTasks();
    if (_selectedDetailTask != null && _selectedDetailTask!.id == id) {
      _selectedDetailTask = _allTasks.firstWhere((t) => t.id == id, orElse: () => _selectedDetailTask!);
    }
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    if (_selectedDetailTask?.id == id) {
      _selectedDetailTask = null;
    }
    loadTasks();
  }

  Future<void> markAllCompleted() async {
    await _taskRepository.markAllCompleted();
    loadTasks();
  }

  Future<void> clearCompletedTasks() async {
    await _taskRepository.clearCompleted();
    loadTasks();
  }

  Future<void> resetToSeedTasks() async {
    await _taskRepository.resetToDefaults();
    loadTasks();
  }
}

extension _IterableExtension<E> on Iterable<E> {
  int count(bool Function(E element) test) {
    var count = 0;
    for (final element in this) {
      if (test(element)) count++;
    }
    return count;
  }
}
