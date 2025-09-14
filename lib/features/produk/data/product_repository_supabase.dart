import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/errors/failures.dart';
import '../../shared/providers/supabase_providers.dart';
import 'product_model.dart';
import 'product_filters.dart';
import 'product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final sb = ref.read(supabaseClientProvider);
  return SupabaseProductRepository(sb);
});

class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository(this._sb);
  final SupabaseClient _sb;

  static const table = 'products';

  @override
  Future<List<Product>> list(ProductFilters f) async {
    try {
      // gunakan RPC untuk performa + konsistensi, fallback ke query biasa bila perlu
      final resp = await _sb
          .rpc('products_list', params: {
            'p_q': f.q,
            'p_category_id': f.categoryId,
            'p_only_active': f.onlyActive,
            'p_page_size': f.limit,
            'p_before': f.before?.toIso8601String(),
          })
          .select();

      final rows = (resp as List).cast<Map<String, dynamic>>();
      return rows.map(Product.fromMap).toList();
    } catch (e) {
      throw Failure('Gagal memuat produk', e);
    }
  }

  @override
  Future<Product?> getById(int id) async {
    try {
      final data = await _sb.from(table).select().eq('id', id).single();
      return Product.fromMap((data as Map<String, dynamic>));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null; // not found (single() no rows)
      throw Failure('Gagal mengambil produk', e);
    } catch (e) {
      throw Failure('Gagal mengambil produk', e);
    }
  }

  @override
  Future<Product> create(Product input) async {
    try {
      final inserted = await _sb
          .from(table)
          .insert(input.toInsertMap())
          .select()
          .single();

      return Product.fromMap((inserted as Map<String, dynamic>));
    } on PostgrestException catch (e) {
      // contoh khusus: unique violation slug
      if (e.message.contains('duplicate key value') && e.message.contains('slug')) {
        throw Failure('Slug sudah digunakan', e);
      }
      throw Failure('Gagal membuat produk', e);
    } catch (e) {
      throw Failure('Gagal membuat produk', e);
    }
  }

  @override
  Future<Product> update(int id, Product input) async {
    try {
      final updated = await _sb
          .from(table)
          .update(input.toUpdateMap())
          .eq('id', id)
          .select()
          .single();

      return Product.fromMap((updated as Map<String, dynamic>));
    } on PostgrestException catch (e) {
      if (e.message.contains('duplicate key value') && e.message.contains('slug')) {
        throw Failure('Slug sudah digunakan', e);
      }
      throw Failure('Gagal memperbarui produk', e);
    } catch (e) {
      throw Failure('Gagal memperbarui produk', e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _sb.from(table).delete().eq('id', id);
    } catch (e) {
      throw Failure('Gagal menghapus produk', e);
    }
  }
}
