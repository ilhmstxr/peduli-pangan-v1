class GambarProduk {
  final int id;
  final DateTime createdAt;
  final String url;
  final bool isPrimary;
  final int productId;

  const GambarProduk({
    required this.id,
    required this.createdAt,
    required this.url,
    required this.isPrimary,
    required this.productId,
  });

  GambarProduk copyWith({
    int? id,
    DateTime? createdAt,
    String? url,
    bool? isPrimary,
    int? productId,
  }) {
    return GambarProduk(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      productId: productId ?? this.productId,
    );
  }

  // ---- Mapping dari Supabase row (Map<String, dynamic>)
  static GambarProduk fromMap(Map<String, dynamic> m) {
    return GambarProduk(
      id: (m['id'] as num).toInt(),
      createdAt: DateTime.parse(m['created_at'] as String),
      url: m['url'] as String,
      isPrimary: (m['is_primary'] as bool?) ?? false,
      productId: (m['product_id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toInsertMap() => {
        'url': url,
        'is_primary': isPrimary,
        'product_id': productId,
      };

  Map<String, dynamic> toUpdateMap() => {
        'url': url,
        'is_primary': isPrimary,
      };
}
