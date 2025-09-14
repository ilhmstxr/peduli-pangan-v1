// data/merchant_repository_supabase.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../application/merchant_filters.dart';
import 'merchant_model.dart';
import 'merchant_repository.dart';
import 'merchant_mapper.dart';

class MerchantRepositorySupabase implements MerchantRepository {
  final SupabaseClient client;

  MerchantRepositorySupabase(this.client);

  @override
  Future<List<Merchant>> listMerchants(MerchantFilters filters) async {
    final table = client.from('merchants');
    dynamic q = table.select(); // select() -> Transform

    if ((filters.search ?? '').isNotEmpty) {
      final s = filters.search!;
      q = q.or('nama_toko.ilike.%$s%,deskripsi.ilike.%$s%'); // -> Filter
    }
    if (filters.minRating != null)
      q = q.gte('rating', filters.minRating!); // -> Filter
    if (filters.userId != null)
      q = q.eq('user_id', filters.userId!); // -> Filter

    switch (filters.orderBy ?? MerchantOrderBy.updatedAtDesc) {
      case MerchantOrderBy.ratingDesc:
        q = q.order('rating',
            ascending: false, nullsFirst: true); // -> Transform
        break;
      case MerchantOrderBy.ratingAsc:
        q = q.order('rating', ascending: true, nullsFirst: true);
        break;
      case MerchantOrderBy.createdAtDesc:
        q = q.order('created_at', ascending: false);
        break;
      case MerchantOrderBy.createdAtAsc:
        q = q.order('created_at', ascending: true);
        break;
      case MerchantOrderBy.updatedAtAsc:
        q = q.order('updated_at', ascending: true, nullsFirst: true);
        break;
      case MerchantOrderBy.updatedAtDesc:
        q = q.order('updated_at', ascending: false, nullsFirst: true);
        break;
    }

    if (filters.limit != null) {
      final from = ((filters.page ?? 1) - 1) * filters.limit!;
      final to = from + filters.limit! - 1;
      q = q.range(from, to); // tetap jalan meski tipe builder berubah
    }

    final rows = await q as List<dynamic>;
    return rows
        .cast<Map<String, dynamic>>()
        .map(MerchantMapper.fromDb)
        .toList();
  }

  @override
  Future<Merchant?> getMerchant(int id) async {
    final table = client.from('merchants');

    // pola seragam: select().eq(...).maybeSingle()
    final data = await table.select().eq('id', id).maybeSingle();
    if (data == null) return null;

    return MerchantMapper.fromDb(data as Map<String, dynamic>);
  }

  @override
  Future<Merchant> createMerchant({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    final table = client.from('merchants');

    // payload disiapkan via Mapper agar konsisten dengan pengguna_repository
    final payload = MerchantMapper.toInsert(
      userId: userId,
      namaToko: namaToko,
      deskripsi: deskripsi,
      rating: rating,
    );

    // pola: insert(payload).select().single()
    final inserted = await table.insert(payload).select().single();
    return MerchantMapper.fromDb(inserted as Map<String, dynamic>);
  }

  @override
  Future<Merchant> updateMerchant(Merchant merchant) async {
    final table = client.from('merchants');

    // pola update penuh (semua field relevan)
    final payload = MerchantMapper.toUpdate(merchant);

    final updated =
        await table.update(payload).eq('id', merchant.id).select().single();

    return MerchantMapper.fromDb(updated as Map<String, dynamic>);
  }

  @override
  Future<Merchant> patchMerchant(int id, Map<String, dynamic> fields) async {
    final table = client.from('merchants');

    // pola patch parsial (hanya fields yang dikirim)
    final updated = await table.update(fields).eq('id', id).select().single();
    return MerchantMapper.fromDb(updated as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMerchant(int id) async {
    final table = client.from('merchants');
    await table.delete().eq('id', id);
  }
}
