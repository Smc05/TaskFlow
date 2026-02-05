import 'dart:convert';

/// Represents a pending sync operation in the queue
class SyncOperation {
  final int? id;
  final String entityType; // 'task', 'board'
  final String entityId;
  final String operation; // 'create', 'update', 'delete'
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final int retryCount;
  final String? lastError;

  const SyncOperation({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.lastError,
  });

  /// Create from database map
  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'] as int?,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      operation: map['operation'] as String,
      data: map['data'] != null 
        ? jsonDecode(map['data'] as String) as Map<String, dynamic>
        : null,
      timestamp: DateTime.parse(map['timestamp'] as String),
      retryCount: map['retry_count'] as int? ?? 0,
      lastError: map['last_error'] as String?,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation,
      'data': data != null ? jsonEncode(data) : null,
      'timestamp': timestamp.toIso8601String(),
      'retry_count': retryCount,
      'last_error': lastError,
    };
  }

  /// Copy with
  SyncOperation copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? operation,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? retryCount,
    String? lastError,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  String toString() {
    return 'SyncOperation(id: $id, type: $entityType, operation: $operation, '
           'entityId: $entityId, retryCount: $retryCount)';
  }
}

/// Sync status for UI feedback
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
  offline;

  bool get isSyncing => this == SyncStatus.syncing;
  bool get isCompleted => this == SyncStatus.completed;
  bool get isFailed => this == SyncStatus.failed;
  bool get isOffline => this == SyncStatus.offline;
}

/// Sync result model
class SyncResult {
  final SyncStatus status;
  final int successCount;
  final int failureCount;
  final List<String> errors;

  const SyncResult({
    required this.status,
    this.successCount = 0,
    this.failureCount = 0,
    this.errors = const [],
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => status == SyncStatus.completed && failureCount == 0;

  @override
  String toString() {
    return 'SyncResult(status: $status, success: $successCount, '
           'failures: $failureCount, errors: ${errors.length})';
  }
}
