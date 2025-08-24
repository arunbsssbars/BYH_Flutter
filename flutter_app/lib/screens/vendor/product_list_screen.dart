import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import 'product_form_screen.dart';
import '../../widgets/product_card.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  static const route = '/products';
  final String vendorId;
  const ProductListScreen({super.key, required this.vendorId, required bool isAdd});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).load(widget.vendorId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(productProvider.notifier).load(widget.vendorId),
        child: state.products.isEmpty && !state.loading
            ? const Center(child: Text('No products yet. Add one.'))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, i) => ProductCard(product: state.products[i]),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: state.products.length,
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormScreen(vendorId: widget.vendorId),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
