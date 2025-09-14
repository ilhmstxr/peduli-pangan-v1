import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/alamat_model.dart';
import '../data/alamat_repository.dart';

class AlamatFormVM extends StateNotifier<AsyncValue<void>> {
  final AlamatRepository repository;

  AlamatFormVM(this.repository) : super(const AsyncValue.data(null));

  Future<void> saveAlamat(Alamat alamat, {bool isEdit = false}) async {
    state = const AsyncValue.loading();
    try {
      if (isEdit) {
        await repository.updateAlamat(alamat);
      } else {
        await repository.addAlamat(alamat);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
