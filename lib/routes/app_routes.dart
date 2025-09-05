import 'package:flutter/material.dart';
import '../presentation/homepage/scan2.dart';
import '../presentation/restaurant_detail_screen_new/restaurant_detail_screen_new.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/restaurant_detail_screen/restaurant_detail_screen.dart';
import '../presentation/auth/login.dart';
import '../presentation/auth/register.dart';
import '../presentation/homepage/scan.dart';
import '../presentation/homepage/food_description.dart';

class AppRoutes {
  // 4. Ubah nilai 'initial' ke rute halaman scan
  static const String initial = home;

  // Rute yang sudah ada
  // static const String start = '/';
  static const String home = '/home-screen';
  static const String restaurantDetail = '/restaurant-detail-screen';
  static const String restaurantDetailnew = '/restaurant-detail-screen-new';

  // 2. Definisikan nama rute untuk halaman baru Anda
  static const String login = '/login-page';
  static const String register = '/register-page';
  static const String scan = '/scan-page';
  static const String scan2 = '/scan-page-2';
  static const String foodDescription = '/food-description-page';

  static Map<String, WidgetBuilder> routes = {
    // Rute yang sudah ada
    home: (context) => const HomeScreen(),
    restaurantDetail: (context) => const RestaurantDetailScreen(),
    restaurantDetailnew: (context) => const RestaurantDetailScreenNew(),

    // 3. Tambahkan rute baru Anda di sini
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    scan: (context) => const ScanPage(),
    scan2: (context) => const ScanPage2(),
    foodDescription: (context) => const FoodDescriptionPage(),

    // Rute '/' sekarang bisa dihapus atau diarahkan ke home jika perlu
    // karena 'initial' sudah diganti.
    // initial: (context) => const HomeScreen(),
  };
}
