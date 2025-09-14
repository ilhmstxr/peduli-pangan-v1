// lib/services/kategori_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori.dart';

class KategoriService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Kategori>> getAll() async {
    final response = await _supabase.from('kategori').select('*').order('id');
    return (response as List)
        .map((e) => Kategori.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Kategori> getById(int id) async {
    final response =
        await _supabase.from('kategori').select('*').eq('id', id).single();
    return Kategori.fromJson(response as Map<String, dynamic>);
  }

  Future<Kategori> create({
    required String name,
    required String slug,
    int? parentId,
  }) async {
    final payload = {
      'name': name,
      'slug': slug,
      'parent_id': parentId,
      'created_at': DateTime.now().toIso8601String(),
    };
    final inserted =
        await _supabase.from('kategori').insert(payload).select('*').single();
    return Kategori.fromJson(inserted as Map<String, dynamic>);
  }

  Future<Kategori> update({
    required int id,
    String? name,
    String? slug,
    int? parentId,
  }) async {
    final payload = <String, dynamic>{
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (parentId != null) 'parent_id': parentId,
    };
    final updated =
        await _supabase.from('kategori').update(payload).eq('id', id).select('*').single();
    return Kategori.fromJson(updated as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _supabase.from('kategori').delete().eq('id', id);
  }
}
