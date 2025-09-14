import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/data/product_model.dart';
import '../../products/data/product_repository_supabase.dart';
import '../../products/data/product_repository.dart';

final productDetailVMProvider =
    AsyncNotifierProvider<ProductDetailVM, AsyncValue<Product?>>(
  ProductDetailVM.new,
);

class ProductDetailVM extends AsyncNotifier<AsyncValue<Product?>> {
  late final ProductRepository _repo = ref.read(productRepositoryProvider);

  @override
  Future<AsyncValue<Product?>> build() async {
    // Tidak memuat apa pun di awal; tunggu dipanggil fetch(id)
    return const AsyncData(null);
  }

  Future<void> fetch(int id) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() async => AsyncData(await _repo.getById(id)));
  }

  Future<void> refresh(int id) async => fetch(id);
}
