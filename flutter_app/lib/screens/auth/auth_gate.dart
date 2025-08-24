import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_dashboard.dart';
import 'customer_home.dart';
import 'admin_dashboard.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  Future<String?> _fetchUserRole(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()!['role'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("Please Login")));
        }

        final user = snapshot.data!;
        return FutureBuilder<String?>(
          future: _fetchUserRole(user.uid),
          builder: (context, roleSnap) {
            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (!roleSnap.hasData) {
              return const Scaffold(
                  body: Center(child: Text("Role not assigned")));
            }

            switch (roleSnap.data) {
              case "vendor":
                return VendorDashboard(vendorId: user.uid);
              case "admin":
                return const AdminDashboard();
              default:
                return const CustomerHome();
            }
          },
        );
      },
    );
  }
}
