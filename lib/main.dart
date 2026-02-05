import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskflow/app.dart';
import 'package:taskflow/core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // Note: Replace with your actual Supabase URL and anon key
  // These should be stored in environment variables or a config file
  try {
    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'YOUR_SUPABASE_URL',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'YOUR_SUPABASE_ANON_KEY',
      ),
    );
    Logger.info('Supabase initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize Supabase', e, stackTrace);
    // Continue without Supabase for development
  }

  runApp(const ProviderScope(child: TaskFlowApp()));
}
