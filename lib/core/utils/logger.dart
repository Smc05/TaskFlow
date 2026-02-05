import 'package:flutter/foundation.dart';

/// Simple logger utility for the application
class Logger {
  Logger._();

  static const String _prefix = '[TaskFlow]';

  /// Log debug message (only in debug mode)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_prefix [DEBUG] $message');
      if (error != null) {
        debugPrint('$_prefix [DEBUG] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_prefix [DEBUG] StackTrace: $stackTrace');
      }
    }
  }

  /// Log info message
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix [INFO] $message');
    }
  }

  /// Log warning message
  static void warning(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('$_prefix [WARNING] $message');
      if (error != null) {
        debugPrint('$_prefix [WARNING] Error: $error');
      }
    }
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('$_prefix [ERROR] $message');
    if (error != null) {
      debugPrint('$_prefix [ERROR] Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('$_prefix [ERROR] StackTrace: $stackTrace');
    }
  }

  /// Log network request
  static void network(String method, String url, [int? statusCode]) {
    if (kDebugMode) {
      final status = statusCode != null ? ' - Status: $statusCode' : '';
      debugPrint('$_prefix [NETWORK] $method $url$status');
    }
  }

  /// Log data operation
  static void data(String operation, [String? details]) {
    if (kDebugMode) {
      final detailsStr = details != null ? ' - $details' : '';
      debugPrint('$_prefix [DATA] $operation$detailsStr');
    }
  }
}
