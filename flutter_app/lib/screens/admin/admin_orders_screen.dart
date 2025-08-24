import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(adminOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Orders (Admin)')),
      body: asyncOrders.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders'))
            : ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, i) {
                  final o = orders[i];
                  return ListTile(
                    title: Text(
                        'Order #${o.id.substring(0, 6)} | ₹ ${o.total.toStringAsFixed(2)}'),
                    subtitle: Text(
                        'Vendor: ${o.vendorId} | Customer: ${o.customerId}'),
                    trailing: Text(o.status.name.toUpperCase()),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
