import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/service_form_screen.dart';
import '../../providers/service_provider.dart';
import '../../widgets/service_card.dart';

class ServiceListScreen extends ConsumerWidget {
  final String vendorId;
  const ServiceListScreen({super.key, required this.vendorId, required bool isAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider);
    final vendorServices = services.where((s) => s.vendorId == vendorId).toList();

    return Scaffold(
      /* appBar: AppBar(title: const Text('My Services')), */
      body: RefreshIndicator(
        onRefresh: () async => ref.read(serviceProvider.notifier).load(vendorId),
        child: vendorServices.isEmpty
            ? const Center(child: Text('No services yet'))
            : ListView.separated(
                itemCount: vendorServices.length,
                padding: const EdgeInsets.all(6),
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  return ServiceCard(service: vendorServices[index]);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceFormScreen(vendorId: vendorId),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }
}
