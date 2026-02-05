import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

/// Provider for Supabase client instance
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

/// Provider for current Supabase user
@riverpod
User? currentUser(CurrentUserRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentUser;
}

/// Provider for authentication state stream
@riverpod
Stream<AuthState> authStateStream(AuthStateStreamRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
}
