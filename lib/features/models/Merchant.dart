import '../shared/helpers/helper.dart';

// merchants
class Merchant {
  final int id;
  final int userId;
  final String namaToko;
  final String? deskripsi;
  final num? rating; // decimal(3,2)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Merchant({
    required this.id,
    required this.userId,
    required this.namaToko,
    this.deskripsi,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory Merchant.fromMap(Map<String, dynamic> m) => Merchant(
        id: m['id'] as int,
        userId: m['user_id'] as int,
        namaToko: m['nama_toko'] as String,
        deskripsi: cast<String>(m['deskripsi']),
        rating: toNum(m['rating']),
        createdAt: toDate(m['created_at']),
        updatedAt: toDate(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'nama_toko': namaToko,
        'deskripsi': deskripsi,
        'rating': rating,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

