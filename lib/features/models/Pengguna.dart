import '../shared/helpers/helper.dart';

// pengguna
class Pengguna {
  final int id;
  final String name;
  final String email;
  final String passwordHash; // disimpan hash
  final String? username;
  final String role; // varchar(20)
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Pengguna({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.username,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Pengguna.fromMap(Map<String, dynamic> m) => Pengguna(
        id: m['id'] as int,
        name: m['name'] as String,
        email: m['email'] as String,
        passwordHash: m['password_hash'] as String,
        username: cast<String>(m['username']),
        role: m['role'] as String,
        createdAt: toDate(m['created_at']),
        updatedAt: toDate(m['updated_at']),
        deletedAt: toDate(m['deleted_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'username': username,
        'role': role,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };
}
