
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/providers/riverpod_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    if (orders.isEmpty) {
      return const Scaffold(
        appBar: AppBar(title: Text('Riwayat Pemesanan')),
        body: Center(child: Text('Belum ada transaksi')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pemesanan')),
      body: ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final o = orders[orders.length - 1 - i]; // newest first
          return ListTile(
            title: Text('Order #${o.id} • ${o.status.toUpperCase()}'),
            subtitle: Text('${o.createdAt}'),
            trailing: Text('Rp ${(o.total).toStringAsFixed(0)}'),
            onTap: () {
              Navigator.pushNamed(context, '/transaction-detail-screen', arguments: o.id);
            },
          );
        },
      ),
    );
  }
}
