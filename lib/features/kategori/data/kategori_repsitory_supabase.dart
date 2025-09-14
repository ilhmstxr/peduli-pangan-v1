import 'package:supabase_flutter/supabase_flutter.dart';
import 'kategori_mapper.dart';
import 'kategori_model.dart';
import 'kategori_repository.dart';

class KategoriRepositorySupabase implements KategoriRepository {
  final SupabaseClient client;

  const KategoriRepositorySupabase(this.client);

  @override
  Future<List<Kategori>> list({
    String? search,
    int? parentId,
    int limit = 50,
    int offset = 0,
  }) async {
    // Penting: ketik eksplisit PostgrestFilterBuilder
    PostgrestFilterBuilder query = client.from(KategoriMapper.table).select();

    if (search != null && search.trim().isNotEmpty) {
      query = query.ilike(KategoriMapper.colName, '%${search.trim()}%');
    }
    if (parentId != null) {
      query = query.eq(KategoriMapper.colParentId, parentId);
    }

    final rows = await query
        .order(KategoriMapper.colId, ascending: true)
        .range(offset, offset + limit - 1);

    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(KategoriMapper.fromRow)
        .toList();
  }

  @override
  Future<Kategori?> getById(int id) async {
    final rows = await client
        .from(KategoriMapper.table)
        .select()
        .eq(KategoriMapper.colId, id)
        .maybeSingle();
    if (rows == null) return null;
    return KategoriMapper.fromRow(rows as Map<String, dynamic>);
  }

  @override
  Future<Kategori> create(KategoriInput input) async {
    final inserted = await client
        .from(KategoriMapper.table)
        .insert(KategoriMapper.toInsert(input))
        .select()
        .single();
    return KategoriMapper.fromRow(inserted as Map<String, dynamic>);
  }

  @override
  Future<Kategori> update(int id, KategoriInput input) async {
    final updated = await client
        .from(KategoriMapper.table)
        .update(KategoriMapper.toUpdate(input))
        .eq(KategoriMapper.colId, id)
        .select()
        .single();
    return KategoriMapper.fromRow(updated as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await client
        .from(KategoriMapper.table)
        .delete()
        .eq(KategoriMapper.colId, id);
  }
}
