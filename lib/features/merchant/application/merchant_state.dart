// application/merchant_state.dart
import '../data/merchant_model.dart';

class MerchantState {
  final bool loading;
  final String? error;
  final List<Merchant> items;
  final Merchant? selected;

  const MerchantState({
    this.loading = false,
    this.error,
    this.items = const [],
    this.selected,
  });

  MerchantState copyWith({
    bool? loading,
    String? error,
    List<Merchant>? items,
    Merchant? selected,
  }) {
    return MerchantState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
      selected: selected ?? this.selected,
    );
  }
}
