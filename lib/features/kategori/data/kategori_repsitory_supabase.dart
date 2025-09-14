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
    final filter = <String, String>{};

    if (search != null && search.trim().isNotEmpty) {
      filter['name'] = 'ilike.%${search.trim()}%';
    }
    if (parentId != null) {
      filter['parent_id'] = 'eq.$parentId';
    }

    final rows = await client
        .from(KategoriMapper.table)
        .select()
        .withFilters(filter)
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
