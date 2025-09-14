
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/providers/riverpod_providers.dart';

class FoodDescriptionScreen extends ConsumerWidget {
  final int foodId;
  const FoodDescriptionScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartCountProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Menu #$foodId')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deskripsi makanan, komposisi, alergi, dsb.'),
            const SizedBox(height: 12),
            Text('Item di keranjang: $cart'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => ref.read(cartCountProvider.notifier).state++,
                icon: const Icon(Icons.add),
                label: const Text('Tambah ke keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
