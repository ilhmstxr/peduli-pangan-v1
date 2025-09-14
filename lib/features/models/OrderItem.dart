import '../shared/helpers/helper.dart';
// order_items
class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final num productPrice; // snapshot price
  final int jumlah; // qty
  final num subtotal; // decimal(13,2)
  final DateTime? createdAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.jumlah,
    required this.subtotal,
    this.createdAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(
        id: m['id'] as int,
        orderId: m['order_id'] as int,
        productId: m['product_id'] as int,
        productName: m['product_name'] as String,
        productPrice: toNum(m['product_price']) ?? 0,
        jumlah: (m['jumlah'] as num).toInt(),
        subtotal: toNum(m['subtotal']) ?? 0,
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'product_id': productId,
        'product_name': productName,
        'product_price': productPrice,
        'jumlah': jumlah,
        'subtotal': subtotal,
        'created_at': createdAt?.toIso8601String(),
      };
}

