import 'package:flutter/material.dart';

/// Contract untuk setiap fitur agar bisa menyediakan onGenerateRoute sendiri.
abstract class FeatureRoute {
  /// Dicoba dulu, kalau cocok return MaterialPageRoute, kalau tidak return null.
  Route<dynamic>? onGenerateRoute(RouteSettings settings);
}
