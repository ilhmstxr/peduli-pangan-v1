import 'pengguna_model.dart';

class UserMapper {
  static Pengguna fromRow(Map<String, dynamic> row) {
    return Pengguna(
      id: _toInt(row['id'])!,
      name: (row['name'] ?? '') as String,
      email: (row['email'] ?? '') as String,
      username: row['username'] as String?,
      role: (row['role'] ?? '') as String,
      createdAt: _toDate(row['created_at'])!,
      updatedAt: _toDate(row['updated_at'])!,
      deletedAt: _toDate(row['deleted_at']),
      // biasanya SELECT tidak mengembalikan password_hash; biarkan null
      passwordHash: row['password_hash'] as String?,
    );
  }

  /// Payload INSERT – tanpa kolom server-managed.
  static Map<String, dynamic> toInsert(Pengguna u) => {
        'name': u.name,
        'email': u.email,
        'username': u.username,
        'role': u.role,
        if (u.passwordHash != null) 'password_hash': u.passwordHash,
      };

  /// Payload UPDATE – tanpa id/created_at/updated_at (biar trigger yang isi).
  static Map<String, dynamic> toUpdate(Pengguna u) => {
        'name': u.name,
        'email': u.email,
        'username': u.username,
        'role': u.role,
        if (u.passwordHash != null) 'password_hash': u.passwordHash,
      };

  static int? _toInt(dynamic v) =>
      v == null ? null : (v is int ? v : int.tryParse(v.toString()));

  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v.toUtc();
    final parsed = DateTime.tryParse(v.toString());
    return parsed?.toUtc();
  }
}
