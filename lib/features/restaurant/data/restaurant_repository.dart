import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/providers/supabase_providers.dart';
import '../domain/models.dart';

/// Kontrak repositori
abstract class RestaurantRepository {
  Future<Restaurant> fetchDetail(int id);
}

/// Implementasi: Supabase (gampang dipasang mock juga)
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseRestaurantRepository(client);
});

class SupabaseRestaurantRepository implements RestaurantRepository {
  SupabaseRestaurantRepository(this.client);
  final SupabaseClient client;

  @override
  Future<Restaurant> fetchDetail(int id) async {
    // TODO: sesuaikan nama tabel/kolom di project kamu
    // Contoh (komentari dulu bila skema berbeda):
    /*
    final restoResp = await client
        .from('restaurants')
        .select('id, name, address, rating')
        .eq('id', id)
        .maybeSingle();

    final menuResp = await client
        .from('menus')
        .select('id, name, price')
        .eq('restaurant_id', id);

    final menus = (menuResp as List<dynamic>).map((e) => FoodItem(
      id: e['id'] as int,
      name: e['name'] as String,
      price: e['price'] as int,
    )).toList();

    final r = restoResp!;
    return Restaurant(
      id: r['id'] as int,
      name: r['name'] as String,
      address: r['address'] as String,
      rating: (r['rating'] as num).toDouble(),
      menus: menus,
    );
    */

    // ===== MOCK sementara (jalan tanpa DB) =====
    await Future.delayed(const Duration(milliseconds: 300));
    return Restaurant(
      id: id,
      name: 'Resto #$id',
      address: 'Jl. Makan Enak No. $id',
      rating: 4.6,
      menus: const [
        FoodItem(id: 1, name: 'Nasi Goreng', price: 18000),
        FoodItem(id: 2, name: 'Sate Ayam', price: 22000),
        FoodItem(id: 3, name: 'Mie Goreng', price: 16000),
      ],
    );
  }
}
