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
        defaultValue: 'https://mkgfbkwcakesydvvnxzm.supabase.co',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rZ2Zia3djYWtlc3lkdnZueHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTAxODIsImV4cCI6MjA4NTg4NjE4Mn0.poE5xY42yoKOApRN7rtOny49yOPRjQnVdFza8ZVsyjw',
      ),
    );
    Logger.info('Supabase initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize Supabase', e, stackTrace);
    // Continue without Supabase for development
  }

  runApp(const ProviderScope(child: TaskFlowApp()));
}
