
// lib/models/product.dart
// Model Product tanpa circular import ke merchant.dart.
// Jika relasi merchant ikut di-select (select('*, merchants(*)')), field `merchant` akan terisi sebagai MerchantLite.

class Product {
  final int id;
  final int merchantId;
  final String nama;
  final String? deskripsi;
  final double? harga;
  final String? gambarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MerchantLite? merchant; // relasi opsional

  const Product({
    required this.id,
    required this.merchantId,
    required this.nama,
    this.deskripsi,
    this.harga,
    this.gambarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.merchant,
  });

  Product copyWith({
    int? id,
    int? merchantId,
    String? nama,
    String? deskripsi,
    double? harga,
    String? gambarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    MerchantLite? merchant,
  }) {
    return Product(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      harga: harga ?? this.harga,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      merchant: merchant ?? this.merchant,
    );
  }

  Map<String, dynamic> toJson({bool includeRelations = true}) {
    return {
      'id': id,
      'merchant_id': merchantId,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'gambar_url': gambarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (includeRelations && merchant != null) 'merchants': merchant!.toJson(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    DateTime parseDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    MerchantLite? parseMerchant(dynamic v) {
      if (v == null) return null;
      if (v is Map<String, dynamic>) return MerchantLite.fromJson(v);
      return null;
    }

    return Product(
      id: json['id'] as int,
      merchantId: (json['merchant_id'] as num).toInt(),
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String?,
      harga: parseDouble(json['harga']),
      gambarUrl: json['gambar_url'] as String?,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      // Supabase relasi menggunakan nama tabel: 'merchants'
      merchant: parseMerchant(json['merchants']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          merchantId == other.merchantId &&
          nama == other.nama &&
          deskripsi == other.deskripsi &&
          harga == other.harga &&
          gambarUrl == other.gambarUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      merchantId.hashCode ^
      nama.hashCode ^
      (deskripsi?.hashCode ?? 0) ^
      (harga?.hashCode ?? 0) ^
      (gambarUrl?.hashCode ?? 0) ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

// Representasi ringan untuk relasi merchant agar menghindari circular import.
// Field yang disertakan bisa diubah sesuai kebutuhan.
class MerchantLite {
  final int id;
  final String namaToko;
  final String? deskripsi;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MerchantLite({
    required this.id,
    required this.namaToko,
    this.deskripsi,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  MerchantLite copyWith({
    int? id,
    String? namaToko,
    String? deskripsi,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MerchantLite(
      id: id ?? this.id,
      namaToko: namaToko ?? this.namaToko,
      deskripsi: deskripsi ?? this.deskripsi,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_toko': namaToko,
      'deskripsi': deskripsi,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory MerchantLite.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return MerchantLite(
      id: json['id'] as int,
      namaToko: (json['nama_toko'] ?? json['name'] ?? '').toString(),
      deskripsi: json['deskripsi'] as String?,
      rating: parseDouble(json['rating']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}
