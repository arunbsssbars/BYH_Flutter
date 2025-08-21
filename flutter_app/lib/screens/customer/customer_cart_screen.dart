import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final api = ApiService('http://localhost:3000');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: cart.items.isEmpty
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
          )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final item = cart.items[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: Text(item.name[0].toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          title: Text(item.name,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('₹${item.price} x ${item.quantity}',
                              style: const TextStyle(fontSize: 15)),
                          trailing: SizedBox(
                            width: 110,
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 30),
                                    color: Colors.teal,
                                    onPressed: () => cart.decreaseQty(item.id),
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 30),
                                    color: Colors.teal,
                                    onPressed: () => cart.increaseQty(item.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 35),
                                    color: Colors.redAccent,
                                    onPressed: () => cart.removeItem(item.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('₹${cart.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text('Checkout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(fontSize: 17),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (cart.items.isEmpty) return;
                            final vendorId = 'v1';
                            final items = cart.items
                                .map((c) => {
                                      'productId': c.id,
                                      'qty': c.quantity,
                                      'price': c.price
                                    })
                                .toList();
                            final payload = {
                              'vendorId': vendorId,
                              'customerName': 'Demo Customer',
                              'items': items
                            };
                            final order = await api.createOrder(payload);
                            for (var it in List.from(cart.items)) {
                              cart.removeItem(it.id);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Order placed'),
                                backgroundColor: Colors.teal,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

