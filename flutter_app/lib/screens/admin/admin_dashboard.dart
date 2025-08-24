import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final vendors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final v = vendors[index];
              return Card(
                child: ListTile(
                  title: Text(v['name']),
                  subtitle: Text(v['approved'] == true ? "✅ Approved" : "❌ Pending"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vendors')
                              .doc(v.id)
                              .update({'approved': true});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.block, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vendors')
                              .doc(v.id)
                              .update({'approved': false});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
