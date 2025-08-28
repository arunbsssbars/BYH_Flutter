import 'package:flutter/material.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_profile_details_screen.dart';

class VendorSettingsScreen extends StatefulWidget {
  final String vendorId;
  const VendorSettingsScreen({super.key, required this.vendorId});

  @override
  State<VendorSettingsScreen> createState() => _VendorSettingsScreenState();
}

class _VendorSettingsScreenState extends State<VendorSettingsScreen> {
  bool _notificationsEnabled = true;

  void _onLogout() {
    // Implement logout logic here
    // For example: Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            subtitle: const Text("Edit your profile"),
            onTap: () {
              // Navigate to profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VendorProfileDetailsScreen(vendorId: widget.vendorId)),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              // Show about dialog or navigate to about page
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onLogout,
        label: const Text("Logout"),
        icon: const Icon(Icons.logout),
      ),
    );
  }
}