import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';

part 'tasks_provider.g.dart';

/// Provider for tasks list by board ID
/// This will be implemented with actual repository in later steps
@riverpod
Future<List<Task>> tasks(TasksRef ref, String boardId) async {
  // TODO: Implement with actual repository
  // final repository = ref.watch(taskRepositoryProvider);
  // final result = await repository.getTasks(boardId);
  // return result.fold(
  //   (failure) => throw Exception(failure.message),
  //   (tasks) => tasks,
  // );

  // Placeholder: return empty list
  return [];
}

/// Provider for tasks stream by board ID
/// Real-time updates will be implemented in later steps
@riverpod
Stream<List<Task>> tasksStream(TasksStreamRef ref, String boardId) {
  // TODO: Implement with actual repository
  // final repository = ref.watch(taskRepositoryProvider);
  // return repository.watchTasks(boardId).map(
  //   (result) => result.fold(
  //     (failure) => throw Exception(failure.message),
  //     (tasks) => tasks,
  //   ),
  // );

  // Placeholder: return empty stream
  return Stream.value([]);
}

/// Provider for tasks grouped by status
@riverpod
Future<Map<TaskStatus, List<Task>>> tasksByStatus(
  TasksByStatusRef ref,
  String boardId,
) async {
  final tasks = await ref.watch(tasksProvider(boardId).future);

  return {
    TaskStatus.todo: tasks.where((t) => t.status == TaskStatus.todo).toList(),
    TaskStatus.inProgress: tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .toList(),
    TaskStatus.done: tasks.where((t) => t.status == TaskStatus.done).toList(),
  };
}
