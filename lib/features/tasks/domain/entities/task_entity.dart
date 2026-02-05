import 'package:equatable/equatable.dart';

/// Task status enumeration
enum TaskStatus {
  todo('todo'),
  inProgress('inProgress'),
  done('done');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.todo,
    );
  }
}

/// Task priority enumeration
enum Priority {
  low('low'),
  medium('medium'),
  high('high');

  const Priority(this.value);
  final String value;

  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => Priority.medium,
    );
  }
}

/// Task entity - represents a task in the domain layer
class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final Priority priority;
  final String boardId;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;

  const Task({
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
  });

  /// Create a copy of this task with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    Priority? priority,
    String? boardId,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Task(
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
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    priority,
    boardId,
    order,
    createdAt,
    updatedAt,
    userId,
  ];

  @override
  bool get stringify => true;
}
