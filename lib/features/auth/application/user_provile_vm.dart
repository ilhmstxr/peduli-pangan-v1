// lib/features/users/application/user_profile_vm.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';
import '../data/user_repository_supabase.dart';

/// VM untuk profil pengguna (by id).
/// Family agar mudah dipakai di halaman detail/profil mana pun.
class UserProfileVm extends AsyncNotifier<Pengguna?> {
  late final UserRepository _repo;

  @override
  Future<Pengguna?> build() async {
    _repo = ref.read(userRepositoryProvider);
    // default tidak memuat apa-apa sampai dipanggil load(id)
    return null;
  }

  Future<void> load(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getById(id));
  }

  Future<void> refresh() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getById(current.id));
  }

  Future<void> updateProfile(Pengguna updated) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(() => _repo.update(updated.id, updated));
    state = res;
  }

  Future<void> softDelete() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    await _repo.softDelete(current.id);
    // setelah delete, kita kosongkan state
    state = const AsyncData(null);
  }

  Future<void> restore(int id) async {
    state = const AsyncLoading();
    await _repo.restore(id);
    state = await AsyncValue.guard(() => _repo.getById(id, includeDeleted: false));
  }
}

final userProfileVmProvider =
    AsyncNotifierProvider<UserProfileVm, Pengguna?>(UserProfileVm.new);
