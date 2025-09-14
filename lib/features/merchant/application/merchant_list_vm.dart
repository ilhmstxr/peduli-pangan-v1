import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedulipanganv1/features/merchant/application/merchant_filters.dart';
import 'merchant_list_state.dart';
import '../data/merchant_repository.dart';
import '../data/merchant_providers.dart';
// import '../application/merchant_filters.dart';

/// Provider untuk List VM (Riverpod v3)
final merchantListVMProvider =
    NotifierProvider<MerchantListVm, MerchantListState>(MerchantListVm.new);

class MerchantListVm extends Notifier<MerchantListState> {
  @override
  MerchantListState build() {
    state = const MerchantListState(loading: true);
    _load();
    return state;
  }

  Future<void> _load() async {
    final repo = ref.read(merchantRepositoryProvider);
    try {
      // Sesuaikan signature repo-mu:
      // Jika listMerchants(MerchantFilters filters), kirim state.filters.
      final items = await repo.listMerchants(state.filters);

      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        error: null,
        items: items,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    await _load();
  }

  /// Optional: update filters lalu muat ulang
  void setFilters(MerchantFilters filters) {
    state = state.copyWith(filters: filters);
    refresh();
  }
}
