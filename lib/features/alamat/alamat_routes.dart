import 'package:flutter/material.dart';
import 'package:pedulipanganv1/core/feature_route.dart';

// import screen yang sebenarnya
import '../alamat/presentation/alamat_list_screen.dart';
import '../alamat/presentation/alamat_form_screen.dart';

class AlamatRoutes implements FeatureRoute {
  static const root = '/alamat';
  static const list = root; // alias /alamat
  static const form = '$root/form';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

    // fallback /alamat -> list
    if (name == root || name == list) {
      return MaterialPageRoute(
        builder: (_) => const AlamatListScreen(),
        settings: settings,
      );
    }

    // /alamat/form
    if (name == form) {
      return MaterialPageRoute(
        builder: (_) => const AlamatFormScreen(),
        settings: settings,
      );
    }

    // jika ada rute lain (detail, edit by id), bisa ditambahkan di sini
    // contoh:
    // if (uri.pathSegments.length == 3 && uri.pathSegments[0] == 'alamat' && uri.pathSegments[2] == 'edit') { ... }

    return null;
  }
}
