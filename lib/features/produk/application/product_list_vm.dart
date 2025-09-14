import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';
import '../data/product_repository_supabase.dart';
import 'product_filters.dart';
import '../data/product_mapper.dart';
import '../data/product_model.dart';
import 'product_state.dart';
import '../data/product_realtime_source.dart';

final productListVMProvider =
    NotifierProvider<ProductListVM, ProductState>(ProductListVM.new);

class ProductListVM extends Notifier<ProductState> {
  late final ProductRepository _repo = ref.read(productRepositoryProvider);
  StreamSubscription? _sub;

  @override
  ProductState build() {
    _listenRealtime(); // opsional
    _initialLoad();
    ref.onDispose(() => _sub?.cancel()); // <-- penting
    return const ProductState();
  }

  Future<void> _initialLoad() async {
    await refresh();
  }

  Future<void> refresh({ProductFilters? filters}) async {
    final f = (filters ?? state.filters).copyWith(before: null);
    state = state.copyWith(isLoading: true, filters: f, clearError: true);
    try {
      final list = await _repo.list(f);
      if (!ref.mounted) return; // <-- guard
      final cursor = list.isEmpty ? null : list.last.createdAt;
      state = state.copyWith(
        items: list,
        cursor: cursor,
        hasMore: list.length >= f.limit,
        isLoading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: '$e');
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    final f = state.filters.copyWith(before: state.cursor);
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final more = await _repo.list(f);
      if (!ref.mounted) return;
      final cursor = more.isEmpty ? state.cursor : more.last.createdAt;
      state = state.copyWith(
        items: [...state.items, ...more],
        cursor: cursor,
        hasMore: more.length >= f.limit,
        isLoadingMore: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingMore: false, error: '$e');
    }
  }

  Future<void> search(String q) =>
      refresh(filters: state.filters.copyWith(q: q));

  // ---- Realtime (opsional)
  void _listenRealtime() {
    final src = ref.read(productRealtimeSourceProvider);
    _sub?.cancel();
    _sub = src.stream().listen((evt) {
      switch (evt.type) {
        case ProductEventType.insert:
          final p = ProductMapper.fromMap(evt.row);
          // dedup jika sudah ada
          if (state.items.any((e) => e.id == p.id)) return;
          state = state.copyWith(items: [p, ...state.items]);
          break;
        case ProductEventType.update:
          final p = ProductMapper.fromMap(evt.row);
          final idx = state.items.indexWhere((e) => e.id == p.id);
          if (idx >= 0) {
            final newItems = [...state.items]..[idx] = p;
            state = state.copyWith(items: newItems);
          }
          break;
        case ProductEventType.delete:
          final id = (evt.row['id'] as num).toInt();
          state = state.copyWith(
            items: state.items.where((e) => e.id != id).toList(),
          );
          break;
      }
    });
  }
}
