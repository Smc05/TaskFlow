import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:taskflow/core/database/database_helper.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// SQLite implementation of local data source for tasks
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _dbHelper;
  
  // Stream controller for watching tasks
  final _tasksStreamController = StreamController<void>.broadcast();

  TaskLocalDataSourceImpl(this._dbHelper);

  @override
  Future<List<TaskModel>> getTasks(String boardId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tasksTable,
        where: 'board_id = ?',
        whereArgs: [boardId],
        orderBy: 'task_order ASC',
      );
      
      final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();
      Logger.data('Retrieved ${tasks.length} tasks from local DB for board: $boardId');
      return tasks;
    } catch (e, stackTrace) {
      Logger.error('Error getting tasks from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks(String boardId) {
    return _tasksStreamController.stream
        .asyncMap((_) => getTasks(boardId))
        .handleError((error, stackTrace) {
      Logger.error('Error in tasks stream', error, stackTrace);
    });
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tasksTable,
        where: 'id = ?',
        whereArgs: [taskId],
        limit: 1,
      );
      
      if (maps.isEmpty) {
        return null;
      }
      
      return TaskModel.fromMap(maps.first);
    } catch (e, stackTrace) {
      Logger.error('Error getting task by ID from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        DatabaseHelper.tasksTable,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      Logger.data('Saved task to local DB: ${task.id}');
      _notifyListeners();
    } catch (e, stackTrace) {
      Logger.error('Error saving task to local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final db = await _dbHelper.database;
      final batch = db.batch();
      
      for (final task in tasks) {
        batch.insert(
          DatabaseHelper.tasksTable,
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      await batch.commit(noResult: true);
      Logger.data('Saved ${tasks.length} tasks to local DB');
      _notifyListeners();
    } catch (e, stackTrace) {
      Logger.error('Error saving tasks to local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final db = await _dbHelper.database;
      final deletedCount = await db.delete(
        DatabaseHelper.tasksTable,
        where: 'id = ?',
        whereArgs: [taskId],
      );
      
      if (deletedCount > 0) {
        Logger.data('Deleted task from local DB: $taskId');
        _notifyListeners();
      }
    } catch (e, stackTrace) {
      Logger.error('Error deleting task from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> markAsSynced(String taskId) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        DatabaseHelper.tasksTable,
        {'is_synced': 1, 'sync_operation': null},
        where: 'id = ?',
        whereArgs: [taskId],
      );
      
      Logger.data('Marked task as synced: $taskId');
      _notifyListeners();
    } catch (e, stackTrace) {
      Logger.error('Error marking task as synced', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tasksTable,
        where: 'is_synced = ?',
        whereArgs: [0],
      );
      
      final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();
      Logger.data('Found ${tasks.length} unsynced tasks');
      return tasks;
    } catch (e, stackTrace) {
      Logger.error('Error getting unsynced tasks', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final db = await _dbHelper.database;
      await db.delete(DatabaseHelper.tasksTable);
      Logger.info('Cleared all tasks from local DB');
      _notifyListeners();
    } catch (e, stackTrace) {
      Logger.error('Error clearing tasks from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> addToSyncQueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        DatabaseHelper.syncQueueTable,
        {
          'entity_type': entityType,
          'entity_id': entityId,
          'operation': operation,
          'data': data.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          'retry_count': 0,
        },
      );
      
      Logger.data('Added to sync queue: $operation $entityType $entityId');
    } catch (e, stackTrace) {
      Logger.error('Error adding to sync queue', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> removeFromSyncQueue(int queueId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        DatabaseHelper.syncQueueTable,
        where: 'id = ?',
        whereArgs: [queueId],
      );
      
      Logger.data('Removed from sync queue: $queueId');
    } catch (e, stackTrace) {
      Logger.error('Error removing from sync queue', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.syncQueueTable,
        orderBy: 'timestamp ASC',
      );
      
      Logger.data('Found ${maps.length} pending sync operations');
      return maps;
    } catch (e, stackTrace) {
      Logger.error('Error getting pending sync operations', e, stackTrace);
      rethrow;
    }
  }

  /// Notify stream listeners of data changes
  void _notifyListeners() {
    if (!_tasksStreamController.isClosed) {
      _tasksStreamController.add(null);
    }
  }

  /// Dispose resources
  void dispose() {
    _tasksStreamController.close();
  }
}
