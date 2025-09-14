import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../restaurant/controllers/favorites_controller.dart';
import '../../restaurant/controllers/restaurant_detail_controller.dart';
import '../../restaurant/domain/models.dart';
import 'widgets/restaurant_info_card.dart';
import 'widgets/food_list_section.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantId});
  final int restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(restaurantDetailProvider(restaurantId));
    final favIds = ref.watch(favoriteRestaurantIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Resto #$restaurantId'),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(favoriteRestaurantIdsProvider.notifier)
                .toggle(restaurantId),
            icon: Icon(
              favIds.contains(restaurantId)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favIds.contains(restaurantId) ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat: $e'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref
                    .read(restaurantDetailProvider(restaurantId).notifier)
                    .refresh(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (r) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RestaurantInfoCard(
              name: r.name,
              address: r.address,
              rating: r.rating,
              isFavorite: favIds.contains(restaurantId),
              onToggleFavorite: () => ref
                  .read(favoriteRestaurantIdsProvider.notifier)
                  .toggle(restaurantId),
            ),
            const SizedBox(height: 16),
            FoodListSection(
              items: r.menus,
              onAddToCart: (FoodItem item) {
                // Di step Cart nanti kita sambungkan ke cart controller.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} ditambahkan')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
