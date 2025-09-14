import 'package:flutter/material.dart';
import 'package:pedulipanganv1/core/feature_route.dart';
// hapus duplikasi import feature_route lama kalau tidak dipakai
// import '../../../core/routing/feature_route.dart';

// import '../presentation/user_profile_screen.dart';
// import '../presentation/user_form_screen.dart';
import 'presentation/widgets/user_profile_screen.dart';
import 'presentation/widgets/user_form_screen.dart';

class UserRoutes implements FeatureRoute {
  static const root = '/users';
  static const profile = '$root/profile';
  static const profileEdit = '$root/profile/edit';

  // alias opsional
  static const editAlias = '$root/edit';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

    // Fallback: /users -> profile
    if (name == root) {
      return MaterialPageRoute(
        builder: (_) => const UserProfileScreen(),
        settings: settings,
      );
    }

    // /users/profile
    if (name == profile) {
      return MaterialPageRoute(
        builder: (_) => const UserProfileScreen(),
        settings: settings,
      );
    }

    // /users/profile/edit  (atau alias /users/edit)
    if (name == profileEdit || name == editAlias) {
      return MaterialPageRoute(
        builder: (_) => const UserFormScreen(),
        settings: settings,
      );
    }

    // Jika ingin tetap dukung pola lama (detail by id / edit by id),
    // bisa tambah handler di bawah ini. Untuk sekarang kita nonaktifkan
    // karena view-nya tidak dipakai lagi.
    // --- contoh (komentari jika tidak perlu) ---
    // if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'users') { ... }
    // if (uri.pathSegments.length == 3 && uri.pathSegments[0] == 'users' && uri.pathSegments[2] == 'edit') { ... }

    return null; // tidak match
  }
}
