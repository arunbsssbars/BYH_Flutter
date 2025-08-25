import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/service_form_screen.dart';
import '../models/service.dart';
import '../providers/service_provider.dart';

class ServiceCard extends ConsumerWidget {
  final Service service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Image.network(service.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
        title: Text(service.name),
        subtitle: Text('${service.price} ₹ / ${service.unit}\n${service.category}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceFormScreen(
                      vendorId: service.vendorId,
                      existing: service,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(serviceProvider.notifier).deleteService(service.id, service.vendorId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
