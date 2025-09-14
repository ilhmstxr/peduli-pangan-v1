// routing/merchant_routes.dart
import 'package:flutter/material.dart';
import 'package:pedulipanganv1/core/feature_route.dart';

// Ganti import sesuai lokasi file screen kamu.
// Contoh di sini diasumsikan tidak dalam folder "presentation".
// Kalau kamu menaruhnya di presentation/, sesuaikan path-nya.
// import '../merchant_list_screen.dart';
import 'presentation/merchant_detail_screen.dart';
// import '../merchant_form_screen.dart';

class MerchantRoutes implements FeatureRoute {
  static const root = '/merchants';
  static const list = root;               // alias
  static const create = '$root/new';
  // template: /merchants/:id  (diparse manual)
  // template: /merchants/:id/edit

  /// Helper untuk path dinamis
  static String detailPath(int id) => '$root/$id';
  static String editPath(int id) => '$root/$id/edit';

  /// Optional alias (mis. dukung pola lama: /merchants/edit?id=123)
  static const editAlias = '$root/edit';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

    // 1) /merchants  -> list
    // if (name == root || name == list) {
    //   return MaterialPageRoute(
    //     builder: (_) => const MerchantListScreen(),
    //     settings: settings,
    //   );
    // }

    // 2) /merchants/new -> create form
    // if (name == create) {
    //   return MaterialPageRoute(
    //     builder: (_) => const MerchantFormScreen(), // mode create
    //     settings: settings,
    //   );
    // }

    // // 3) /merchants/edit?id=<id>  (alias opsional)
    // if (uri.path == editAlias) {
    //   final id = int.tryParse(uri.queryParameters['id'] ?? '');
    //   if (id != null) {
    //     return MaterialPageRoute(
    //       builder: (_) => MerchantFormScreen(merchantId: id), // mode edit
    //       settings: settings,
    //     );
    //   }
    //   // id tidak valid → fallback kecil
    //   return _error(settings, 'Merchant id tidak valid');
    // }

    // 4) /merchants/:id   -> detail
    // 5) /merchants/:id/edit -> edit form
    final seg = uri.pathSegments;
    if (seg.isNotEmpty && seg.first == 'merchants') {
      // /merchants/<id>
      if (seg.length == 2) {
        final id = int.tryParse(seg[1]);
        if (id != null) {
          return MaterialPageRoute(
            builder: (_) => MerchantDetailScreen(merchantId: id),
            settings: settings,
          );
        }
        return _error(settings, 'Merchant id tidak valid');
      }

      // /merchants/<id>/edit
      // if (seg.length == 3 && seg[2] == 'edit') {
      //   final id = int.tryParse(seg[1]);
      //   if (id != null) {
      //     return MaterialPageRoute(
      //       builder: (_) => MerchantFormScreen(merchantId: id), // mode edit
      //       settings: settings,
      //     );
      //   }
      //   return _error(settings, 'Merchant id tidak valid');
      // }
    }

    return null; // tidak match → biarkan modul lain mencoba
  }

  Route<dynamic> _error(RouteSettings s, String msg) {
    return MaterialPageRoute(
      settings: s,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Oops')),
        body: Center(child: Text(msg)),
      ),
    );
  }
}
