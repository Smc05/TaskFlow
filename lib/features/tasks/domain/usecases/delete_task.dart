import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Use case for deleting a task
class DeleteTask {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  /// Execute the use case
  AsyncResult<void> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
