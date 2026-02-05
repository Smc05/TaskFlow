/// Base class for all exceptions in the application
/// Exceptions represent errors in the data layer
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException(this.message, {this.code, this.originalException});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server/API related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code, super.originalException});

  @override
  String toString() =>
      'ServerException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network connectivity exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NetworkException: $message';
}

/// Local cache/storage exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'CacheException: $message';
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalException});

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Data parsing exceptions
class ParsingException extends AppException {
  const ParsingException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'ParsingException: $message';
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NotFoundException: $message';
}
