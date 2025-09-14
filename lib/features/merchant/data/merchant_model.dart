import 'package:meta/meta.dart';

@immutable
class Merchant {
  final int id;
  final int userId;
  final String namaToko;
  final String? deskripsi;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? logoUrl;   // 🔥 ditambahkan
  final String? bannerUrl; // 🔥 ditambahkan

  const Merchant({
    required this.id,
    required this.userId,
    required this.namaToko,
    this.deskripsi,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.logoUrl,   // 🔥
    this.bannerUrl, // 🔥
  });

  Merchant copyWith({
    int? id,
    int? userId,
    String? namaToko,
    String? deskripsi,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? logoUrl,   // 🔥
    String? bannerUrl, // 🔥
  }) {
    return Merchant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaToko: namaToko ?? this.namaToko,
      deskripsi: deskripsi ?? this.deskripsi,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      logoUrl: logoUrl ?? this.logoUrl,     // 🔥
      bannerUrl: bannerUrl ?? this.bannerUrl, // 🔥
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'nama_toko': namaToko,
        'deskripsi': deskripsi,
        'rating': rating,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'logo_url': logoUrl,     // 🔥
        'banner_url': bannerUrl, // 🔥
      };

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: (json['id'] as num).toInt(),
        userId: (json['user_id'] as num).toInt(),
        namaToko: json['nama_toko'] as String,
        deskripsi: json['deskripsi'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        logoUrl: json['logo_url'] as String?,     // 🔥
        bannerUrl: json['banner_url'] as String?, // 🔥
      );

  @override
  String toString() =>
      'Merchant(id: $id, userId: $userId, namaToko: $namaToko, rating: $rating, logoUrl: $logoUrl, bannerUrl: $bannerUrl)';
}
