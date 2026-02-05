import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:uuid/uuid.dart';

part 'tasks_notifier.g.dart';

/// State notifier managing all tasks for a board
@riverpod
class TasksNotifier extends _$TasksNotifier {
  final _uuid = const Uuid();

  @override
  List<Task> build(String boardId) {
    // Initialize with some mock data for testing
    return _generateMockTasks(boardId);
  }

  /// Generate mock tasks for testing
  List<Task> _generateMockTasks(String boardId) {
    final now = DateTime.now();
    return [
      Task(
        id: _uuid.v4(),
        title: 'Design login screen',
        description: 'Create mockups for the login and registration screens',
        status: TaskStatus.todo,
        priority: Priority.high,
        boardId: boardId,
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Setup Firebase',
        description: 'Configure Firebase project and add to the app',
        status: TaskStatus.todo,
        priority: Priority.medium,
        boardId: boardId,
        order: 1,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Implement authentication',
        description: 'Build login, registration, and password reset features',
        status: TaskStatus.inProgress,
        priority: Priority.high,
        boardId: boardId,
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Create API service',
        description: 'Build the REST API service layer',
        status: TaskStatus.inProgress,
        priority: Priority.medium,
        boardId: boardId,
        order: 1,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Write unit tests',
        description: 'Add unit tests for authentication module',
        status: TaskStatus.done,
        priority: Priority.low,
        boardId: boardId,
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Add a new task
  void addTask(Task task) {
    state = [...state, task];
  }

  /// Delete a task
  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  /// Update a task
  void updateTask(Task updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  /// Reorder tasks within the same column
  void reorderTask({
    required String taskId,
    required TaskStatus status,
    required int oldIndex,
    required int newIndex,
  }) {
    final tasks = state.where((t) => t.status == status).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (oldIndex < 0 || oldIndex >= tasks.length) return;
    if (newIndex < 0 || newIndex >= tasks.length) return;

    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    // Update order for all tasks in this column
    final updatedTasks = <Task>[];
    for (int i = 0; i < tasks.length; i++) {
      updatedTasks.add(tasks[i].copyWith(order: i, updatedAt: DateTime.now()));
    }

    // Merge with tasks from other columns
    final otherTasks = state.where((t) => t.status != status).toList();
    state = [...otherTasks, ...updatedTasks];
  }

  /// Move task to a different column
  void moveTask({
    required String taskId,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required int toIndex,
  }) {
    final task = state.firstWhere((t) => t.id == taskId);
    final tasksInTargetColumn =
        state.where((t) => t.status == toStatus).toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    // Insert at the specified index
    if (toIndex >= 0 && toIndex <= tasksInTargetColumn.length) {
      tasksInTargetColumn.insert(
        toIndex,
        task.copyWith(
          status: toStatus,
          order: toIndex,
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      tasksInTargetColumn.add(
        task.copyWith(
          status: toStatus,
          order: tasksInTargetColumn.length,
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Update order for all tasks in target column
    final updatedTargetTasks = <Task>[];
    for (int i = 0; i < tasksInTargetColumn.length; i++) {
      updatedTargetTasks.add(
        tasksInTargetColumn[i].copyWith(order: i, updatedAt: DateTime.now()),
      );
    }

    // Update order for remaining tasks in source column
    final tasksInSourceColumn =
        state.where((t) => t.status == fromStatus && t.id != taskId).toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final updatedSourceTasks = <Task>[];
    for (int i = 0; i < tasksInSourceColumn.length; i++) {
      updatedSourceTasks.add(
        tasksInSourceColumn[i].copyWith(order: i, updatedAt: DateTime.now()),
      );
    }

    // Merge with tasks from other columns
    final otherTasks = state
        .where((t) => t.status != fromStatus && t.status != toStatus)
        .toList();

    state = [...otherTasks, ...updatedSourceTasks, ...updatedTargetTasks];
  }

  /// Get tasks by status
  List<Task> getTasksByStatus(TaskStatus status) {
    return state.where((task) => task.status == status).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}

/// Provider for tasks grouped by status
@riverpod
Map<TaskStatus, List<Task>> tasksByStatus(
  TasksByStatusRef ref,
  String boardId,
) {
  final tasks = ref.watch(tasksNotifierProvider(boardId));

  final todoTasks = tasks.where((t) => t.status == TaskStatus.todo).toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  final inProgressTasks =
      tasks.where((t) => t.status == TaskStatus.inProgress).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

  final doneTasks = tasks.where((t) => t.status == TaskStatus.done).toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  return {
    TaskStatus.todo: todoTasks,
    TaskStatus.inProgress: inProgressTasks,
    TaskStatus.done: doneTasks,
  };
}
