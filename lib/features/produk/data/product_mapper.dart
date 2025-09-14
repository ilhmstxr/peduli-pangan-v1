import 'product_model.dart';

class ProductMapper {
  static Product fromMap(Map<String, dynamic> m) => Product(
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

  static Map<String, dynamic> toInsertMap(Product p) => {
        'merchant_id': p.merchantId,
        'category_id': p.categoryId,
        'name': p.name,
        'slug': p.slug,
        'price': p.price,
        'stock': p.stock,
        'condition': p.condition,
        'short_desc': p.shortDesc,
        'long_desc': p.longDesc,
        'attributes': p.attributes,
        'rating': p.rating,
        'is_active': p.isActive,
      };

  static Map<String, dynamic> toUpdateMap(Product p) => {
        'category_id': p.categoryId,
        'name': p.name,
        'slug': p.slug,
        'price': p.price,
        'stock': p.stock,
        'condition': p.condition,
        'short_desc': p.shortDesc,
        'long_desc': p.longDesc,
        'attributes': p.attributes,
        'rating': p.rating,
        'is_active': p.isActive,
      }..removeWhere((k, v) => v == null);
}
