import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskflow/core/utils/logger.dart';

/// SQLite database helper for local storage and offline-first functionality
class DatabaseHelper {
  static const String _databaseName = 'taskflow.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tasksTable = 'tasks';
  static const String boardsTable = 'boards';
  static const String syncQueueTable = 'sync_queue';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  /// Get database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    Logger.info('Initializing database at: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    Logger.info('Creating database tables...');

    // Tasks table
    await db.execute('''
      CREATE TABLE $tasksTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        priority TEXT NOT NULL,
        board_id TEXT NOT NULL,
        task_order INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        user_id TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_operation TEXT,
        version INTEGER DEFAULT 1
      )
    ''');

    // Boards table
    await db.execute('''
      CREATE TABLE $boardsTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        owner_id TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Sync queue table
    await db.execute('''
      CREATE TABLE $syncQueueTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT,
        timestamp TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        last_error TEXT
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX idx_tasks_status ON $tasksTable(status)',
    );
    await db.execute(
      'CREATE INDEX idx_tasks_board ON $tasksTable(board_id)',
    );
    await db.execute(
      'CREATE INDEX idx_tasks_order ON $tasksTable(board_id, task_order)',
    );
    await db.execute(
      'CREATE INDEX idx_sync_queue_timestamp ON $syncQueueTable(timestamp)',
    );

    Logger.info('Database tables created successfully');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Logger.info('Upgrading database from v$oldVersion to v$newVersion');
    
    // Handle migrations here when schema changes
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE tasks ADD COLUMN new_column TEXT');
    // }
  }

  /// Clear all data from database (useful for testing or logout)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(tasksTable);
    await db.delete(boardsTable);
    await db.delete(syncQueueTable);
    Logger.info('All database data cleared');
  }

  /// Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
      Logger.info('Database connection closed');
    }
  }

  /// Delete database (useful for testing)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
    Logger.info('Database deleted');
  }
}
