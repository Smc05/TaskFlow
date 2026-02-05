import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';

/// Task model - represents a task in the data layer
/// Handles JSON serialization/deserialization
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String boardId;
  final int order;
  final String createdAt;
  final String updatedAt;
  final String? userId;
  final bool isSynced;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.boardId,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.isSynced = true,
  });

  /// Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      boardId: json['board_id'] as String,
      order: json['task_order'] as int? ?? json['order'] as int? ?? 0,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as String?,
      isSynced:
          (json['is_synced'] as int?) == 1 ||
          (json['is_synced'] as bool?) == true,
    );
  }

  /// Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'board_id': boardId,
      'task_order': order,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
    };
  }

  /// Convert TaskModel to Map for SQLite (includes is_synced)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'board_id': boardId,
      'task_order': order,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  /// Create TaskModel from SQLite Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      status: map['status'] as String,
      priority: map['priority'] as String,
      boardId: map['board_id'] as String,
      order: map['task_order'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      userId: map['user_id'] as String?,
      isSynced: map['is_synced'] as int == 1,
    );
  }

  /// Convert TaskModel to Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.fromString(status),
      priority: Priority.fromString(priority),
      boardId: boardId,
      order: order,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      userId: userId,
    );
  }

  /// Create TaskModel from Task entity
  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status.value,
      priority: entity.priority.value,
      boardId: entity.boardId,
      order: entity.order,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      userId: entity.userId,
    );
  }

  /// Create a copy of this model with modified fields
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? boardId,
    int? order,
    String? createdAt,
    String? updatedAt,
    String? userId,
    bool? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      boardId: boardId ?? this.boardId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
