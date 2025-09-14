import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../produk/data/product_model.dart';
import '../produk/application/product_list_vm.dart';
import '../produk/application/product_state.dart';
// import '../../widgets/food_item.dart';
// import '../../widgets/app_bottom_nav.dart';
import '../home/widgets/app_bottom_nav.dart';
import '../home/widgets/food_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Muat data awal
    Future.microtask(() async {
      final vm = ref.read(productListVMProvider.notifier);
      await vm.refresh(); // <-- pakai refresh() saja
    });

    // Infinite scroll sederhana
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
              _scrollCtrl.position.maxScrollExtent - 200 &&
          mounted) {
        final state = ref.read(productListVMProvider);
        if (!state.isLoadingMore && state.hasMore) {
          ref.read(productListVMProvider.notifier).loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListVMProvider);
    final vm = ref.read(productListVMProvider.notifier);

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => vm.refresh(),
          child: CustomScrollView(
            controller: _scrollCtrl,
            slivers: [
              // ===== Header / Hero =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Hi, Fulan",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Produk terbaru untukmu",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===== Search bar (opsional, terhubung ke VM.search) =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    onSubmitted: (q) => vm.search(q),
                    decoration: InputDecoration(
                      hintText: 'Cari produk…',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),

              // ===== State handling =====
              if (state.isLoading && state.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && state.items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorView(
                    message: state.error!,
                    onRetry: () => vm.refresh(),
                  ),
                )
              else if (state.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyView(),
                )
              else
                // ===== Daftar produk =====
                SliverList.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final p = state.items[index];
                    return _ProductTile(product: p);
                  },
                ),

              // ===== Footer: loading more / error / habis =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Builder(
                      builder: (_) {
                        if (state.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.error != null && state.items.isNotEmpty) {
                          return Column(
                            children: [
                              Text(
                                'Terjadi kesalahan: ${state.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () => vm.loadMore(),
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          );
                        }
                        if (!state.hasMore) {
                          return const Text(
                            '— Tidak ada lagi produk —',
                            style: TextStyle(color: Colors.black54),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Widget tampilan product item sederhana ===
class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    // Kamu bisa ganti ke card yang lebih kaya (gambar, badge stok, rating, dsb)
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: const Icon(Icons.shopping_bag_outlined),
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _formatPrice(product.price) +
            (product.stock > 0 ? ' · Stok: ${product.stock}' : ' · Habis'),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: navigasi ke detail product (kalau sudah ada)
        // context.push('/product/${product.id}');
      },
    );
  }

  String _formatPrice(double value) {
    // Simple formatter. Ganti ke intl NumberFormat jika proyekmu sudah pakai intl.
    final s = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    return 'Rp$s';
  }
}

// === View state helper ===
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Belum ada produk.'),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ups: $message',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Muat ulang')),
      ],
    );
  }
}
