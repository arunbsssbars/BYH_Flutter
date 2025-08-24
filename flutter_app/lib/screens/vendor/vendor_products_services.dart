import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_list_screen.dart';
import 'service_list_screen.dart';

// Import your providers
import '../../providers/product_provider.dart';
import '../../providers/service_provider.dart';

class VendorProductsServices extends ConsumerStatefulWidget {
  final String vendorId;
  final bool isAdd;
  const VendorProductsServices({super.key, required this.vendorId, this.isAdd = false});

  @override
  ConsumerState<VendorProductsServices> createState() => _VendorProductsServicesState();
}

class _VendorProductsServicesState extends ConsumerState<VendorProductsServices>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // Load products for this vendor
    Future.microtask(() {
      ref.read(productProvider.notifier).load(widget.vendorId);
      ref.read(serviceProvider.notifier).load(widget.vendorId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(vendorId: widget.vendorId, isAdd: true),
      ),
    );
  }

  void _addService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceListScreen(vendorId: widget.vendorId, isAdd: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final serviceState = ref.watch(serviceProvider);
    final vendorServices = serviceState
        .where((s) => s.vendorId == widget.vendorId)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Catalog"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Products"),
            Tab(text: "Services"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(productState),
          _buildList(vendorServices, "service"),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _addProduct,
              tooltip: "Add Product",
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _addService,
              tooltip: "Add Service",
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildProductList(ProductState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }
    final items = state.products;
    if (items.isEmpty) {
      return const Center(child: Text("No products found for this vendor."));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item.name),
            subtitle: const Text("Product"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // You can navigate to detail/edit screen here
            },
          ),
        );
      },
    );
  }

  Widget _buildList(List items, String type) {
    if (items.isEmpty) {
      return Center(child: Text("No ${type}s found for this vendor."));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(type == "product" ? "Product" : "Service"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // You can navigate to detail/edit screen here
            },
          ),
        );
      },
    );
  }
}

