import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'merchant_repository.dart';
import 'merchant_repsitory_supabase.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MerchantRepositorySupabase(client);
});
