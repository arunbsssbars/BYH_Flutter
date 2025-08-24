import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';

class CustomerProductListScreen extends ConsumerWidget {
  final String vendorId;
  const CustomerProductListScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    final vendorProducts =
        products.products.where((product) => product.vendorId == vendorId).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: vendorProducts.isEmpty
          ? const Center(child: Text('No products available'))
          : ListView.builder(
              itemCount: vendorProducts.length,
              itemBuilder: (context, index) {
                final product = vendorProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(product.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                    title: Text(product.name),
                    subtitle: Text('${product.price} ₹ / ${product.unit}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        ref.read(cartProvider.notifier).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} added to cart')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
    );
  }
}
