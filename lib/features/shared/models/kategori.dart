// lib/models/kategori.dart

class Kategori {
  final int id;
  final String name;
  final String slug;
  final int? parentId;
  final DateTime createdAt;

  const Kategori({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    required this.createdAt,
  });

  Kategori copyWith({
    int? id,
    String? name,
    String? slug,
    int? parentId,
    DateTime? createdAt,
  }) {
    return Kategori(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: json['parent_id'] as int?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
