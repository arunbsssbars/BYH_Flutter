import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/vendor/product_list_screen.dart';
import 'package:one_stop_house_builder/screens/vendor/service_list_screen.dart';


class VendorProductsServices extends ConsumerStatefulWidget {
  final String vendorId;
  const VendorProductsServices({super.key, required this.vendorId});

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ProductListScreen(vendorId: widget.vendorId, isAdd: true),
          ServiceListScreen(vendorId: widget.vendorId, isAdd: true),
        ],
      ),
    );
  }
}

