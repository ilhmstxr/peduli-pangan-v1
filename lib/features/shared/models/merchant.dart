
// lib/models/merchant.dart
// Revisi: tambah toJson, copyWith, equality, dan fromJson yang robust untuk nested products

import '../../produk/data/product_model.dart';

class Merchant {
  final int id;
  final int userId;
  final String namaToko;
  final String? deskripsi;
  final double? rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Product> products;

  const Merchant({
    required this.id,
    required this.userId,
    required this.namaToko,
    this.deskripsi,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
    this.products = const [],
  });

  Merchant copyWith({
    int? id,
    int? userId,
    String? namaToko,
    String? deskripsi,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Product>? products,
  }) {
    return Merchant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaToko: namaToko ?? this.namaToko,
      deskripsi: deskripsi ?? this.deskripsi,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toJson({bool includeRelations = true}) {
    return {
      'id': id,
      'user_id': userId,
      'nama_toko': namaToko,
      'deskripsi': deskripsi,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (includeRelations) 'products': products.map((p) => p.toJson(includeRelations: false)).toList(),
    };
  }

  factory Merchant.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'];
    final productList = (productsJson is List)
        ? productsJson.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList()
        : <Product>[];

    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    DateTime parseDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    return Merchant(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      namaToko: json['nama_toko'] as String,
      deskripsi: json['deskripsi'] as String?,
      rating: parseDouble(json['rating']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      products: productList,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Merchant &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          namaToko == other.namaToko &&
          deskripsi == other.deskripsi &&
          rating == other.rating &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      namaToko.hashCode ^
      (deskripsi?.hashCode ?? 0) ^
      (rating?.hashCode ?? 0) ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
