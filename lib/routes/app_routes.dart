import 'package:flutter/material.dart';
import '../presentation/homepage/scan2.dart';
import '../presentation/restaurant_detail_screen_new/restaurant_detail_screen_new.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/restaurant_detail_screen/restaurant_detail_screen.dart';
import '../presentation/auth/login.dart';
import '../presentation/auth/register.dart';
import '../presentation/homepage/scan.dart';
import '../presentation/homepage/food_description.dart';
import '../presentation/transaction_detail_screen.dart';
import '../presentation/order_screen.dart';
import '../presentation/history_screen.dart';

// routes
import '../features/auth/pengguna_routes.dart';
import '../features/alamat/alamat_routes.dart';
import '../features/cart/cart_routes.dart';
import '../features/kategori/kategori_routes.dart';
import '../features/merchant/merchant_routes.dart';
import '../features/order/order_routes.dart';
import '../features/pembayaran/pembayaran_routes.dart';
import '../features/produk/product_routes.dart';
import '../features/review/review_routes.dart';
import '../core/feature_route.dart';

class AppRoutes {
  static const String initial = register;

  // ================================================================
  // >> Konstanta Nama Rute (Static)
  // ================================================================
  // static const String home = '/home-screen';
  // static const String restaurantDetail = '/restaurant-detail-screen';
  // static const String restaurantDetailnew = '/restaurant-detail-screen-new';
  // static const String login = '/login-page';
  // static const String register = '/register-page';
  // static const String scan = '/scan-page';
  // static const String scan2 = '/scan-page-2';
  // static const String foodDescription = '/food-description-page';
  // static const String transactionDetail = '/transaction-detail-screen';
  // static const String order = '/order-screen';
  // static const String history = '/history-screen';
  //  static const String profile = '/profile';
  // static const String editProfile = '/edit-profile';

  // ================================================================
  // >> Definisi Rute Statis
  // ================================================================
  static final Map<String, WidgetBuilder> routes = {
    // Rute yang tidak memerlukan argumen
    // home: (context) => const HomeScreen(),
    // transactionDetail: (context) => const TransactionDetailScreen(),
    // order: (context) => const OrderScreen(),
    // history: (context) => const HistoryScreen(),
    // restaurantDetailnew: (context) => const RestaurantDetailScreenNew(),
    // login: (context) => const LoginPage(),
    // register: (context) => const RegisterPage(),
    // scan: (context) => const ScanPage(),
    // scan2: (context) => const ScanPage2(),
    // foodDescription: (context) => const FoodDescriptionPage(),
    // profile: (context) => const ProfileScreen(),
    // editProfile: (context) => const EditProfileScreen(),
    // restaurantDetail: (context) => const RestaurantDetailScreen(),
  };

  // ================================================================
  // >> Boilerplate untuk Rute Dinamis (Feature-based)
  // ================================================================

  /// Daftar semua modul rute dari setiap fitur
  static final List<FeatureRoute> _featureRoutes = [
    UserRoutes(),
    AlamatRoutes(),
    CartRoutes(),
    KategoriRoutes(),
    MerchantRoutes(),
    OrderRoutes(),
    PembayaranRoutes(),
    ProductRoutes(),
    ReviewRoutes(),
    // Tambahkan feature route lain di sini 
  ];

  /// Fungsi ini akan dipanggil oleh MaterialApp jika rute tidak ditemukan
  /// di dalam map `routes` di atas. Berguna untuk rute yang memerlukan argumen.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Mencari rute yang cocok dari setiap modul fitur
    for (final feature in _featureRoutes) {
      final route = feature.onGenerateRoute(settings);
      if (route != null) return route;
    }

    // Fallback jika rute tidak ditemukan sama sekali
    return MaterialPageRoute(
      builder: (_) => const _UnknownRouteScreen(),
      settings: settings,
    );
  }
}

/// Halaman yang ditampilkan jika rute tidak ditemukan
class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Route tidak ditemukan')),
    );
  }
}
