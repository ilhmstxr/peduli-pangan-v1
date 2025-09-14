import '../data/product_model.dart';
import '../data/product_filters.dart';

class ProductState {
  final List<Product> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final ProductFilters filters;
  final DateTime? cursor; // createdAt terakhir (desc)

  const ProductState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.filters = const ProductFilters(),
    this.cursor,
  });

  ProductState copyWith({
    List<Product>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    ProductFilters? filters,
    DateTime? cursor,
    bool clearError = false,
  }) {
    return ProductState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
      cursor: cursor ?? this.cursor,
    );
  }
}
