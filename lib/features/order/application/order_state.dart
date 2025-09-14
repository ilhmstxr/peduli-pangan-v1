// Order State
import '../data/order_model.dart';

class OrderState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  OrderState({
    required this.orders,
    this.isLoading = false,
    this.error,
  });
}
