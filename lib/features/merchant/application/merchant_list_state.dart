import '../data/merchant_model.dart';
import 'merchant_filters.dart';

class MerchantListState {
  final bool loading;
  final String? error;
  final List<Merchant> items;
  final MerchantFilters filters;

  const MerchantListState({
    this.loading = false,
    this.error,
    this.items = const [],
    this.filters = const MerchantFilters(),
  });

  MerchantListState copyWith({
    bool? loading,
    String? error,          // set null explicitly by passing null
    List<Merchant>? items,
    MerchantFilters? filters,
  }) {
    return MerchantListState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
      filters: filters ?? this.filters,
    );
  }
}
