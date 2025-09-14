import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider global untuk SupabaseClient
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider untuk session saat ini (opsional)
final supabaseSessionProvider = Provider<Session?>((ref) {
  return Supabase.instance.client.auth.currentSession;
});

/// Provider untuk user saat ini (opsional)
final supabaseUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});
