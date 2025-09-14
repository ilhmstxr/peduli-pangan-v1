import '../data/kategori_repository.dart';
import '../data/kategori_model.dart';
import 'kategori_state.dart';

class KategoriListVM {
  final KategoriRepository repo;
  KategoriState _state = const KategoriState();

  KategoriListVM(this.repo);

  KategoriState get state => _state;

  Future<void> load({bool refresh = false}) async {
    _state = _state.copyWith(isLoading: true, error: null);
    try {
      final items = await repo.list(
          search: _state.search.isEmpty ? null : _state.search,
          parentId: _state.parentFilter);
      _state = _state.copyWith(items: items, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearch(String value) {
    _state = _state.copyWith(search: value);
  }

  void setParentFilter(int? parentId) {
    _state = _state.copyWith(parentFilter: parentId);
  }

  Future<void> delete(int id) async {
    _state = _state.copyWith(isLoading: true, error: null);
    try {
      await repo.delete(id);
      final updated = List<Kategori>.from(_state.items)
        ..removeWhere((e) => e.id == id);
      _state = _state.copyWith(items: updated, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
