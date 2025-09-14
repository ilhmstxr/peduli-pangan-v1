import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/restaurant_repository.dart';
import '../domain/models.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepository();
});

// Provider family (perhatikan urutan generik <Notifier, Out, Arg>)
final restaurantDetailProvider =
    AsyncNotifierProvider.family<RestaurantDetailController, Restaurant, int>(
  RestaurantDetailController.new,
);

// Notifier family
final class RestaurantDetailController
    extends FamilyAsyncNotifier<Restaurant, int> {
  late final RestaurantRepository _repo =
      ref.read(restaurantRepositoryProvider);

  @override
  Future<Restaurant> build(int restaurantId) async {
    return _repo.fetchDetail(restaurantId);
  }

  Future<void> refresh() async {
    // Dapatkan restaurantId saat ini dari argumen family
    final restaurantId = arg;
    // Set state ke loading
    state = const AsyncLoading();
    // Muat ulang data dan perbarui state
    state = await AsyncValue.guard(() => build(restaurantId));
  }
}
