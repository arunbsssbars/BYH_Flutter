import 'package:flutter/material.dart';

class VendorProductsServices extends StatefulWidget {
  const VendorProductsServices({super.key});

  @override
  State<VendorProductsServices> createState() => _VendorProductsServicesState();
}

class _VendorProductsServicesState extends State<VendorProductsServices>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _catalog = [
    {"name": "Cement", "type": "product"},
    {"name": "Concrete Mix", "type": "product"},
    {"name": "Plumbing Service", "type": "service"},
    {"name": "Electrical Service", "type": "service"},
  ];

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

  List<Map<String, dynamic>> _getFiltered(String type) {
    return _catalog.where((c) => c["type"] == type).toList();
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
          _buildList("product"),
          _buildList("service"),
        ],
      ),
    );
  }

  Widget _buildList(String type) {
    final filtered = _getFiltered(type);
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          child: ListTile(
            title: Text(item["name"]),
            subtitle: Text(type == "product" ? "Product" : "Service"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
    );
  }
}
