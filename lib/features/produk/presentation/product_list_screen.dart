import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/product_list_vm.dart'; // NotifierProvider<ProductListVM, ProductState>
import '../data/product_model.dart'; // Entity Product (sesuaikan fieldnya)

class ProductListScreen extends ConsumerStatefulWidget {
  final dynamic args;
  final Map<String, String>? queryParams;

  const ProductListScreen({
    Key? key,
    this.args,
    this.queryParams,
  }) : super(key: key);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger loadMore ketika mendekati bawah
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      ref.read(productListVMProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() async {
    await ref.read(productListVMProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListVMProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produk')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Builder(
          builder: (_) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.items.isEmpty) {
              return _ErrorView(
                message: state.error!,
                onRetry: () =>
                    ref.read(productListVMProvider.notifier).refresh(),
              );
            }

            return ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final p = state.items[index];
                return ProductItemTile(product: p);
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductItemTile extends StatelessWidget {
  final Product product;
  const ProductItemTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = product.id;
    final name = product.name ?? 'Unnamed';
    final price = product.price ?? 0;
    // final distance = product.distanceLabel ?? '—'; // sesuaikan field mu di merchant
    final distanceInt = 800; // sesuaikan field mu di merchant
    final distance = distanceInt.toString(); // sesuaikan field mu di merchant
    final stock = product.stock ?? 0;
    final image =
        product.imageUrl ?? 'https://via.placeholder.com/100x100.png?text=Food';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, "/produk/$id"),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(image,
                    width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Pick up today 18:00 - 20:00 WIB"),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.green),
                        Text(distance),
                        const SizedBox(width: 12),
                        const Icon(Icons.attach_money,
                            size: 16, color: Colors.green),
                        Text("Rp $price"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("$stock left"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onRetry, child: const Text('Coba lagi')),
      ]),
    );
  }
}
