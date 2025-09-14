// lib/features/users/data/user_repository_supabase.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import 'pengguna_mapper.dart';
import 'pengguna_model.dart';
import 'pengguna_repository.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._sb);
  final SupabaseClient _sb;

  static const _table = 'pengguna';

  /// Query dasar untuk LIST (banyak baris)
  PostgrestFilterBuilder _baseSelectList({bool includeDeleted = false}) {
    final q = _sb.from(_table).select();
    return includeDeleted ? q : q.isFilter('deleted_at', null);
  }

  /// Query dasar untuk SINGLE (satu baris)
  PostgrestFilterBuilder _baseSelect({bool includeDeleted = false}) {
    final q = _sb.from(_table).select();
    return includeDeleted ? q : q.isFilter('deleted_at', null);
  }

  @override
  Future<List<Pengguna>> list({
    int limit = 20,
    int offset = 0,
    String? query,
    bool includeDeleted = false,
    String? role,
  }) async {
    // Mulai dari FilterBuilder
    PostgrestFilterBuilder q = _baseSelectList(includeDeleted: includeDeleted);

    // Lakukan SEMUA filter di sini (masih FilterBuilder)
    if (query != null && query.trim().isNotEmpty) {
      final term = query.trim();
      q = q.or('name.ilike.%$term%,username.ilike.%$term%,email.ilike.%$term%');
    }
    if (role != null && role.isNotEmpty) {
      q = q.eq('role', role);
    }

    // Setelah filter selesai, baru transform (order/range)
    final t = (q as PostgrestTransformBuilder)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final rows = await t; // -> PostgrestList (List<dynamic>/List<Map>)
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(UserMapper.fromRow)
        .toList();
  }

  @override
  Future<Pengguna?> getById(int id, {bool includeDeleted = false}) async {
    var q = _sb.from(_table).select();
    if (!includeDeleted) q = q.isFilter('deleted_at', null);
    final row = await q.eq('id', id).maybeSingle(); // -> Map? (single)
    if (row == null) return null;
    return UserMapper.fromRow(row as Map<String, dynamic>);
  }

  @override
  Future<Pengguna?> getByEmail(String email,
      {bool includeDeleted = false}) async {
    final row = await _baseSelect(includeDeleted: includeDeleted)
        .ilike('email', email)
        .maybeSingle();
    if (row == null) return null;
    return UserMapper.fromRow(row as Map<String, dynamic>);
  }

  @override
  Future<Pengguna> create(Pengguna newUser) async {
    final payload = UserMapper.toInsert(newUser);
    final row = await _sb.from(_table).insert(payload).select().single();
    return UserMapper.fromRow(row as Map<String, dynamic>);
  }

  @override
  Future<Pengguna> update(int id, Pengguna user) async {
    final payload = UserMapper.toUpdate(user);
    final row =
        await _sb.from(_table).update(payload).eq('id', id).select().single();
    return UserMapper.fromRow(row as Map<String, dynamic>);
  }

  @override
  Future<void> softDelete(int id) async {
    await _sb
        .from(_table)
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id);
  }

  @override
  Future<void> restore(int id) async {
    await _sb.from(_table).update({'deleted_at': null}).eq('id', id);
  }
}

/// Provider repository untuk diinject ke VM.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final sb = ref.read(supabaseClientProvider);
  return SupabaseUserRepository(sb);
});
