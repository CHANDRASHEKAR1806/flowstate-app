import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AddTaskScreen({super.key, required this.onBack});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _category;
  late String _dueDate;
  late String _dueTime;
  late String _priority;
  late bool _reminderEnabled;

  bool _isEditMode = false;
  int _editingTaskId = 0;

  @override
  void initState() {
    super.initState();
    final taskProvider = context.read<TaskProvider>();
    final editing = taskProvider.editingTask;

    _isEditMode = editing != null;
    _editingTaskId = editing?.id ?? 0;

    // Clean blank inputs for new tasks; pre-filled for edit
    _titleController = TextEditingController(text: editing?.title ?? '');
    _descriptionController = TextEditingController(text: editing?.description ?? '');
    _category = editing?.category ?? 'Work';
    _dueDate = editing?.dueDate ?? 'Today';
    _dueTime = editing?.dueTime ?? '4:00 PM';
    _priority = editing?.priority ?? 'Medium';
    _reminderEnabled = editing?.reminderEnabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final userName = user?.fullName ?? 'User';
    final userRole = user?.role ?? 'Member';
    final userDept = user?.department ?? 'Workspace';
    final initials = user?.initials ?? 'U';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = ['Work', 'Personal', 'Urgent', 'Tech'];
    final dateOptions = ['Today', 'Tomorrow', 'Next Monday', 'End of Week'];
    final timeOptions = ['9:00 AM', '11:30 AM', '2:00 PM', '4:00 PM', '6:30 PM'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TaskProvider>().clearEditingTask();
            widget.onBack();
          },
        ),
        title: Text(
          _isEditMode ? 'Edit Task' : 'Add New Task',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Helper Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceContainerLowDark : AppColors.surfaceContainerLowLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'WORKFLOW TRIAGE',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Organize your workflow with smart priorities, deadlines, and formatted notes.',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Task Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Design System Review',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? AppColors.surfaceContainerLowestDark : Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Category Selector Chips
            const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: categories.map((cat) {
                final isSelected = _category.toLowerCase() == cat.toLowerCase();
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _category = cat),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Due Date Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _pickCustomDate(context),
                  icon: const Icon(Icons.calendar_month, size: 16),
                  label: const Text('Custom Date', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: dateOptions.map((opt) {
                final isSelected = _dueDate == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _dueDate = opt),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Due Time Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _pickCustomTime(context),
                  icon: const Icon(Icons.access_time, size: 16),
                  label: const Text('Custom Time', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: timeOptions.map((t) {
                final isSelected = _dueTime == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _dueTime = t),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Notes & AI Helper
            const Text('Notes & Subtasks', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceContainerLowestDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Add context, specifications, checklist, or deliverables...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLowLight,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            if (_descriptionController.text.trim().isNotEmpty) {
                              final text = _descriptionController.text.trim();
                              final userMail = user?.email.isNotEmpty == true ? user!.email : 'team@company.com';
                              _descriptionController.text = '• [ACTION]: $text\n• [SPECS]: Review deliverables\n• [SYNC]: $userMail';
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Note structured with Smart AI ✨')),
                              );
                            }
                          },
                          icon: const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
                          label: const Text('Smart AI Summarizer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Priority Selector
            const Text('Priority Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: ['Low', 'Medium', 'High'].map((p) {
                final isSelected = _priority.toLowerCase() == p.toLowerCase();
                final color = p == 'High' ? AppColors.error : AppColors.primary;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(child: Text(p)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _priority = p),
                      selectedColor: color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      showCheckmark: false,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Push Reminder Switch
            Card(
              child: SwitchListTile(
                title: const Text('Push Reminder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Notify 15 minutes before due time', style: TextStyle(fontSize: 12)),
                value: _reminderEnabled,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _reminderEnabled = v),
              ),
            ),

            const SizedBox(height: 12),

            // Assigned to Card
            Card(
              child: ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: const Text('Assigned to You', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: Text('$userName ($userRole · $userDept)', style: const TextStyle(fontSize: 12)),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerLowestDark : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {
                  context.read<TaskProvider>().clearEditingTask();
                  widget.onBack();
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      _isEditMode ? 'Update Task' : 'Save Task',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = DateFormat('MMM d').format(picked);
      });
    }
  }

  Future<void> _pickCustomTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _dueTime = picked.format(context);
      });
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final subMeta = '${user?.department ?? "Workspace"} · $_category';

    context.read<TaskProvider>().saveTask(
      id: _editingTaskId,
      title: title,
      category: _category,
      dueDate: _dueDate,
      dueTime: _dueTime,
      subMeta: subMeta,
      description: _descriptionController.text.trim(),
      priority: _priority,
      reminderEnabled: _reminderEnabled,
    );

    context.read<TaskProvider>().clearEditingTask();
    widget.onBack();
  }
}
