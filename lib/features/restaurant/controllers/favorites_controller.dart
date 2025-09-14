import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Set<int> berisi id restoran favorit
final favoriteRestaurantIdsProvider =
    NotifierProvider<FavoriteRestaurantIds, Set<int>>(
  FavoriteRestaurantIds.new,
);

class FavoriteRestaurantIds extends Notifier<Set<int>> {
  @override
  Set<int> build() => <int>{};

  void toggle(int id) {
    final next = Set<int>.from(state);
    next.contains(id) ? next.remove(id) : next.add(id);
    state = next;
  }

  bool isFav(int id) => state.contains(id);
}
