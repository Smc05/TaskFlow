import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension for easier widget testing with Riverpod
extension PumpApp on WidgetTester {
  /// Pump a widget wrapped in MaterialApp and ProviderScope
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    ThemeData? theme,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: theme,
          home: widget,
        ),
      ),
    );
  }
  
  /// Pump a widget wrapped in MaterialApp, ProviderScope, and Scaffold
  Future<void> pumpAppWithScaffold(
    Widget widget, {
    List<Override> overrides = const [],
    ThemeData? theme,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: theme,
          home: Scaffold(
            body: widget,
          ),
        ),
      ),
    );
  }
  
  /// Pump and settle with a longer duration for animations
  Future<void> pumpAndSettleLong([
    Duration duration = const Duration(seconds: 5),
  ]) {
    return pumpAndSettle(duration);
  }
}
