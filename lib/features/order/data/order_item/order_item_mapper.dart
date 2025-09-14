// Order Item Mapper
import 'order_item_model.dart';

class OrderItemMapper {
  static OrderItemModel fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      namaProduct: map['nama_product'] as String,
      hargaProduct: (map['harga_product'] as num).toDouble(),
      jumlah: map['jumlah'] as int,
      subtotal: (map['subtotal'] as num).toDouble(),
      productId: map['product_id'] as String,
      orderId: map['order_id'] as String,
    );
  }

  static Map<String, dynamic> toMap(OrderItemModel item) {
    return {
      'id': item.id,
      'created_at': item.createdAt.toIso8601String(),
      'nama_product': item.namaProduct,
      'harga_product': item.hargaProduct,
      'jumlah': item.jumlah,
      'subtotal': item.subtotal,
      'product_id': item.productId,
      'order_id': item.orderId,
    };
  }
}
