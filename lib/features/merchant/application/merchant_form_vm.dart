// application/merchant_form_vm.dart
import '../data/merchant_model.dart';
import '../data/merchant_repository.dart';

class MerchantFormVm {
  final MerchantRepository repo;

  bool _submitting = false;
  String? _error;

  bool get submitting => _submitting;
  String? get error => _error;

  MerchantFormVm(this.repo);

  Future<Merchant?> create({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    _submitting = true;
    _error = null;
    try {
      final created = await repo.createMerchant(
        userId: userId,
        namaToko: namaToko,
        deskripsi: deskripsi,
        rating: rating,
      );
      return created;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _submitting = false;
    }
  }

  Future<Merchant?> update(Merchant merchant) async {
    _submitting = true;
    _error = null;
    try {
      final updated = await repo.updateMerchant(merchant);
      return updated;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _submitting = false;
    }
  }
}
