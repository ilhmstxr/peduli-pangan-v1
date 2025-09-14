import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_model.dart';
import '../data/product_repository.dart';
import '../data/product_repository_supabase.dart';

final productDetailVMProvider =
    AsyncNotifierProvider<ProductDetailVM, Product?>(
  ProductDetailVM.new,
);

class ProductDetailVM extends AsyncNotifier<Product?> {
  late final ProductRepository _repo = ref.read(productRepositoryProvider);

  @override
  Future<Product?> build() async => null;

  Future<void> fetch(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getById(id));
  }

  Future<void> refresh(int id) => fetch(id);
}
