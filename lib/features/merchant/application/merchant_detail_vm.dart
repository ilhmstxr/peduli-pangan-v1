// application/merchant_detail_vm.dart
import '../data/merchant_model.dart';
import '../data/merchant_repository.dart';
import 'merchant_state.dart';

class MerchantDetailVm {
  final MerchantRepository repo;

  MerchantState _state = const MerchantState();
  MerchantState get state => _state;

  MerchantDetailVm(this.repo);

  Future<void> load(int id) async {
    _state = _state.copyWith(loading: true, error: null, selected: null);
    try {
      final m = await repo.getMerchant(id);
      if (m == null) {
        _state = _state.copyWith(loading: false, error: 'Merchant not found');
      } else {
        _state = _state.copyWith(loading: false, selected: m);
      }
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
    }
  }
}
