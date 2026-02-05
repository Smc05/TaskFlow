import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskflow/core/database/database_helper.dart';
import 'package:taskflow/core/network/network_info.dart';
import 'package:taskflow/core/sync/sync_manager.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Mock Supabase Client
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock Postgrest Query Builder
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder {}

/// Mock Postgrest Filter Builder
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}

/// Mock Postgrest Transform Builder
class MockPostgrestTransformBuilder extends Mock
    implements PostgrestTransformBuilder {}

/// Mock Task Repository
class MockTaskRepository extends Mock implements TaskRepository {}

/// Mock Task Remote Data Source
class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

/// Mock Task Local Data Source
class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

/// Mock Network Info
class MockNetworkInfo extends Mock implements NetworkInfo {}

/// Mock Database Helper
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

/// Mock Sync Manager
class MockSyncManager extends Mock implements SyncManager {}
