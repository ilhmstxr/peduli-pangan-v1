import '../shared/helpers/helper.dart';

// pemesanan (orders)
class Pemesanan {
  final int id;
  final String orderNumber;
  final int userId;
  final int merchantId;
  final int addressId;
  final String status; // varchar(30)
  final num subtotal; // decimal(13,2)
  final num shippingFee; // decimal(13,2)
  final num total; // decimal(13,2)
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Pemesanan({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.merchantId,
    required this.addressId,
    required this.status,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory Pemesanan.fromMap(Map<String, dynamic> m) => Pemesanan(
        id: m['id'] as int,
        orderNumber: m['order_number'] as String,
        userId: m['user_id'] as int,
        merchantId: m['merchant_id'] as int,
        addressId: m['address_id'] as int,
        status: m['status'] as String,
        subtotal: toNum(m['subtotal']) ?? 0,
        shippingFee: toNum(m['shipping_fee']) ?? 0,
        total: toNum(m['total']) ?? 0,
        note: cast<String>(m['note']),
        createdAt: toDate(m['created_at']),
        updatedAt: toDate(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_number': orderNumber,
        'user_id': userId,
        'merchant_id': merchantId,
        'address_id': addressId,
        'status': status,
        'subtotal': subtotal,
        'shipping_fee': shippingFee,
        'total': total,
        'note': note,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

