// Order Repository Abstract
abstract class OrderRepository {
  Future<List<OrderModel>> fetchOrders();
  Future<OrderModel?> getOrderById(String id);
  Future<void> createOrder(OrderModel order);
  Future<void> updateOrder(OrderModel order);
  Future<void> deleteOrder(String id);
}
