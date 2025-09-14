import '../shared/helpers/helper.dart';

// kategori (category)
class Kategori {
  final int id;
  final String name;
  final String slug;
  final int? parentId;
  final DateTime? createdAt;

  const Kategori({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.createdAt,
  });

  factory Kategori.fromMap(Map<String, dynamic> m) => Kategori(
        id: m['id'] as int,
        name: m['name'] as String,
        slug: m['slug'] as String,
        parentId: cast<int>(m['parent_id']),
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'slug': slug,
        'parent_id': parentId,
        'created_at': createdAt?.toIso8601String(),
      };
}

