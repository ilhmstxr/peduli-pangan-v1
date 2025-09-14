import 'package:flutter/material.dart';

class RestaurantInfoCard extends StatelessWidget {
  const RestaurantInfoCard({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final String name;
  final String address;
  final double rating;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('$address • ⭐ $rating'),
        trailing: IconButton(
          onPressed: onToggleFavorite,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          color: isFavorite ? Colors.red : null,
        ),
      ),
    );
  }
}
