import 'kategori_model.dart';

abstract class KategoriRepository {
  Future<List<Kategori>> list(
      {String? search, int? parentId, int limit = 50, int offset = 0});
  Future<Kategori?> getById(int id);
  Future<Kategori> create(KategoriInput input);
  Future<Kategori> update(int id, KategoriInput input);
  Future<void> delete(int id);
}
