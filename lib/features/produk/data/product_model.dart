class Product {
  final int id;
  final int merchantId;
  final int categoryId;
  final String name;
  final String slug;
  final double price;
  final int stock;
  final String? condition;    // 'new' | 'used' | null
  final String? shortDesc;
  final String? longDesc;
  final Map<String, dynamic>? attributes;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.merchantId,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.price,
    required this.stock,
    this.condition,
    this.shortDesc,
    this.longDesc,
    this.attributes,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    int? id,
    int? merchantId,
    int? categoryId,
    String? name,
    String? slug,
    double? price,
    int? stock,
    String? condition,
    String? shortDesc,
    String? longDesc,
    Map<String, dynamic>? attributes,
    double? rating,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      condition: condition ?? this.condition,
      shortDesc: shortDesc ?? this.shortDesc,
      longDesc: longDesc ?? this.longDesc,
      attributes: attributes ?? this.attributes,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // --- Mapping ---
  static Product fromMap(Map<String, dynamic> m) {
    return Product(
      id: (m['id'] as num).toInt(),
      merchantId: (m['merchant_id'] as num).toInt(),
      categoryId: (m['category_id'] as num).toInt(),
      name: m['name'] as String,
      slug: m['slug'] as String,
      price: (m['price'] as num).toDouble(),
      stock: (m['stock'] as num).toInt(),
      condition: m['condition'] as String?,
      shortDesc: m['short_desc'] as String?,
      longDesc: m['long_desc'] as String?,
      attributes: (m['attributes'] as Map?)?.cast<String, dynamic>(),
      rating: (m['rating'] as num).toDouble(),
      isActive: m['is_active'] as bool,
      createdAt: DateTime.parse(m['created_at'] as String),
      updatedAt: DateTime.parse(m['updated_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() => {
        'merchant_id': merchantId,
        'category_id': categoryId,
        'name': name,
        'slug': slug,
        'price': price,
        'stock': stock,
        'condition': condition,
        'short_desc': shortDesc,
        'long_desc': longDesc,
        'attributes': attributes,
        'rating': rating,
        'is_active': isActive,
      };

  Map<String, dynamic> toUpdateMap() => {
        'category_id': categoryId,
        'name': name,
        'slug': slug,
        'price': price,
        'stock': stock,
        'condition': condition,
        'short_desc': shortDesc,
        'long_desc': longDesc,
        'attributes': attributes,
        'rating': rating,
        'is_active': isActive,
      }..removeWhere((k, v) => v == null);
}
