import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/restaurant_detail_screen/restaurant_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String home = '/home-screen';
  static const String restaurantDetail = '/restaurant-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    home: (context) => const HomeScreen(),
    restaurantDetail: (context) => const RestaurantDetailScreen(),
    // TODO: Add your other routes here
  };
}
