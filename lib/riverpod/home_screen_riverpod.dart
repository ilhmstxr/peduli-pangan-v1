
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/providers/riverpod_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    final selectedChip = ref.watch(selectedCategoryIndexProvider);
    final favorites = ref.watch(favoriteRestaurantIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food App'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // open cart
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = selectedChip == index;
                return ChoiceChip(
                  selected: selected,
                  label: Text('Cat $index'),
                  onSelected: (_) => ref.read(selectedCategoryIndexProvider.notifier).state = index,
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, i) {
                final id = i + 1;
                final isFav = favorites.contains(id);
                return ListTile(
                  title: Text('Restaurant $id'),
                  subtitle: const Text('Category • 1.2km • 20-30 min'),
                  trailing: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline, color: isFav ? Colors.red : null),
                    onPressed: () => ref.read(favoriteRestaurantIdsProvider.notifier).toggle(id),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
