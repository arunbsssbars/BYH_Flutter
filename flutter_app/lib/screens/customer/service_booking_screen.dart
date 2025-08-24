import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/service_booking_provider.dart';

class ServiceBookingScreen extends ConsumerWidget {
  const ServiceBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(serviceBookingProvider);
    final bookingProvider = ref.read(serviceBookingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('No services booked'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final item = bookings[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(item.service.imageUrl, width: 48, height: 48),
                    title: Text(item.service.name),
                    subtitle: Text('${item.quantity} × ${item.service.price} ₹ / ${item.service.unit}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 1) {
                              bookingProvider.updateQuantity(item.service.id, item.quantity - 1);
                            } else {
                              bookingProvider.removeService(item.service.id);
                            }
                          },
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            bookingProvider.updateQuantity(item.service.id, item.quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // TODO: save to backend
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Service booking confirmed!')),
            );
            bookingProvider.clear();
          },
          child: Text('Confirm Booking (${bookingProvider.total.toStringAsFixed(2)} ₹)'),
        ),
      ),
    );
  }
}
