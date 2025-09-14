// lib/features/users/application/user_auth_vm.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/providers/supabase_providers.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';
import '../data/user_repository_supabase.dart';

/// VM untuk alur autentikasi/registrasi.
/// Catatan:
/// - Jika memakai Supabase Auth, kamu bisa panggil `sb.auth.signInWithPassword(...)`.
/// - Karena tabel `pengguna` punya `password_hash` NN, idealnya hashing dilakukan di server (Postgres function/RPC).
class UserAuthVm extends AsyncNotifier<Pengguna?> {
  late final SupabaseClient _sb;
  late final UserRepository _repo;

  @override
  Future<Pengguna?> build() async {
    _sb = ref.read(supabaseClientProvider);
    _repo = ref.read(userRepositoryProvider);
    return null;
  }

  /// Contoh sign-in menggunakan Supabase Auth (disarankan).
  /// Sesuaikan dengan kebutuhanmu bila tetap memakai kolom password_hash custom.
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(() async {
      final auth = await _sb.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Setelah berhasil, ambil profil dari tabel `pengguna` berdasarkan email.
      final user = await _repo.getByEmail(email);
      return user;
    });
    state = res;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await _sb.auth.signOut();
    state = const AsyncData(null);
  }

  /// Contoh sign-up + buat baris di `pengguna`.
  /// Jika pakai Supabase Auth, kamu **tidak perlu** mengirim `password_hash` ke tabel.
  /// Namun skema saat ini `password_hash` NN — atur di DB: buat kolom opsional
  /// atau isi via trigger/RPC agar tidak menyimpan plaintext di client.
  Future<void> signUpAndCreateProfile({
    required String email,
    required String password,
    required String name,
    required String username,
    String role = 'user',
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(() async {
      await _sb.auth.signUp(email: email, password: password);

      // Buat row profil. Jangan mengirim password ke client.
      final created = await _repo.create(
        Pengguna(
          id: 0, // diabaikan; diisi DB (serial/bigint)
          name: name,
          email: email,
          username: username,
          role: role,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          deletedAt: null,
          passwordHash: null,
        ),
      );
      return created;
    });
    state = res;
  }
}

final userAuthVmProvider =
    AsyncNotifierProvider<UserAuthVm, Pengguna?>(UserAuthVm.new);
