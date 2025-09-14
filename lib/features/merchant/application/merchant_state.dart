import '../data/merchant_model.dart';

class MerchantState {
  final bool loading;
  final String? error;
  final Merchant? selected;
  final List<Merchant> merchants;

  const MerchantState({
    this.loading = false,
    this.error,
    this.selected,
    this.merchants = const [],
  });

  MerchantState copyWith({
    bool? loading,
    String? error,
    Merchant? selected,
    List<Merchant>? merchants,
  }) {
    return MerchantState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      selected: selected ?? this.selected,
      merchants: merchants ?? this.merchants,
    );
  }
}
