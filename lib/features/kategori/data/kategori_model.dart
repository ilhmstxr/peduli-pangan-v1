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
}

/// Input object for create/update to avoid sending read-only fields
class KategoriInput {
  final String name;
  final String slug;
  final int? parentId;

  const KategoriInput({
    required this.name,
    required this.slug,
    this.parentId,
  });

  KategoriInput copyWith({String? name, String? slug, int? parentId}) =>
      KategoriInput(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        parentId: parentId ?? this.parentId,
      );
}
