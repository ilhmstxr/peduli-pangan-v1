// Order Mapper
import 'order_model.dart';

class OrderMapper {
  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      orderNumber: map['order_number'] as String,
      total: (map['total'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      note: map['note'] as String?,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
      userId: map['user_id'] as String,
      merchantId: map['merchant_id'] as String,
      alamatId: map['alamat_id'] as String,
    );
  }

  static Map<String, dynamic> toMap(OrderModel order) {
    return {
      'id': order.id,
      'status': order.status,
      'created_at': order.createdAt.toIso8601String(),
      'order_number': order.orderNumber,
      'total': order.total,
      'subtotal': order.subtotal,
      'note': order.note,
      'updated_at': order.updatedAt?.toIso8601String(),
      'user_id': order.userId,
      'merchant_id': order.merchantId,
      'alamat_id': order.alamatId,
    };
  }
}
