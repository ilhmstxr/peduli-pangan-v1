import '../data/kategori_model.dart';

class KategoriState {
  final List<Kategori> items;
  final bool isLoading;
  final String? error;
  final String search;
  final int? parentFilter;

  const KategoriState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.search = '',
    this.parentFilter,
  });

  KategoriState copyWith({
    List<Kategori>? items,
    bool? isLoading,
    String? error,
    String? search,
    int? parentFilter,
  }) =>
      KategoriState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        search: search ?? this.search,
        parentFilter: parentFilter ?? this.parentFilter,
      );
}
