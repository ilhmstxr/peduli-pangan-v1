// lib/features/users/application/user_usecases.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';
import '../data/user_repository_supabase.dart';

/// Contoh use-case terpisah supaya VM tetap tipis.
class UpdateUserRole {
  UpdateUserRole(this.ref);
  final Ref ref;

  Future<Pengguna> call({required int id, required String newRole}) async {
    final repo = ref.read(userRepositoryProvider);
    final user = await repo.getById(id);
    if (user == null) {
      throw StateError('User not found');
    }
    final updated = user.copyWith(role: newRole);
    return repo.update(id, updated);
  }
}
