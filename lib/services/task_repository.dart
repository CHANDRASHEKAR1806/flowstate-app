import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _keyTasks = 'app_tasks_json';
  final SharedPreferences _prefs;

  TaskRepository(this._prefs) {
    _initDefaultTasks();
  }

  void _initDefaultTasks() {
    if (!_prefs.containsKey(_keyTasks)) {
      final initialTasks = [
        TaskModel(
          id: 1,
          title: 'Q3 Design System Sync',
          category: 'Work',
          dueDate: 'Today, 2:00 PM',
          dueTime: '2:00 PM',
          subMeta: 'Design Team',
          description: 'Sync with team on token mapping and corner radii for the final export.',
          priority: 'Medium',
          isCompleted: false,
          reminderEnabled: true,
          isInProgress: false,
        ),
        TaskModel(
          id: 2,
          title: 'Grocery Run: Organic coffee & oat milk',
          category: 'Personal',
          dueDate: 'Today, 6:30 PM',
          dueTime: '6:30 PM',
          subMeta: 'Whole Foods',
          description: 'Pick up organic single-origin coffee beans and unsweetened oat milk.',
          priority: 'Low',
          isCompleted: false,
          reminderEnabled: false,
          isInProgress: true,
        ),
        TaskModel(
          id: 3,
          title: 'Client presentation deck review',
          category: 'Work',
          dueDate: 'Tomorrow, 10:00 AM',
          dueTime: '10:00 AM',
          subMeta: '14 slides',
          description: 'Final executive dry-run on enterprise onboarding pitch deck.',
          priority: 'High',
          isCompleted: false,
          reminderEnabled: true,
          isInProgress: false,
        ),
        TaskModel(
          id: 4,
          title: 'Morning 5km jog & stretch',
          category: 'Personal',
          dueDate: 'Today, 7:45 AM',
          dueTime: '7:45 AM',
          subMeta: 'Lake Trail',
          description: 'Morning cardio route along north trail and 15 min cool down.',
          priority: 'Low',
          isCompleted: true,
          completedAt: '7:45 AM',
          reminderEnabled: false,
          isInProgress: false,
        ),
        TaskModel(
          id: 5,
          title: 'Renew domain SSL certificates',
          category: 'Tech',
          dueDate: 'Nov 14',
          dueTime: '12:00 PM',
          subMeta: 'Cloudflare',
          description: 'Verify wild-card certificates and DNS propagation.',
          priority: 'Medium',
          isCompleted: false,
          reminderEnabled: true,
          isInProgress: false,
        ),
        TaskModel(
          id: 6,
          title: 'Finalize wireframes for onboarding',
          category: 'Work',
          dueDate: 'Today, 4:00 PM',
          dueTime: '4:00 PM',
          subMeta: 'Product Specs',
          description: 'Sync with lead designer on token mapping and corner radii for export.',
          priority: 'High',
          isCompleted: true,
          completedAt: '11:20 AM',
          reminderEnabled: true,
          isInProgress: false,
        ),
        TaskModel(
          id: 7,
          title: 'Sprint 14 retrospective summary',
          category: 'Work',
          dueDate: 'Today, 11:30 AM',
          dueTime: '11:30 AM',
          subMeta: 'Agile Core',
          description: 'Collate velocity metrics and blockers from engineering pod.',
          priority: 'Medium',
          isCompleted: true,
          completedAt: '11:30 AM',
          reminderEnabled: false,
          isInProgress: false,
        ),
        TaskModel(
          id: 8,
          title: 'Tax & corporate expense audit',
          category: 'Personal',
          dueDate: 'Today, 9:00 AM',
          dueTime: '9:00 AM',
          subMeta: 'Finance Portal',
          description: 'Categorize quarterly invoices and submit travel receipts.',
          priority: 'Medium',
          isCompleted: true,
          completedAt: '9:00 AM',
          reminderEnabled: false,
          isInProgress: false,
        ),
      ];
      saveTasks(initialTasks);
    }
  }

  List<TaskModel> getTasks() {
    final raw = _prefs.getString(_keyTasks);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => TaskModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final raw = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await _prefs.setString(_keyTasks, raw);
  }

  Future<TaskModel> insertTask(TaskModel task) async {
    final tasks = getTasks();
    final newId = tasks.isEmpty ? 1 : (tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1);
    final created = task.copyWith(id: newId);
    tasks.insert(0, created);
    await saveTasks(tasks);
    return created;
  }

  Future<void> updateTask(TaskModel task) async {
    final tasks = getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(int id) async {
    final tasks = getTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }

  Future<TaskModel> toggleTask(int id) async {
    final tasks = getTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception('Task not found');

    final current = tasks[index];
    final updated = current.copyWith(
      isCompleted: !current.isCompleted,
      completedAt: !current.isCompleted ? DateFormat('h:mm a').format(DateTime.now()) : null,
    );
    tasks[index] = updated;
    await saveTasks(tasks);
    return updated;
  }

  Future<void> markAllCompleted() async {
    final tasks = getTasks();
    final now = DateFormat('h:mm a').format(DateTime.now());
    final updated = tasks.map((t) => t.copyWith(isCompleted: true, completedAt: t.completedAt ?? now)).toList();
    await saveTasks(updated);
  }

  Future<void> clearCompleted() async {
    final tasks = getTasks();
    tasks.removeWhere((t) => t.isCompleted);
    await saveTasks(tasks);
  }

  Future<void> resetToDefaults() async {
    await _prefs.remove(_keyTasks);
    _initDefaultTasks();
  }
}
