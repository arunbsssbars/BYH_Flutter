import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vendor_provider.dart';
import '../../widgets/vendor_card.dart';
import 'vendor_registration_screen.dart';

class VendorDashboardScreen extends ConsumerStatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  ConsumerState<VendorDashboardScreen> createState() =>
      _VendorDashboardScreenState();
}

class _VendorDashboardScreenState
    extends ConsumerState<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(vendorProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendors'),
        actions: [
          IconButton(
            tooltip: 'Register Vendor',
            onPressed: () =>
                Navigator.pushNamed(context, VendorRegistrationScreen.route),
            icon: const Icon(Icons.person_add_alt),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(vendorProvider.notifier).load(),
        child: Builder(
          builder: (context) {
            if (state.loading && state.vendors.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.vendors.isEmpty) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.vendors.isEmpty) {
              return const Center(
                child: Text(
                  'No vendors yet.\nTap + to register one.',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: state.vendors.length,
              itemBuilder: (_, i) => VendorCard(vendor: state.vendors[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, VendorRegistrationScreen.route),
        icon: const Icon(Icons.add_business),
        label: const Text('Register Vendor'),
      ),
    );
  }
}
