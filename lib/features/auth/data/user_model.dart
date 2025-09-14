import 'package:meta/meta.dart';

@immutable
class Pengguna {
  final int id;
  final String name;
  final String email;
  final String? username; // opsional, mengikuti skema
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  /// Hanya untuk data layer (jangan expose ke UI).
  final String? passwordHash;

  const Pengguna({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.username,
    this.deletedAt,
    this.passwordHash,
  });

  Pengguna copyWith({
    int? id,
    String? name,
    String? email,
    String? username,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? passwordHash,
  }) {
    return Pengguna(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  @override
  bool operator ==(Object o) => o is Pengguna && o.id == id;
  @override
  int get hashCode => id.hashCode;
}
