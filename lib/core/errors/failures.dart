/// Base class for all failures in the application
/// Failures represent errors in the domain/business logic layer
sealed class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

/// Server-related failures (API errors, network issues, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Local cache/storage failures
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Unexpected/Unknown failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}

/// Stream-related failures
class StreamFailure extends Failure {
  const StreamFailure(super.message, {super.code});
}

/// Sync-related failures
class SyncFailure extends Failure {
  const SyncFailure(super.message, {super.code});
}

/// Not found failures (e.g., task not found, board not found)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

/// Permission/Authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}
