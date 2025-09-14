// Order Item Model
class OrderItemModel {
  final String id;
  final DateTime createdAt;
  final String namaProduct;
  final double hargaProduct;
  final int jumlah;
  final double subtotal;
  final String productId;
  final String orderId;

  OrderItemModel({
    required this.id,
    required this.createdAt,
    required this.namaProduct,
    required this.hargaProduct,
    required this.jumlah,
    required this.subtotal,
    required this.productId,
    required this.orderId,
  });
}
