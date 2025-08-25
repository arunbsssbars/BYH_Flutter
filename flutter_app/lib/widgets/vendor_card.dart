import 'package:flutter/material.dart';
import 'package:one_stop_house_builder/screens/vendor/product_list_screen.dart';
import '../models/vendor.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  const VendorCard({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final verified = vendor.isVerified;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              verified ? Colors.green.shade100 : Colors.grey.shade200,
          /* backgroundImage: NetworkImage(vendor.logoUrl), */
          child: Icon(
            verified ? Icons.verified : Icons.storefront,
            color: verified ? Colors.green : Colors.black54,
          ),
        ),
        title: Text(vendor.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vendor.category),
            const SizedBox(height: 2),
            Text(vendor.address, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 14),
                const SizedBox(width: 4),
                Text(vendor.phone),
                const SizedBox(width: 12),
                const Icon(Icons.email, size: 14),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(vendor.email, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            Text(vendor.rating.toStringAsFixed(1)),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductListScreen(
                vendorId: vendor.id,
                isAdd: null,
              ),
            ),
          );
        },
      ),
    );
  }
}
