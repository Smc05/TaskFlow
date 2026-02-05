import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Use case for retrieving tasks from a board
class GetTasks {
  final TaskRepository repository;

  const GetTasks(this.repository);

  /// Execute the use case
  AsyncResult<List<Task>> call(String boardId) {
    return repository.getTasks(boardId);
  }

  /// Get tasks by status
  AsyncResult<List<Task>> byStatus(String boardId, TaskStatus status) {
    return repository.getTasksByStatus(boardId, status);
  }
}
