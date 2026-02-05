import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import '../helpers/uuid_helpers.dart';

/// Test fixture for creating Task entities
class TaskFixtures {
  /// Create a test task with default values
  static Task createTask({
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
    final now = DateTime.now();
    return Task(
      id: id ?? TestUuids.testTask1,
      title: title ?? 'Test Task',
      description: description ?? 'Test Description',
      status: status ?? TaskStatus.todo,
      priority: priority ?? Priority.medium,
      boardId: boardId ?? TestUuids.defaultBoard,
      order: order ?? 0,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      userId: userId,
    );
  }
  
  /// Create a todo task
  static Task createTodoTask({
    String? id,
    String? title,
    String? boardId,
  }) {
    return createTask(
      id: id ?? TestUuids.testTask1,
      title: title ?? 'Todo Task',
      status: TaskStatus.todo,
      boardId: boardId,
    );
  }
  
  /// Create an in-progress task
  static Task createInProgressTask({
    String? id,
    String? title,
    String? boardId,
  }) {
    return createTask(
      id: id ?? TestUuids.testTask2,
      title: title ?? 'In Progress Task',
      status: TaskStatus.inProgress,
      boardId: boardId,
    );
  }
  
  /// Create a done task
  static Task createDoneTask({
    String? id,
    String? title,
    String? boardId,
  }) {
    return createTask(
      id: id ?? TestUuids.testTask3,
      title: title ?? 'Done Task',
      status: TaskStatus.done,
      boardId: boardId,
    );
  }
  
  /// Create a list of test tasks
  static List<Task> createTaskList({
    String? boardId,
    int count = 5,
  }) {
    final board = boardId ?? TestUuids.defaultBoard;
    return List.generate(
      count,
      (index) => createTask(
        id: 'task-$index-uuid-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Task ${index + 1}',
        boardId: board,
        order: index,
        status: index % 3 == 0
            ? TaskStatus.todo
            : index % 3 == 1
                ? TaskStatus.inProgress
                : TaskStatus.done,
      ),
    );
  }
  
  /// Private constructor to prevent instantiation
  TaskFixtures._();
}
