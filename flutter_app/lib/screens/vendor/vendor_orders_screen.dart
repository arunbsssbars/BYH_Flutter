import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOrdersScreen extends ConsumerWidget {
  final String vendorId;
  const VendorOrdersScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(vendorOrdersProvider(vendorId));

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: asyncOrders.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders yet'))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ExpansionTile(
                    title: Text(
                        'Order #${order.id.substring(0, 6)} - ${order.status.name.toUpperCase()}'),
                    subtitle:
                        Text('Total: ₹ ${order.total.toStringAsFixed(2)}'),
                    children: [
                      if (order.products.isNotEmpty)
                        const ListTile(
                            title: Text('Products',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ...order.products.map((p) => ListTile(
                          title: Text(p.product.name),
                          subtitle:
                              Text('${p.quantity} × ${p.product.price} ₹'))),
                      if (order.services.isNotEmpty)
                        const ListTile(
                            title: Text('Services',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ...order.services.map((s) => ListTile(
                          title: Text(s.service.name),
                          subtitle: Text(
                              '${s.quantity} × ${s.service.price} ₹ / ${s.service.unit}'))),
                      ButtonBar(
                        children: [
                          TextButton(
                            onPressed: () => ref
                                .read(orderCommandProvider.notifier)
                                .updateStatus(order.id, OrderStatus.confirmed),
                            child: const Text('Confirm'),
                          ),
                          TextButton(
                            onPressed: () => ref
                                .read(orderCommandProvider.notifier)
                                .updateStatus(order.id, OrderStatus.completed),
                            child: const Text('Complete'),
                          ),
                          TextButton(
                            onPressed: () => ref
                                .read(orderCommandProvider.notifier)
                                .updateStatus(order.id, OrderStatus.cancelled),
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
