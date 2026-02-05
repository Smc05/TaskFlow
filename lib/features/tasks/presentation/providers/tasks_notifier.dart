import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/providers/task_repository_provider.dart';
import 'package:uuid/uuid.dart';

part 'tasks_notifier.g.dart';

/// Stream provider for real-time tasks from Supabase
@riverpod
Stream<List<Task>> tasksStream(TasksStreamRef ref, String boardId) {
  final repository = ref.watch(taskRepositoryProvider);

  Logger.data('Setting up tasks stream for board: $boardId');

  return repository.watchTasks(boardId).map((result) {
    return result.fold(
      (failure) {
        Logger.error('Stream error in tasksStream', failure);
        // Return empty list on error instead of throwing
        // This prevents the stream from breaking
        return <Task>[];
      },
      (tasks) {
        Logger.data('Stream emitted ${tasks.length} tasks');
        return tasks;
      },
    );
  });
}

/// State notifier managing task operations for a board
@riverpod
class TasksNotifier extends _$TasksNotifier {
  final _uuid = const Uuid();

  @override
  Future<List<Task>> build(String boardId) async {
    // Fetch initial tasks from repository
    final repository = ref.watch(taskRepositoryProvider);
    final result = await repository.getTasks(boardId);

    return result.fold(
      (failure) {
        Logger.error('Failed to load tasks', failure);
        // Return empty list on error, user will be notified
        return <Task>[];
      },
      (tasks) {
        Logger.data('Loaded ${tasks.length} tasks for board: $boardId');
        return tasks;
      },
    );
  }


  /// Add a new task
  Future<void> addTask(Task task) async {
    final repository = ref.read(taskRepositoryProvider);

    // Optimistically add to state
    state = AsyncData([...state.value ?? [], task]);

    final result = await repository.createTask(task);

    result.fold(
      (failure) {
        Logger.error('Failed to create task', failure);
        // Rollback on failure
        state = AsyncData(
          (state.value ?? []).where((t) => t.id != task.id).toList(),
        );
      },
      (createdTask) {
        Logger.data('Task created successfully: ${createdTask.id}');
        // Update with server response
        state = AsyncData([
          for (final t in (state.value ?? []))
            if (t.id == task.id) createdTask else t,
        ]);
      },
    );
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    final repository = ref.read(taskRepositoryProvider);
    final previousState = state.value ?? [];

    // Optimistically remove from state
    state = AsyncData(previousState.where((task) => task.id != taskId).toList());

    final result = await repository.deleteTask(taskId);

    result.fold(
      (failure) {
        Logger.error('Failed to delete task', failure);
        // Rollback on failure
        state = AsyncData(previousState);
      },
      (_) {
        Logger.data('Task deleted successfully: $taskId');
      },
    );
  }

  /// Update a task
  Future<void> updateTask(Task updatedTask) async {
    final repository = ref.read(taskRepositoryProvider);
    final previousState = state.value ?? [];

    // Optimistically update state
    state = AsyncData([
      for (final task in previousState)
        if (task.id == updatedTask.id) updatedTask else task,
    ]);

    final result = await repository.updateTask(updatedTask);

    result.fold(
      (failure) {
        Logger.error('Failed to update task', failure);
        // Rollback on failure
        state = AsyncData(previousState);
      },
      (serverTask) {
        Logger.data('Task updated successfully: ${serverTask.id}');
        // Update with server response
        state = AsyncData([
          for (final task in (state.value ?? []))
            if (task.id == serverTask.id) serverTask else task,
        ]);
      },
    );
  }

  /// Reorder tasks within the same column
  Future<void> reorderTask({
    required String taskId,
    required TaskStatus status,
    required int oldIndex,
    required int newIndex,
  }) async {
    final repository = ref.read(taskRepositoryProvider);
    final previousState = state.value ?? [];

    final tasks = previousState.where((t) => t.status == status).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (oldIndex < 0 || oldIndex >= tasks.length) return;
    if (newIndex < 0 || newIndex >= tasks.length) return;

    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    // Update order for all tasks in this column
    final updatedTasks = <Task>[];
    for (int i = 0; i < tasks.length; i++) {
      updatedTasks.add(
        tasks[i].copyWith(
          order: i,
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Optimistically update state
    final otherTasks = previousState.where((t) => t.status != status).toList();
    state = AsyncData([...otherTasks, ...updatedTasks]);

    // Update each task on the server
    for (final task in updatedTasks) {
      final result = await repository.updateTask(task);
      result.fold(
        (failure) => Logger.error('Failed to update task order', failure),
        (_) => Logger.data('Task order updated: ${task.id}'),
      );
    }
  }

  /// Move task to a different column
  Future<void> moveTask({
    required String taskId,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required int toIndex,
  }) async {
    final repository = ref.read(taskRepositoryProvider);
    final previousState = state.value ?? [];

    final task = previousState.firstWhere((t) => t.id == taskId);
    final tasksInTargetColumn =
        previousState.where((t) => t.status == toStatus).toList()
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
        tasksInTargetColumn[i].copyWith(
          order: i,
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Update order for remaining tasks in source column
    final tasksInSourceColumn =
        previousState.where((t) => t.status == fromStatus && t.id != taskId).toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final updatedSourceTasks = <Task>[];
    for (int i = 0; i < tasksInSourceColumn.length; i++) {
      updatedSourceTasks.add(
        tasksInSourceColumn[i].copyWith(
          order: i,
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Optimistically update state
    final otherTasks = previousState
        .where((t) => t.status != fromStatus && t.status != toStatus)
        .toList();
    state = AsyncData([...otherTasks, ...updatedSourceTasks, ...updatedTargetTasks]);

    // Use the moveTask method on repository for the moved task
    final result = await repository.moveTask(
      taskId: taskId,
      newStatus: toStatus,
      newOrder: toIndex,
    );

    result.fold(
      (failure) {
        Logger.error('Failed to move task', failure);
        // Rollback on failure
        state = AsyncData(previousState);
      },
      (_) {
        Logger.data('Task moved successfully: $taskId');
        // Update other tasks in the columns
        for (final task in [...updatedSourceTasks, ...updatedTargetTasks]) {
          if (task.id != taskId) {
            repository.updateTask(task);
          }
        }
      },
    );
  }

  /// Get tasks by status
  List<Task> getTasksByStatus(TaskStatus status) {
    return (state.value ?? [])
        .where((task) => task.status == status)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}

/// Provider for tasks grouped by status (synchronous version for compatibility)
@riverpod
Map<TaskStatus, List<Task>> tasksByStatus(
  TasksByStatusRef ref,
  String boardId,
) {
  final tasksAsync = ref.watch(tasksNotifierProvider(boardId));

  final tasks = tasksAsync.when(
    data: (tasks) => tasks,
    loading: () => <Task>[],
    error: (_, __) => <Task>[],
  );

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
