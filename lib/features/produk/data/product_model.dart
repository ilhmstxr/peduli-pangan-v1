import '../gambarProduk/data/gambarProduk_model.dart';

class Product {
  // ====== kolom utama (table: product)
  final int id;
  final int merchantId;
  final int categoryId;
  final String name;
  final String slug;
  final double price;
  final int stock;
  final String? condition; // 'new' | 'used' | null
  final String? shortDesc;
  final String? longDesc;
  final Map<String, dynamic>? attributes;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // tambahan dari tabel product
  final String? tag; // label kategori (contoh: "Surplus Food")

  // ====== kolom turunan / hasil join
  final String? imageUrl;
  final List<GambarProduk> images;
  final String? description;
  final String? merchantName;
  final String? merchantAddress;

  /// jam maksimal pengambilan / kadaluarsa produk (opsional)
  final DateTime? pickupWindow;

  const Product({
    required this.id,
    required this.merchantId,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.price,
    required this.stock,
    this.condition,
    this.shortDesc,
    this.longDesc,
    this.attributes,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.tag,
    this.imageUrl,
    this.images = const [],
    this.description,
    this.merchantName,
    this.merchantAddress,
    this.pickupWindow,
  });

  Product copyWith({
    int? id,
    int? merchantId,
    int? categoryId,
    String? name,
    String? slug,
    double? price,
    int? stock,
    String? condition,
    String? shortDesc,
    String? longDesc,
    Map<String, dynamic>? attributes,
    double? rating,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? tag,
    String? imageUrl,
    List<GambarProduk>? images,
    String? description,
    String? merchantName,
    String? merchantAddress,
    DateTime? pickupWindow,
  }) {
    return Product(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      condition: condition ?? this.condition,
      shortDesc: shortDesc ?? this.shortDesc,
      longDesc: longDesc ?? this.longDesc,
      attributes: attributes ?? this.attributes,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tag: tag ?? this.tag,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      description: description ?? this.description,
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      pickupWindow: pickupWindow ?? this.pickupWindow,
    );
  }

  // getter
  String? get primaryImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl;
    if (images.isNotEmpty) return images.first.url;
    return null;
  }

  // mapping dasar
  static Product fromMap(Map<String, dynamic> m) {
    final created = m['created_at'];
    final updated = m['updated_at'];

    return Product(
      id: (m['id'] as num).toInt(),
      merchantId: (m['merchant_id'] as num).toInt(),
      categoryId: (m['category_id'] as num).toInt(),
      name: m['nama'] as String, // tabel product pakai "nama"
      slug: m['slug'] as String,
      price: (m['harga'] as num).toDouble(), // kolom harga
      stock: (m['stock'] as num).toInt(),
      condition: m['condition'] as String?,
      shortDesc: m['short_desc'] as String?,
      longDesc: m['long_desc'] as String?,
      attributes: (m['attributes'] as Map?)?.cast<String, dynamic>(),
      rating: (m['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: (m['is_active'] as bool?) ?? true,
      createdAt:
          created is String ? DateTime.parse(created) : (created as DateTime),
      updatedAt:
          updated is String ? DateTime.parse(updated) : (updated as DateTime),
      tag: m['tag'] as String?, // field tambahan
      // pickupWindow belum ada di tabel → fallback jika ada alias 'pickup_window' atau 'expired_at'
      pickupWindow: m['pickup_window'] != null
          ? DateTime.tryParse(m['pickup_window'] as String)
          : (m['expired_at'] != null
              ? DateTime.tryParse(m['expired_at'] as String)
              : null),
    );
  }

  String pickupLabel({String tz = 'WIB'}) {
    final start = createdAt; // START
    final end = pickupWindow; // END
    if (end == null) return "Pick up today 18:00 - 20:00 $tz";

    // kamu bisa pakai intl di sini juga, tapi biar tanpa dependency:
    String hhmm(DateTime d) =>
        "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

    // opsional: kalau hari beda, tambahkan tanggal
    final sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;
    final dayLabel = sameDay
        ? "today"
        : "${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}";

    return "Pick up $dayLabel ${hhmm(start)} - ${hhmm(end)} $tz";
  }
}
