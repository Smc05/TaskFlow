/// Enum representing different sync status types
enum SyncStatusType {
  idle,
  syncing,
  completed,
  failed,
  offline,
}

/// Class representing the current sync status
class SyncStatus {
  final SyncStatusType type;
  final String? message;

  const SyncStatus({
    required this.type,
    this.message,
  });

  // Static constants for common statuses
  static const idle = SyncStatus(type: SyncStatusType.idle);
  static const syncing = SyncStatus(type: SyncStatusType.syncing);
  static const offline = SyncStatus(type: SyncStatusType.offline);
  static const completed = SyncStatus(type: SyncStatusType.completed);
  
  factory SyncStatus.failed([String? message]) => SyncStatus(
        type: SyncStatusType.failed,
        message: message ?? 'Sync failed',
      );

  @override
  String toString() => 'SyncStatus(type: $type, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncStatus &&
        other.type == type &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(type, message);
}

/// Result of a sync operation
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
  bool get isSuccessful => failureCount == 0 && !hasErrors;

  @override
  String toString() =>
      'SyncResult(status: $status, success: $successCount, failed: $failureCount, errors: ${errors.length})';
}
