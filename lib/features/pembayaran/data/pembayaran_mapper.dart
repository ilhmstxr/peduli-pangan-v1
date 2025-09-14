// Mapper untuk Pembayaran
import 'pembayaran_model.dart';

class PembayaranMapper {
  static PembayaranModel fromMap(Map<String, dynamic> map) {
    return PembayaranModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      paidAmmount: (map['paid_ammount'] as num).toDouble(),
      method: map['method'] as String,
      status: map['status'] as String,
      providerRef: map['provider_ref'] as String?,
      paidAt: map['paid_at'] != null ? DateTime.parse(map['paid_at'] as String) : null,
      orderId: map['order_id'] as String,
    );
  }

  static Map<String, dynamic> toMap(PembayaranModel pembayaran) {
    return {
      'id': pembayaran.id,
      'created_at': pembayaran.createdAt.toIso8601String(),
      'paid_ammount': pembayaran.paidAmmount,
      'method': pembayaran.method,
      'status': pembayaran.status,
      'provider_ref': pembayaran.providerRef,
      'paid_at': pembayaran.paidAt?.toIso8601String(),
      'order_id': pembayaran.orderId,
    };
  }
}
