import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/product_detail_vm.dart'; // non-family: productDetailVMProvider
import '../data/product_model.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String id; // dari route /produk/:id
  final dynamic args; // optional

  const ProductDetailScreen({
    Key? key,
    required this.id,
    this.args,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late final int _idInt;

  @override
  void initState() {
    super.initState();

    _idInt = int.tryParse(widget.id) ?? -1;

    // Jika ID valid, load detail di awal
    if (_idInt > 0) {
      // microtask agar tidak memanggil provider sebelum siap
      Future.microtask(
        () => ref.read(productDetailVMProvider.notifier).fetch(_idInt),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_idInt <= 0) {
      return const Scaffold(
        body: Center(child: Text('Product ID tidak valid')),
      );
    }

    final asyncProd = ref.watch(productDetailVMProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(productDetailVMProvider.notifier).refresh(_idInt),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: asyncProd.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(
          message: '$err',
          onRetry: () =>
              ref.read(productDetailVMProvider.notifier).refresh(_idInt),
        ),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }
          return _DetailContent(product: product);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Product product;
  const _DetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl ??
        "https://via.placeholder.com/300x200.png?text=No+Image";
    final price = product.price ?? 0;
    final stock = product.stock ?? 0;
    final merchantName = product.merchantName ?? "Merchant";
    final merchantAddr = product.merchantAddress ?? "-";
    final desc = product.description ?? "-";
    final pickupText = product.pickupLabel(); // gunakan helper dari model

    return RefreshIndicator(
      onRefresh: () async {
        // Opsi B: refresh dipicu dari AppBar action (di atas).
        // Di sini tidak memanggil provider langsung karena widget ini bukan Consumer.
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name ?? 'Unnamed',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(product.tag ?? "Surplus Food"),
                ),
                const SizedBox(width: 12),
                Text(pickupText),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("$stock left"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.store, color: Colors.white),
              ),
              title: Text(merchantName),
              subtitle: Text(merchantAddr),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 16),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(desc),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                Text(
                  "Rp $price",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {/* TODO: add-to-cart */},
                  child: const Text("Add to Cart"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {/* TODO: buy-now */},
                  child: const Text("Buy Now"),
                ),
              ],
            ),
          ],
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
