// routing/merchant_routes.dart

/// Kumpulan konstanta rute untuk modul merchant.
/// (Bisa dipakai oleh GoRouter, AutoRoute, atau Navigator biasa)
class MerchantRoutes {
  static const String list = '/merchants';
  static const String detail = '/merchants/:id';
  static const String formCreate = '/merchants/new';
  static const String formEdit = '/merchants/:id/edit';
}
