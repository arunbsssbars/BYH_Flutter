import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/service_provider.dart';
import '../../providers/service_booking_provider.dart';

class CustomerServiceListScreen extends ConsumerWidget {
  final String vendorId;
  const CustomerServiceListScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider);
    final vendorServices =
        services.where((s) => s.vendorId == vendorId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Services')),
      body: vendorServices.isEmpty
          ? const Center(child: Text('No services available'))
          : ListView.builder(
              itemCount: vendorServices.length,
              itemBuilder: (context, index) {
                final service = vendorServices[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(service.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                    title: Text(service.name),
                    subtitle: Text('${service.price} ₹ / ${service.unit}\n${service.category}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        ref.read(serviceBookingProvider.notifier).addService(service);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${service.name} added to bookings')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.event_available),
        onPressed: () {
          Navigator.pushNamed(context, '/serviceBookings');
        },
      ),
    );
  }
}
