class FoodItem {
  final int id;
  final String name;
  final int price; // dalam rupiah
  const FoodItem({required this.id, required this.name, required this.price});
}

class Restaurant {
  final int id;
  final String name;
  final String address;
  final double rating;
  final List<FoodItem> menus;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.menus,
  });
}
