/// Test UUID constants for consistent testing
class TestUuids {
  // Board UUIDs
  static const defaultBoard = '00000000-0000-0000-0000-000000000000';
  static const testBoard1 = '11111111-1111-1111-1111-111111111111';
  static const testBoard2 = '22222222-2222-2222-2222-222222222222';
  
  // Task UUIDs
  static const testTask1 = '33333333-3333-3333-3333-333333333333';
  static const testTask2 = '44444444-4444-4444-4444-444444444444';
  static const testTask3 = '55555555-5555-5555-5555-555555555555';
  static const testTask4 = '66666666-6666-6666-6666-666666666666';
  static const testTask5 = '77777777-7777-7777-7777-777777777777';
  
  // User UUIDs
  static const testUser1 = '88888888-8888-8888-8888-888888888888';
  static const testUser2 = '99999999-9999-9999-9999-999999999999';
  
  /// Private constructor to prevent instantiation
  TestUuids._();
  
  /// Validate if a string is a valid UUID format
  static bool isValidUuid(String str) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(str);
  }
}
