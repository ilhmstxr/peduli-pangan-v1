import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/merchant_state.dart';
import '../data/merchant_repository.dart';
import '../data/merchant_providers.dart';

final merchantDetailVMProvider =
    NotifierProvider.family.autoDispose<MerchantDetailVm, MerchantState, int>(
  MerchantDetailVm.new,
);

class MerchantDetailVm extends Notifier<MerchantState> {
  MerchantDetailVm(this.merchantId);
  final int merchantId;

  @override
  MerchantState build() {
    state = const MerchantState(loading: true);
    _fetch();
    return state;
  }

  Future<void> _fetch() async {
    final repo = ref.read(merchantRepositoryProvider);
    try {
      final m = await repo.getMerchant(merchantId);
      if (!ref.mounted) return;
      if (m == null) {
        state = state.copyWith(loading: false, error: 'Merchant not found');
      } else {
        state = state.copyWith(loading: false, selected: m, error: null);
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    await _fetch();
  }
}
