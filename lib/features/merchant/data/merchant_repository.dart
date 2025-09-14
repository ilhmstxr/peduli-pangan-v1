// data/merchant_repository.dart
import '../application/merchant_filters.dart';
import 'merchant_model.dart';

abstract class MerchantRepository {
  /// List + filter + sort + pagination
  Future<List<Merchant>> listMerchants(MerchantFilters filters);

  /// Detail by id
  Future<Merchant?> getMerchant(int id);

  /// Create: return created row (with id)
  Future<Merchant> createMerchant({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  });

  /// Update full entity (by id)
  Future<Merchant> updateMerchant(Merchant merchant);

  /// Partial update (fields only)
  Future<Merchant> patchMerchant(int id, Map<String, dynamic> fields);

  /// Delete by id
  Future<void> deleteMerchant(int id);
}
