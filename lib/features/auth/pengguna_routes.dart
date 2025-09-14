import 'package:flutter/material.dart';
import 'package:pedulipanganv1/core/feature_route.dart';
import '../../../core/routing/feature_route.dart';
import '../presentation/user_profile_screen.dart';
import '../presentation/user_detail_screen.dart';
import '../presentation/user_edit_screen.dart';
import '../presentation/user_create_screen.dart';

class UserRoutes implements FeatureRoute {
  static const root = '/users';
  static const profile = '/users/profile';
  static const create = '/users/new';

  static String detailPath(int id) => '/users/$id';
  static String editPath(int id) => '/users/$id/edit';

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);
    if (uri == null) return null;

    if (name == profile) {
      return MaterialPageRoute(
        builder: (_) => const UserProfileScreen(),
        settings: settings,
      );
    }
    if (name == create) {
      return MaterialPageRoute(
        builder: (_) => const UserCreateScreen(),
        settings: settings,
      );
    }

    // /users/:id
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'users') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return MaterialPageRoute(
          builder: (_) => UserDetailScreen(id: id),
          settings: settings,
        );
      }
    }

    // /users/:id/edit
    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'users' &&
        uri.pathSegments[2] == 'edit') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return MaterialPageRoute(
          builder: (_) => UserEditScreen(id: id),
          settings: settings,
        );
      }
    }

    return null; // tidak match
  }
}
