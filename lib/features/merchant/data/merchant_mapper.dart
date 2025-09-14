// data/merchant_mapper.dart
import 'merchant_model.dart';

/// Mapper util jika kamu ingin memisahkan peta JSON DB (snake_case)
/// ke domain model, dan sebaliknya.
/// Supabase sudah mengembalikan snake_case, jadi ini mostly sugar.
class MerchantMapper {
  static Merchant fromDb(Map<String, dynamic> row) => Merchant.fromJson(row);

  static Map<String, dynamic> toInsert({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  }) {
    return {
      'user_id': userId,
      'nama_toko': namaToko,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (rating != null) 'rating': rating,
    };
  }

  static Map<String, dynamic> toUpdate(Merchant m) {
    return {
      'user_id': m.userId,
      'nama_toko': m.namaToko,
      'deskripsi': m.deskripsi,
      'rating': m.rating,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
