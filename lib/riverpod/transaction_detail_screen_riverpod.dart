
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/providers/riverpod_providers.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int orderId;
  const TransactionDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));
    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: order == null
          ? const Center(child: Text('Transaksi tidak ditemukan'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${order.status}'),
                  const SizedBox(height: 8),
                  Text('Total: Rp ${order.total.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  Text('Tanggal: ${order.createdAt}'),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => ref.read(ordersControllerProvider.notifier).updateStatus(orderId, 'paid'),
                        child: const Text('Tandai Lunas'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => ref.read(ordersControllerProvider.notifier).updateStatus(orderId, 'done'),
                        child: const Text('Selesai'),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
