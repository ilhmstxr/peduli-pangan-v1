import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State management merchant
import '../data/merchant_detail_vm.dart';
import '../application/merchant_list_state.dart';
import '../data/merchant_model.dart';

// State management produk
import '../../produk/application/product_filters.dart';
import '../../produk/application/product_list_vm.dart';
import '../../produk/application/product_state.dart';

// UI widgets
import '../presentation/food_item_tile.dart';

/// Layar Detail Merchant
class MerchantDetailScreen extends ConsumerWidget { 
  const MerchantDetailScreen({super.key, required this.merchantId});
  final int merchantId;

  void _loadData(WidgetRef ref) {
    ref.read(merchantDetailVMProvider(merchantId).notifier).refresh();
    ref
        .read(productListVMProvider.notifier)
        .refresh(filters: ProductFilters(merchantId: merchantId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mState = ref.watch(merchantDetailVMProvider(merchantId));
    final pState = ref.watch(productListVMProvider);
    final theme = Theme.of(context);

    // Loading utama merchant
    if (mState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Error / tidak ada merchant
    if (mState.error != null || mState.selected == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mState.error ?? 'Merchant tidak ditemukan.',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => _loadData(ref),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final merchant = mState.selected!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(ref),
        child: CustomScrollView(
          slivers: [
            _buildMerchantHeader(context, merchant),
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
                    child: Column(
                      children: [
                        _buildMerchantInfoCard(context, theme, merchant),
                        const SizedBox(height: 24),
                        _buildProductSectionHeader(theme),
                        const SizedBox(height: 12),
                        _buildProductList(ref, pState),
                      ],
                    ),
                  ),
                  // Logo bulat
                  Positioned(
                    top: -32,
                    left: 32,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(merchant.logoUrl ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(WidgetRef ref, ProductState pState) {
    if (pState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (pState.error != null) {
      return Center(
        child: Column(
          children: [
            Text('Gagal memuat item: ${pState.error}'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => ref
                  .read(productListVMProvider.notifier)
                  .refresh(), // default pakai filter lama
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (pState.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Belum ada item tersedia')),
      );
    }

    return Column(
      children: [
        for (final product in pState.items) ...[
          FoodItemTile(
            product: product,
            onTap: () {
              ScaffoldMessenger.of(ref.context).showSnackBar(
                SnackBar(content: Text('Menuju ke detail: ${product.name}')),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildProductSectionHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          'Food Available',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Text('See All', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildMerchantHeader(BuildContext context, Merchant merchant) {
    final imageUrl = merchant.bannerUrl ??
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1400&auto=format&fit=crop';

    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      title: const Text(
        'Detail Restaurant',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantInfoCard(
      BuildContext context, ThemeData theme, Merchant merchant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  merchant.namaToko,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                (merchant.rating ?? 0).toStringAsFixed(1),
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  merchant.deskripsi ?? 'Alamat belum tersedia',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.map_rounded,
                    size: 48, color: Colors.black26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
