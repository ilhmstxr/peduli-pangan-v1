
// lib/services/merchant_service.dart
// Revisi: tambah CRUD lengkap + filter/query util

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/merchant.dart';

class MerchantService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Merchant>> getMerchantsWithProducts() async {
    final response = await _supabase
        .from('merchants')
        .select('*, products(*)')
        .order('id', ascending: true);
    return (response as List).map((e) => Merchant.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Merchant> getMerchantById(int id) async {
    final response = await _supabase
        .from('merchants')
        .select('*, products(*)')
        .eq('id', id)
        .single();
    return Merchant.fromJson(response as Map<String, dynamic>);
  }

  Future<List<Merchant>> searchMerchantsByName(String keyword) async {
    final response = await _supabase
        .from('merchants')
        .select('*, products(*)')
        .ilike('nama_toko', '%$keyword%')
        .order('nama_toko', ascending: true);
    return (response as List).map((e) => Merchant.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Merchant> createMerchant({
    required int userId,
    required String namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    final now = DateTime.now().toIso8601String();
    final payload = {
      'user_id': userId,
      'nama_toko': namaToko,
      'deskripsi': deskripsi,
      'rating': rating,
      'created_at': now,
      'updated_at': now,
    };

    final inserted = await _supabase
        .from('merchants')
        .insert(payload)
        .select('*, products(*)')
        .single();

    return Merchant.fromJson(inserted as Map<String, dynamic>);
  }

  Future<Merchant> updateMerchant({
    required int id,
    String? namaToko,
    String? deskripsi,
    double? rating,
  }) async {
    final payload = <String, dynamic>{
      if (namaToko != null) 'nama_toko': namaToko,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (rating != null) 'rating': rating,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final updated = await _supabase
        .from('merchants')
        .update(payload)
        .eq('id', id)
        .select('*, products(*)')
        .single();

    return Merchant.fromJson(updated as Map<String, dynamic>);
  }

  Future<void> deleteMerchant(int id) async {
    await _supabase.from('merchants').delete().eq('id', id);
  }
}
