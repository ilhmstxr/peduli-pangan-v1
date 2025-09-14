import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider untuk menyimpan index navigasi bawah (BottomNav)
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
