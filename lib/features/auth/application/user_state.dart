// lib/features/users/application/user_state.dart
import '../data/user_model.dart';

/// Jika butuh state kompleks di luar AsyncValue, pakai ini.
/// Untuk sekarang, AsyncValue<Pengguna?> biasanya sudah cukup.
class UserListState {
  final List<Pengguna> items;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const UserListState({
    required this.items,
    required this.isLoadingMore,
    required this.hasMore,
    this.errorMessage,
  });

  UserListState copyWith({
    List<Pengguna>? items,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return UserListState(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  static const empty =
      UserListState(items: [], isLoadingMore: false, hasMore: true);
}
