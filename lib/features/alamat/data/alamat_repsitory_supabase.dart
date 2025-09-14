import 'package:supabase_flutter/supabase_flutter.dart';
import 'alamat_model.dart';
import 'alamat_repository.dart';

class AlamatRepositorySupabase implements AlamatRepository {
  final SupabaseClient client;

  AlamatRepositorySupabase(this.client);

  @override
  Future<List<Alamat>> getAlamates(int userId) async {
    final response = await client
        .from('alamat')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Alamat.fromJson(e)).toList();
  }

  @override
  Future<Alamat?> getAlamatById(int id) async {
    final response =
        await client.from('alamat').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return Alamat.fromJson(response);
  }

  @override
  Future<void> addAlamat(Alamat alamat) async {
    await client.from('alamat').insert(alamat.toJson());
  }

  @override
  Future<void> updateAlamat(Alamat alamat) async {
    await client
        .from('alamat')
        .update(alamat.toJson())
        .eq('id', alamat.id);
  }

  @override
  Future<void> deleteAlamat(int id) async {
    await client.from('alamat').delete().eq('id', id);
  }
}
