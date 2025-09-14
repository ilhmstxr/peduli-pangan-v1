// lib/providers/kategori_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/kategori.dart';
import '../services/kategori_services.dart';

final kategoriServiceProvider = Provider<KategoriService>((ref) => KategoriService());

// List semua kategori
final kategoriListProvider = FutureProvider<List<Kategori>>((ref) async {
  final service = ref.read(kategoriServiceProvider);
  return service.getAll();
});

// Detail kategori by id
final kategoriByIdProvider = FutureProvider.family<Kategori, int>((ref, id) async {
  final service = ref.read(kategoriServiceProvider);
  return service.getById(id);
});

// Controller (CRUD)
class KategoriController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  KategoriController(this.ref) : super(const AsyncValue.data(null));

  KategoriService get _service => ref.read(kategoriServiceProvider);

  Future<void> create({required String name, required String slug, int? parentId}) async {
    state = const AsyncValue.loading();
    try {
      await _service.create(name: name, slug: slug, parentId: parentId);
      state = const AsyncValue.data(null);
      ref.invalidate(kategoriListProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update({required int id, String? name, String? slug, int? parentId}) async {
    state = const AsyncValue.loading();
    try {
      await _service.update(id: id, name: name, slug: slug, parentId: parentId);
      state = const AsyncValue.data(null);
      ref.invalidate(kategoriListProvider);
      ref.invalidate(kategoriByIdProvider(id));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    try {
      await _service.delete(id);
      state = const AsyncValue.data(null);
      ref.invalidate(kategoriListProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final kategoriControllerProvider =
    StateNotifierProvider<KategoriController, AsyncValue<void>>((ref) {
  return KategoriController(ref);
});
