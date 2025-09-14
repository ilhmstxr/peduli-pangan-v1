import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/alamat_model.dart';
import '../data/alamat_repository.dart';

class AlamatListVM extends StateNotifier<AsyncValue<List<Alamat>>> {
  final AlamatRepository repository;
  final int userId;

  AlamatListVM(this.repository, this.userId)
      : super(const AsyncValue.loading()) {
    loadAlamates();
  }

  Future<void> loadAlamates() async {
    try {
      final alamates = await repository.getAlamates(userId);
      state = AsyncValue.data(alamates);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
