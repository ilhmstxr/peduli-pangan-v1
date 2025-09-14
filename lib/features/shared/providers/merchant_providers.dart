
// lib/providers/merchant_provider.dart
// Revisi: tambah provider detail + controller (CRUD) berbasis StateNotifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/merchant.dart';
import '../services/merchant_services.dart';

final merchantServiceProvider = Provider<MerchantService>((ref) => MerchantService());

// List merchant (read)
final merchantsProvider = FutureProvider<List<Merchant>>((ref) async {
  final service = ref.read(merchantServiceProvider);
  return service.getMerchantsWithProducts();
});

// Detail merchant (read by id)
final merchantByIdProvider = FutureProvider.family<Merchant, int>((ref, id) async {
  final service = ref.read(merchantServiceProvider);
  return service.getMerchantById(id);
});

// Controller untuk operasi tulis (create/update/delete) dan memicu refresh
class MerchantController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  MerchantController(this.ref) : super(const AsyncValue.data(null));

  MerchantService get _service => ref.read(merchantServiceProvider);

  Future<void> create({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.createMerchant(
        userId: userId,
        namaToko: namaToko,
        deskripsi: deskripsi,
        rating: rating,
      );
      state = const AsyncValue.data(null);
      // Refresh list
      ref.invalidate(merchantsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update({
    required int id,
    String? namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateMerchant(
        id: id,
        namaToko: namaToko,
        deskripsi: deskripsi,
        rating: rating,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(merchantsProvider);
      ref.invalidate(merchantByIdProvider(id));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteMerchant(id);
      state = const AsyncValue.data(null);
      ref.invalidate(merchantsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final merchantControllerProvider =
    StateNotifierProvider<MerchantController, AsyncValue<void>>((ref) {
  return MerchantController(ref);
});
