import 'kategori_model.dart';

class KategoriMapper {
  static const table = 'kategori';

  /// Columns in the DB
  static const colId = 'id';
  static const colName = 'name';
  static const colSlug = 'slug';
  static const colParentId = 'parent_id';
  static const colCreatedAt = 'created_at';

  static Kategori fromRow(Map<String, dynamic> row) {
    return Kategori(
      id: row[colId] as int,
      name: row[colName] as String,
      slug: row[colSlug] as String,
      parentId: row[colParentId] as int?,
      createdAt: row[colCreatedAt] == null
          ? null
          : DateTime.tryParse(row[colCreatedAt] as String),
    );
  }

  static Map<String, dynamic> toInsert(KategoriInput input) {
    return {
      colName: input.name,
      colSlug: input.slug,
      colParentId: input.parentId,
    }..removeWhere((key, value) => value == null);
  }

  static Map<String, dynamic> toUpdate(KategoriInput input) => toInsert(input);
}
