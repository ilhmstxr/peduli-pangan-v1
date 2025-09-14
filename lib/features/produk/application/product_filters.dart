class ProductFilters {
  final String? q; // search by name
  final int? categoryId;
  final bool onlyActive;
  final int limit;
  final DateTime? before; // cursor by createdAt (descending)
  final int? merchantId; // 🔥 tambahkan ini

  const ProductFilters({
    this.q,
    this.categoryId,
    this.onlyActive = true,
    this.limit = 20,
    this.before,
    this.merchantId, // 🔥 tambahkan ini
  });

  ProductFilters copyWith({
    String? q,
    int? categoryId,
    bool? onlyActive,
    int? limit,
    DateTime? before,
    int? merchantId, // 🔥 tambahkan ini
  }) {
    return ProductFilters(
      q: q ?? this.q,
      categoryId: categoryId ?? this.categoryId,
      onlyActive: onlyActive ?? this.onlyActive,
      limit: limit ?? this.limit,
      before: before ?? this.before,
      merchantId: merchantId ?? this.merchantId, // 🔥 tambahkan ini
    );
  }
}
