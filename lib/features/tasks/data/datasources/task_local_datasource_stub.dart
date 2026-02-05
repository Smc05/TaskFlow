import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// Stub implementation of TaskLocalDataSource for Step 3
/// This will be replaced with proper SQLite implementation in Step 4
class TaskLocalDataSourceStub implements TaskLocalDataSource {
  final Map<String, TaskModel> _cache = {};
  final List<Map<String, dynamic>> _syncQueue = [];

  @override
  Future<void> addToSyncQueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    _syncQueue.add({
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation,
      'data': data,
    });
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
    _syncQueue.clear();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _cache.remove(taskId);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    return List.from(_syncQueue);
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    return _cache[taskId];
  }

  @override
  Future<List<TaskModel>> getTasks(String boardId) async {
    return _cache.values
        .where((task) => task.boardId == boardId)
        .toList();
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    return _cache.values.where((task) => !task.isSynced).toList();
  }

  @override
  Future<void> markAsSynced(String taskId) async {
    final task = _cache[taskId];
    if (task != null) {
      _cache[taskId] = task.copyWith(isSynced: true);
    }
  }

  @override
  Future<void> removeFromSyncQueue(int queueId) async {
    if (queueId >= 0 && queueId < _syncQueue.length) {
      _syncQueue.removeAt(queueId);
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    _cache[task.id] = task;
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    for (final task in tasks) {
      _cache[task.id] = task;
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks(String boardId) async* {
    // Simple stream that emits current cache state
    // In real implementation, this would watch the SQLite database
    yield _cache.values
        .where((task) => task.boardId == boardId)
        .toList();
  }
}
