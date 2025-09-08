import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/restaurant_detail_screen/restaurant_detail_screen.dart';
import '../presentation/transaction_detail_screen.dart';
import '../presentation/order_screen.dart';
import '../presentation/history_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String home = '/home-screen';
  static const String restaurantDetail = '/restaurant-detail-screen';
  static const String transactionDetail = '/transaction-detail-screen';
  static const String order = '/order-screen';
  static const String history = '/history-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    home: (context) => const HomeScreen(),
    restaurantDetail: (context) => const RestaurantDetailScreen(),
    transactionDetail: (context) => const TransactionDetailScreen(),
    order: (context) => const OrderScreen(),
    history: (context) => const HistoryScreen(),
    // TODO: Add your other routes here
  };
}
