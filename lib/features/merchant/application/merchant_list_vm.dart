// application/merchant_list_vm.dart
import '../data/merchant_model.dart';
import '../data/merchant_repository.dart';
import 'merchant_filters.dart';
import 'merchant_state.dart';

class MerchantListVm {
  final MerchantRepository repo;

  MerchantState _state = const MerchantState();
  MerchantState get state => _state;

  MerchantFilters _filters = const MerchantFilters(limit: 20, page: 1);
  MerchantFilters get filters => _filters;

  MerchantListVm(this.repo);

  Future<void> load({MerchantFilters? filters}) async {
    _state = _state.copyWith(loading: true, error: null);
    if (filters != null) _filters = filters;
    try {
      final data = await repo.listMerchants(_filters);
      _state = _state.copyWith(loading: false, items: data);
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refresh() => load(filters: _filters);

  void updateFilter(MerchantFilters Function(MerchantFilters) updater) {
    _filters = updater(_filters);
  }

  /// Optimistic remove
  Future<void> delete(int id) async {
    final previous = _state.items;
    _state = _state.copyWith(items: previous.where((m) => m.id != id).toList());
    try {
      await repo.deleteMerchant(id);
    } catch (e) {
      // rollback
      _state = _state.copyWith(error: e.toString(), items: previous);
    }
  }
}
