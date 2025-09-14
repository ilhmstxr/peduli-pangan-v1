import 'package:flutter/material.dart';
import 'kategori_list_screen.dart';
import 'kategori_form_screen.dart';
import '../../../core/feature_route.dart';

class KategoriRoutes implements FeatureRoute {
  static const root = '/categories';
  static const list = '$root/list';
  static const form = '$root/form';

// alias opsional
  static const createAlias = '$root/create';
  static const editAlias = '$root/edit';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

// fallback: /categories -> list
    if (name == root || name == list) {
      return MaterialPageRoute(
        builder: (_) => const KategoriListScreen(
          title: 'Categories',
          items: [],
        ),
        settings: settings,
      );
    }

// /categories/form
    if (name == form || name == createAlias) {
      return MaterialPageRoute(
        builder: (_) => KategoriFormScreen(vm: throw UnimplementedError()),
        settings: settings,
      );
    }

// /categories/edit?id=123
    if (name == editAlias && settings.arguments is Map) {
      final args = settings.arguments as Map;
      final id = args['id'] as int?;
      return MaterialPageRoute(
        builder: (_) =>
            KategoriFormScreen(vm: throw UnimplementedError(), editingId: id),
        settings: settings,
      );
    }

    return null; // tidak match
  }
}
