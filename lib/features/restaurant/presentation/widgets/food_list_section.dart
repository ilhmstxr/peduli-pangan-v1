import 'package:flutter/material.dart';
import '../../../restaurant/domain/models.dart';
import 'food_item_tile.dart';

class FoodListSection extends StatelessWidget {
  const FoodListSection({
    super.key,
    required this.items,
    required this.onAddToCart,
  });

  final List<FoodItem> items;
  final void Function(FoodItem item) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          FoodItemTile(item: item, onAddToCart: onAddToCart),
      ],
    );
  }
}
