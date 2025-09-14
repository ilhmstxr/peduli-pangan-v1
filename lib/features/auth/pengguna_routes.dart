// lib/features/users/routing/user_routes.dart

/// Kumpulan konstanta dan helper route untuk fitur Users.
/// Jika kamu pakai go_router, konstanta ini bisa dipakai di konfigurasi router global.
class UserRoutes {
  static const root = '/users';
  static const detail = '/users/:id';
  static const profile = '/users/profile'; // current user profile
  static const create = '/users/new';
  static const edit = '/users/:id/edit';

  /// Helper membuat path detail.
  static String detailPath(int id) => '/users/$id';
  static String editPath(int id) => '/users/$id/edit';
}
