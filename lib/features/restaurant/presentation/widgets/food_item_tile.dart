import 'package:flutter/material.dart';
import '../../../restaurant/domain/models.dart';

class FoodItemTile extends StatelessWidget {
  const FoodItemTile({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  final FoodItem item;
  final void Function(FoodItem item) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Rp ${item.price}'),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () => onAddToCart(item),
      ),
    );
  }
}
