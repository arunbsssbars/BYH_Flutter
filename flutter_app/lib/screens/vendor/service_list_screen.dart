import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/service_provider.dart';
import 'service_form_screen.dart';
import '../../widgets/service_card.dart';

class ServiceListScreen extends ConsumerWidget {
  final String vendorId;
  const ServiceListScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider);
    final vendorServices = services.where((s) => s.vendorId == vendorId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Services')),
      body: vendorServices.isEmpty
          ? const Center(child: Text('No services yet'))
          : ListView.builder(
              itemCount: vendorServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(service: vendorServices[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceFormScreen(vendorId: vendorId),
            ),
          );
        },
      ),
    );
  }
}
