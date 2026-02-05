import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Use case for updating an existing task
class UpdateTask {
  final TaskRepository repository;

  const UpdateTask(this.repository);

  /// Execute the use case
  AsyncResult<Task> call(Task task) {
    return repository.updateTask(task);
  }
}
