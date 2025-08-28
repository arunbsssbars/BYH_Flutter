import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_profile_update_screen.dart';
import '../../providers/vendor_provider.dart'; // Adjust the import path as needed

class VendorProfileDetailsScreen extends ConsumerWidget {
  final String vendorId;
  const VendorProfileDetailsScreen({super.key, required this.vendorId});

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
      appBar: AppBar(
        title: const Text('Vendor Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VendorProfileUpdateScreen(vendorId: vendorId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                vendor.name.slice(0, 1).toUpperCase() + vendor.name.substring(1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                vendor.category, // Show category
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vendor.isVerified ? Icons.verified : Icons.verified_outlined,
                    color: vendor.isVerified ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    vendor.isVerified ? 'Verified' : 'Not Verified',
                    style: TextStyle(
                      color: vendor.isVerified ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    vendor.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(vendor.email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone'),
                        subtitle: Text(vendor.phone),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Address'),
                        subtitle: Text(vendor.address),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Update Profile'),
                onPressed: () {
                  // Edit functionality placeholder
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VendorProfileUpdateScreen(vendorId: vendorId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  slice(int i, int j) {
    return substring(i, j);
  }
}
