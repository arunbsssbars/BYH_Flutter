import 'package:flutter/material.dart';

class VendorDashboard extends StatelessWidget {
  final String vendorId;
  const VendorDashboard({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Dashboard")),
      body: Column(
        children: [
          ListTile(
            title: const Text("Manage Products"),
            trailing: const Icon(Icons.shopping_bag),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VendorProductsScreen(vendorId: vendorId),
              ),
            ),
          ),
          ListTile(
            title: const Text("Manage Services"),
            trailing: const Icon(Icons.build),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VendorServicesScreen(vendorId: vendorId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
