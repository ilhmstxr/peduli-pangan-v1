// Order Model
class OrderModel {
  final String id;
  final String status;
  final DateTime createdAt;
  final String orderNumber;
  final double total;
  final double subtotal;
  final String? note;
  final DateTime? updatedAt;
  final String userId;
  final String merchantId;
  final String alamatId;

  OrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.orderNumber,
    required this.total,
    required this.subtotal,
    this.note,
    this.updatedAt,
    required this.userId,
    required this.merchantId,
    required this.alamatId,
  });
}
