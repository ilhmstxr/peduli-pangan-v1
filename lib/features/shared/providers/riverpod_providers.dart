import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

/// Generic UI flags
final isLoadingProvider = StateProvider<bool>((ref) => false);

/// Cart count example (adjust to your app's data layer)
final cartCountProvider = StateProvider<int>((ref) => 0);

/// Selected category on Home
final selectedCategoryIndexProvider = StateProvider<int>((ref) => 0);

/// Favorite restaurant ids (demo)
final favoriteRestaurantIdsProvider = StateNotifierProvider<_FavoriteIds, Set<int>>(
  (ref) => _FavoriteIds(),
);
class _FavoriteIds extends StateNotifier<Set<int>> {
  _FavoriteIds(): super(<int>{});
  void toggle(int id) {
    final s = Set<int>.from(state);
    if (s.contains(id)) { s.remove(id); } else { s.add(id); }
    state = s;
  }
}

/// Camera Controller via Riverpod
final availableCamerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  final cams = await availableCameras();
  return cams;
});

class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final bool isTorchOn;
  const CameraState({this.controller, this.isInitialized=false, this.isTorchOn=false});
  CameraState copyWith({CameraController? controller, bool? isInitialized, bool? isTorchOn}) =>
    CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isTorchOn: isTorchOn ?? this.isTorchOn,
    );
}

final cameraControllerProvider = AsyncNotifierProvider<CameraControllerNotifier, CameraState>(() => CameraControllerNotifier());

class CameraControllerNotifier extends AsyncNotifier<CameraState> {
  CameraController? _controller;
  @override
  Future<CameraState> build() async {
    final cams = await ref.watch(availableCamerasProvider.future);
    if (cams.isEmpty) return const CameraState(isInitialized: false);
    _controller = CameraController(cams.first, ResolutionPreset.high);
    await _controller!.initialize();
    return CameraState(controller: _controller, isInitialized: true, isTorchOn: false);
  }

  Future<void> toggleTorch() async {
    final current = state.asData?.value ?? const CameraState();
    if (current.controller == null) return;
    try {
      if (current.controller!.value.isInitialized) {
        await current.controller!.setFlashMode(
          current.isTorchOn ? FlashMode.off : FlashMode.torch
        );
        state = AsyncData(current.copyWith(isTorchOn: !current.isTorchOn));
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}


/// ======= Domain Models (simple/dummy for wiring) =======
class Order {
  final int id;
  final double total;
  final String status; // pending, paid, shipped, done, failed
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({int? id, double? total, String? status, DateTime? createdAt}) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// ======= Orders Controller (in-memory demo) =======
final ordersControllerProvider =
    StateNotifierProvider<OrdersController, List<Order>>(
  (ref) => OrdersController(),
);

class OrdersController extends StateNotifier<List<Order>> {
  OrdersController() : super(const <Order>[]);

  int _nextId = 1;

  void addOrder(double total) {
    final order = Order(
      id: _nextId++,
      total: total,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    state = [...state, order];
  }

  void updateStatus(int id, String status) {
    state = [
      for (final o in state) if (o.id == id) o.copyWith(status: status) else o
    ];
  }

  Order? byId(int id) => state.where((o) => o.id == id).cast<Order?>().firstWhere((e) => true, orElse: () => null);
}

/// Derived providers
final ordersProvider = Provider<List<Order>>((ref) {
  return ref.watch(ordersControllerProvider);
});

final orderByIdProvider = Provider.family<Order?, int>((ref, id) {
  final orders = ref.watch(ordersControllerProvider);
  for (final o in orders) {
    if (o.id == id) return o;
  }
  return null;
});
