import '../data/kategori_model.dart';
import '../data/kategori_repository.dart';

class KategoriFormVM {
  final KategoriRepository repo;

  String name = '';
  String slug = '';
  int? parentId;

  bool isSaving = false;
  String? error;

  KategoriFormVM(this.repo);

  void setName(String v) => name = v;
  void setSlug(String v) => slug = v;
  void setParentId(int? v) => parentId = v;

  KategoriInput _buildInput() =>
      KategoriInput(name: name.trim(), slug: slug.trim(), parentId: parentId);

  Future<Kategori> create() async {
    isSaving = true;
    error = null;
    try {
      final created = await repo.create(_buildInput());
      return created;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
    }
  }

  Future<Kategori> update(int id) async {
    isSaving = true;
    error = null;
    try {
      final updated = await repo.update(id, _buildInput());
      return updated;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
    }
  }
}
