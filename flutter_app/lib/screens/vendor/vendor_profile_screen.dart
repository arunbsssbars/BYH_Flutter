import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/providers/vendor_provider.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_settings_screen.dart';
import 'vendor_login_screen.dart';

class VendorProfileScreen extends ConsumerWidget {
  final String vendorId;
  const VendorProfileScreen({super.key, required this.vendorId});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorProvider);

    if (state.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final vendor = state.vendors.firstWhere(
      (v) => v.id == vendorId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text("Vendor Name: ${vendor.name.slice(0, 1).toUpperCase()}${vendor.name.substring(1)}", style: const TextStyle(fontSize: 18)),
          Text("Category: ${vendor.category}"),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VendorSettingsScreen(vendorId: vendor.id,)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

extension on String {
  slice(int i, int j) {
    return substring(i, j);
  }
}
