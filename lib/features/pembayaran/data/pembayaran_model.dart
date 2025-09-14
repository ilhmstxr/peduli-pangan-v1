// Model untuk Pembayaran
class PembayaranModel {
  final String id;
  final DateTime createdAt;
  final double paidAmmount;
  final String method;
  final String status;
  final String? providerRef;
  final DateTime? paidAt;
  final String orderId;

  PembayaranModel({
    required this.id,
    required this.createdAt,
    required this.paidAmmount,
    required this.method,
    required this.status,
    this.providerRef,
    this.paidAt,
    required this.orderId,
  });
}
