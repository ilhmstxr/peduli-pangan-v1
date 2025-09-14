// lib/features/users/data/user_repository.dart
import 'user_model.dart';

abstract class UserRepository {
  /// List pengguna aktif (default excludes soft-deleted).
  Future<List<Pengguna>> list({
    int limit = 20,
    int offset = 0,
    String? query, // search by name/username/email
    bool includeDeleted = false,
    String? role,
  });

  Future<Pengguna?> getById(int id, {bool includeDeleted = false});

  Future<Pengguna?> getByEmail(String email, {bool includeDeleted = false});

  /// Insert user baru.
  /// ⚠️ Pastikan hashing dilakukan di server (RLS/RPC) bila memungkinkan.
  Future<Pengguna> create(Pengguna newUser);

  Future<Pengguna> update(int id, Pengguna user);

  /// Soft delete => set `deleted_at = now()`.
  Future<void> softDelete(int id);

  /// Restore soft-deleted user.
  Future<void> restore(int id);
}
