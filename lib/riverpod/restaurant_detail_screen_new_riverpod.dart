
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/providers/riverpod_providers.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final int restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteRestaurantIdsProvider);
    final isFav = favorites.contains(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resto #$restaurantId'),
        actions: [
          IconButton(
            onPressed: () => ref.read(favoriteRestaurantIdsProvider.notifier).toggle(restaurantId),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail restoran, alamat, jam buka, dsb.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.read(cartCountProvider.notifier).state++,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Tambah menu ke keranjang (demo)'),
            ),
          ],
        ),
      ),
    );
  }
}
