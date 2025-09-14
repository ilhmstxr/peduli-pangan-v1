// data/merchant_model.dart
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

  const Merchant({
    required this.id,
    required this.userId,
    required this.namaToko,
    this.deskripsi,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  Merchant copyWith({
    int? id,
    int? userId,
    String? namaToko,
    String? deskripsi,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Merchant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaToko: namaToko ?? this.namaToko,
      deskripsi: deskripsi ?? this.deskripsi,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      };

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: (json['id'] as num).toInt(),
        userId: (json['user_id'] as num).toInt(),
        namaToko: json['nama_toko'] as String,
        deskripsi: json['deskripsi'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        createdAt:
            json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt:
            json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );

  @override
  String toString() =>
      'Merchant(id: $id, userId: $userId, namaToko: $namaToko, rating: $rating)';
}
