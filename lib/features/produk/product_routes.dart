import 'package:flutter/material.dart';
import 'package:pedulipanganv1/core/feature_route.dart';
// Jika project kamu pakai path lain, ganti import di atas sesuai modul routing-mu.

// ====== Ganti sesuai lokasi file layar ======
import 'presentation/product_list_screen.dart';
import 'presentation/product_detail_screen.dart';
// import 'presentation/product_form_screen.dart';

/// Routing untuk modul Produk:
/// - /produk                      -> daftar produk
/// - /produk/new                  -> create produk
/// - /produk/:id                  -> detail produk
/// - /produk/:id/edit             -> edit produk
class ProductRoutes implements FeatureRoute {
  static const root = '/produk';
  static const list = root;
  static const create = '$root/new';

  /// Helper untuk build path dinamis
  static String detailPath(Object id) => '$root/$id';
  static String editPath(Object id) => '$root/$id/edit';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

    // /produk  (list)
    if (name == root || name == list) {
      // Opsional: bisa kirim filter via settings.arguments (Map) atau query (?q=...)
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) =>
            ProductListScreen(args: args, queryParams: uri.queryParameters),
        settings: settings,
      );
    }

    // =========================
    // /produk/:id  -> DETAIL
    // =========================
    final segs = uri.pathSegments;
    if (segs.length >= 2 && segs.first == 'produk') {
      // ambil segmen ke-2 sebagai id (biarkan string agar fleksibel)
      final id = segs[1];
      final args = settings.arguments;

      return MaterialPageRoute(
        builder: (_) => ProductDetailScreen(id: id, args: args),
        settings: settings,
      );
    }

    // /produk/new  (create)
    // if (name == create) {
    //   final args = settings.arguments;
    //   return MaterialPageRoute(
    //     builder: (_) => ProductFormScreen(args: args),
    //     settings: settings,
    //   );
    // }

    // Pola dinamis:
    // /produk/:id
    // /produk/:id/edit
    // final segs = uri.pathSegments;
    // if (segs.isNotEmpty && segs.first == 'produk') {
    //   // Harus minimal 2 segmen: ['produk', ':id', ...]
    //   if (segs.length >= 2) {
    //     final id = segs[1];
    //     final isEdit = segs.length >= 3 && segs[2] == 'edit';
    //     final args = settings.arguments;

    //     if (isEdit) {
    //       // /produk/:id/edit  -> Form edit
    //       return MaterialPageRoute(
    //         builder: (_) => ProductFormScreen(id: id, args: args),
    //         settings: settings,
    //       );
    //     }

    //     // /produk/:id  -> Detail
    //     return MaterialPageRoute(
    //       builder: (_) => ProductDetailScreen(id: id, args: args),
    //       settings: settings,
    //     );
    //   }
    // }

    // Tidak dikenali -> null biar fallback ke router global
    return null;
  }
}
