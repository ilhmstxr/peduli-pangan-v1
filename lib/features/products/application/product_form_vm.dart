import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/data/product_model.dart';
import '../../products/data/product_repository_supabase.dart';
import '../../products/data/product_repository.dart';

class ProductFormState {
  final bool submitting;
  final String? error;
  final Product? result;
  const ProductFormState({this.submitting = false, this.error, this.result});

  ProductFormState copyWith({bool? submitting, String? error, Product? result, bool clearError = false}) =>
      ProductFormState(
        submitting: submitting ?? this.submitting,
        error: clearError ? null : (error ?? this.error),
        result: result ?? this.result,
      );
}

final productFormVMProvider =
    NotifierProvider<ProductFormVM, ProductFormState>(ProductFormVM.new);

class ProductFormVM extends Notifier<ProductFormState> {
  late final ProductRepository _repo = ref.read(productRepositoryProvider);

  @override
  ProductFormState build() => const ProductFormState();

  String? _validate(Product p) {
    if (p.name.trim().isEmpty) return 'Nama wajib diisi';
    if (p.slug.trim().isEmpty) return 'Slug wajib diisi';
    if (p.price < 0) return 'Harga tidak valid';
    if (p.stock < 0) return 'Stok tidak valid';
    return null;
    }

  Future<Product?> create(Product p) async {
    final err = _validate(p);
    if (err != null) {
      state = state.copyWith(error: err);
      return null;
    }
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final res = await _repo.create(p);
      state = state.copyWith(submitting: false, result: res);
      return res;
    } catch (e) {
      state = state.copyWith(submitting: false, error: '$e');
      return null;
    }
  }

  Future<Product?> update(int id, Product p) async {
    final err = _validate(p);
    if (err != null) {
      state = state.copyWith(error: err);
      return null;
    }
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final res = await _repo.update(id, p);
      state = state.copyWith(submitting: false, result: res);
      return res;
    } catch (e) {
      state = state.copyWith(submitting: false, error: '$e');
      return null;
    }
  }
}
