import '../shared/helpers/helper.dart';


// gambar_product
class GambarProduct {
  final int id;
  final int productId;
  final String url;
  final bool isPrimary;
  final DateTime? createdAt;

  const GambarProduct({
    required this.id,
    required this.productId,
    required this.url,
    this.isPrimary = false,
    this.createdAt,
  });

  factory GambarProduct.fromMap(Map<String, dynamic> m) => GambarProduct(
        id: m['id'] as int,
        productId: m['product_id'] as int,
        url: m['url'] as String,
        isPrimary: toBool(m['is_primary']) ?? false,
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_id': productId,
        'url': url,
        'is_primary': isPrimary,
        'created_at': createdAt?.toIso8601String(),
      };
}

