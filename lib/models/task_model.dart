class TaskModel {
  final int id;
  final String title;
  final String category;
  final String dueDate;
  final String dueTime;
  final String subMeta;
  final String description;
  final String priority;
  final bool isCompleted;
  final String? completedAt;
  final bool reminderEnabled;
  final bool isInProgress;

  TaskModel({
    required this.id,
    required this.title,
    this.category = 'Work',
    this.dueDate = 'Today',
    this.dueTime = '4:00 PM',
    this.subMeta = 'Workspace',
    this.description = '',
    this.priority = 'Medium',
    this.isCompleted = false,
    this.completedAt,
    this.reminderEnabled = true,
    this.isInProgress = false,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? category,
    String? dueDate,
    String? dueTime,
    String? subMeta,
    String? description,
    String? priority,
    bool? isCompleted,
    String? completedAt,
    bool? reminderEnabled,
    bool? isInProgress,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      subMeta: subMeta ?? this.subMeta,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isInProgress: isInProgress ?? this.isInProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'dueDate': dueDate,
      'dueTime': dueTime,
      'subMeta': subMeta,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'completedAt': completedAt,
      'reminderEnabled': reminderEnabled,
      'isInProgress': isInProgress,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Work',
      dueDate: json['dueDate'] as String? ?? 'Today',
      dueTime: json['dueTime'] as String? ?? '4:00 PM',
      subMeta: json['subMeta'] as String? ?? 'Workspace',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      isInProgress: json['isInProgress'] as bool? ?? false,
    );
  }
}
