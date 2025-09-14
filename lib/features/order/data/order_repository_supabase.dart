// Order Repository Implementation for Supabase
import 'order_model.dart';
import 'order_repository.dart';

class OrderRepositorySupabase implements OrderRepository {
  @override
  Future<List<OrderModel>> fetchOrders() async {
    // TODO: Implement fetch from Supabase
    return [];
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    // TODO: Implement fetch by id from Supabase
    return null;
  }

  @override
  Future<void> createOrder(OrderModel order) async {
    // TODO: Implement create order in Supabase
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    // TODO: Implement update order in Supabase
  }

  @override
  Future<void> deleteOrder(String id) async {
    // TODO: Implement delete order in Supabase
  }
}
