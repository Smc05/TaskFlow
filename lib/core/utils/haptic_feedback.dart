import 'package:flutter/services.dart';

/// Utility class for haptic feedback
class HapticFeedbackUtil {
  HapticFeedbackUtil._();

  /// Light impact feedback (e.g., on hover)
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact feedback (e.g., on drag start)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact feedback (e.g., on successful drop)
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click feedback
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate on error
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }
}
