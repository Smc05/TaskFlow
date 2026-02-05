import 'package:taskflow/core/errors/exceptions.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository
/// Coordinates between local and remote data sources
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  const TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  AsyncResult<List<Task>> getTasks(String boardId) async {
    try {
      Logger.data('Getting tasks for board: $boardId (local-first)');

      // ALWAYS return from local database first (fast, works offline)
      final localTasks = await localDataSource.getTasks(boardId);
      final tasks = localTasks.map((model) => model.toEntity()).toList();
      Logger.data('Retrieved ${tasks.length} tasks from local DB');

      // Sync with remote in the background (don't wait)
      _syncInBackground(boardId);

      return Results.success(tasks);
    } on CacheException catch (e) {
      Logger.error('Cache error while getting tasks', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while getting tasks', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  /// Sync tasks from remote to local in the background
  Future<void> _syncInBackground(String boardId) async {
    try {
      final remoteTasks = await remoteDataSource.getTasks(boardId);
      Logger.data('Background sync: fetched ${remoteTasks.length} tasks');

      // Update local cache with remote data
      for (final taskModel in remoteTasks) {
        await localDataSource.saveTask(taskModel.copyWith(isSynced: true));
      }
      Logger.data('Background sync completed');
    } on ServerException catch (e) {
      Logger.error('Background sync failed (offline?)', e);
      // Silently fail - user is already seeing local data
    } catch (e) {
      Logger.error('Unexpected error during background sync', e);
    }
  }

  @override
  Stream<Result<List<Task>>> watchTasks(String boardId) {
    try {
      Logger.data('Watching tasks (local-first) for board: $boardId');

      // ALWAYS watch local database as primary source
      final localStream = localDataSource
          .watchTasks(boardId)
          .map((models) {
            final tasks = models.map((model) => model.toEntity()).toList();
            return Results.success<List<Task>>(tasks);
          });

      // Subscribe to remote updates in background to keep local in sync
      remoteDataSource
          .watchTasks(boardId)
          .listen((models) async {
            // Update local cache with remote changes
            for (final taskModel in models) {
              try {
                await localDataSource
                    .saveTask(taskModel.copyWith(isSynced: true));
              } catch (e) {
                Logger.error('Failed to sync task ${taskModel.id}', e);
              }
            }
            Logger.data('Real-time sync: updated ${models.length} tasks');
          },
          onError: (error) {
            Logger.error('Remote stream error (offline?)', error);
            // Continue with local stream
          });

      return localStream;
    } catch (e, stackTrace) {
      Logger.error('Error setting up task watch stream', e, stackTrace);
      return Stream.value(Results.failure(StreamFailure(e.toString())));
    }
  }

  @override
  AsyncResult<Task> getTaskById(String taskId) async {
    try {
      Logger.data('Getting task by ID: $taskId');

      final taskModel = await localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Results.failure(const NotFoundFailure('Task not found'));
      }

      return Results.success(taskModel.toEntity());
    } on CacheException catch (e) {
      Logger.error('Cache error while getting task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while getting task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> createTask(Task task) async {
    try {
      Logger.data('Creating task: ${task.title}');

      final model = TaskModel.fromEntity(task);

      // Save to local storage immediately (optimistic update)
      await localDataSource.saveTask(model.copyWith(isSynced: false));

      try {
        // Try to create on remote
        final createdModel = await remoteDataSource.createTask(model);

        // Update local cache with synced version
        await localDataSource.saveTask(createdModel.copyWith(isSynced: true));

        Logger.data('Task created successfully: ${task.id}');
        return Results.success(createdModel.toEntity());
      } on ServerException catch (e) {
        Logger.error('Server error while creating task, queued for sync', e);

        // Add to sync queue for later
        await localDataSource.addToSyncQueue(
          entityType: 'task',
          entityId: task.id,
          operation: 'create',
          data: model.toJson(),
        );

        // Return the local version
        return Results.success(task);
      }
    } on CacheException catch (e) {
      Logger.error('Cache error while creating task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while creating task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> updateTask(Task task) async {
    try {
      Logger.data('Updating task: ${task.id}');

      final model = TaskModel.fromEntity(task);

      // Update in local storage immediately (optimistic update)
      await localDataSource.saveTask(model.copyWith(isSynced: false));

      try {
        // Try to update on remote
        final updatedModel = await remoteDataSource.updateTask(model);

        // Update local cache with synced version
        await localDataSource.saveTask(updatedModel.copyWith(isSynced: true));

        Logger.data('Task updated successfully: ${task.id}');
        return Results.success(updatedModel.toEntity());
      } on ServerException catch (e) {
        Logger.error('Server error while updating task, queued for sync', e);

        // Add to sync queue for later
        await localDataSource.addToSyncQueue(
          entityType: 'task',
          entityId: task.id,
          operation: 'update',
          data: model.toJson(),
        );

        // Return the local version
        return Results.success(task);
      }
    } on CacheException catch (e) {
      Logger.error('Cache error while updating task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while updating task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<void> deleteTask(String taskId) async {
    try {
      Logger.data('Deleting task: $taskId');

      // Delete from local storage immediately (optimistic update)
      await localDataSource.deleteTask(taskId);

      try {
        // Try to delete on remote
        await remoteDataSource.deleteTask(taskId);

        Logger.data('Task deleted successfully: $taskId');
        return Results.success(null);
      } on ServerException catch (e) {
        Logger.error('Server error while deleting task, queued for sync', e);

        // Add to sync queue for later
        await localDataSource.addToSyncQueue(
          entityType: 'task',
          entityId: taskId,
          operation: 'delete',
          data: {'id': taskId},
        );

        return Results.success(null);
      }
    } on CacheException catch (e) {
      Logger.error('Cache error while deleting task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while deleting task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> moveTask({
    required String taskId,
    required TaskStatus newStatus,
    required int newOrder,
  }) async {
    try {
      Logger.data(
        'Moving task $taskId to ${newStatus.value} at order $newOrder',
      );

      final taskResult = await getTaskById(taskId);

      if (taskResult.isLeft()) {
        return taskResult;
      }

      final task = taskResult.getOrThrow();
      final updatedTask = task.copyWith(
        status: newStatus,
        order: newOrder,
        updatedAt: DateTime.now(),
      );

      // Optimistically update local cache
      final model = TaskModel.fromEntity(updatedTask);
      await localDataSource.saveTask(model.copyWith(isSynced: false));

      try {
        // Try to move on remote
        final movedModel = await remoteDataSource.moveTask(
          taskId: taskId,
          newStatus: newStatus.value,
          newOrder: newOrder,
        );

        // Update local cache with synced version
        await localDataSource.saveTask(movedModel.copyWith(isSynced: true));

        Logger.data('Task moved successfully: $taskId');
        return Results.success(movedModel.toEntity());
      } on ServerException catch (e) {
        Logger.error('Server error while moving task, queued for sync', e);

        // Add to sync queue for later
        await localDataSource.addToSyncQueue(
          entityType: 'task',
          entityId: taskId,
          operation: 'update',
          data: model.toJson(),
        );

        // Return the local version
        return Results.success(updatedTask);
      }
    } catch (e, stackTrace) {
      Logger.error('Error while moving task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> reorderTask({
    required String taskId,
    required int newOrder,
  }) async {
    try {
      Logger.data('Reordering task $taskId to order $newOrder');

      final taskResult = await getTaskById(taskId);

      if (taskResult.isLeft()) {
        return taskResult;
      }

      final task = taskResult.getOrThrow();
      final updatedTask = task.copyWith(
        order: newOrder,
        updatedAt: DateTime.now(),
      );

      return updateTask(updatedTask);
    } catch (e, stackTrace) {
      Logger.error('Error while reordering task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<List<Task>> getTasksByStatus(
    String boardId,
    TaskStatus status,
  ) async {
    try {
      Logger.data(
        'Getting tasks for board $boardId with status ${status.value}',
      );

      final tasksResult = await getTasks(boardId);
      return tasksResult.map((tasks) {
        return tasks.where((task) => task.status == status).toList();
      });
    } catch (e, stackTrace) {
      Logger.error('Error while getting tasks by status', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }
}
