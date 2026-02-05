import 'package:uuid/uuid.dart';

/// UUID generator utility for creating unique identifiers
class UuidGenerator {
  UuidGenerator._();

  static const Uuid _uuid = Uuid();

  /// Generate a new UUID v4 (random)
  static String generate() {
    return _uuid.v4();
  }

  /// Generate a new UUID v1 (time-based)
  static String generateTimeBased() {
    return _uuid.v1();
  }

  /// Validate if a string is a valid UUID
  static bool isValid(String uuid) {
    try {
      Uuid.parse(uuid);
      return true;
    } catch (e) {
      return false;
    }
  }
}
