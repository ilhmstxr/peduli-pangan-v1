import '../shared/helpers/helper.dart';


// pembayaran
class Pembayaran {
  final int id;
  final int orderId;
  final num paidAmount;
  final String method; // varchar(50)
  final String status; // varchar(30)
  final String? providerRef; // varchar(255)
  final DateTime? paidAt;
  final DateTime? createdAt;

  const Pembayaran({
    required this.id,
    required this.orderId,
    required this.paidAmount,
    required this.method,
    required this.status,
    this.providerRef,
    this.paidAt,
    this.createdAt,
  });

  factory Pembayaran.fromMap(Map<String, dynamic> m) => Pembayaran(
        id: m['id'] as int,
        orderId: m['order_id'] as int,
        paidAmount: toNum(m['paid_amount']) ?? 0,
        method: m['method'] as String,
        status: m['status'] as String,
        providerRef: cast<String>(m['provider_ref']),
        paidAt: toDate(m['paid_at']),
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'paid_amount': paidAmount,
        'method': method,
        'status': status,
        'provider_ref': providerRef,
        'paid_at': paidAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };
}