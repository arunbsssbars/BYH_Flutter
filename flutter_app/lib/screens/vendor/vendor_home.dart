import 'package:flutter/material.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_products_services.dart' show VendorProductsServices;
import 'vendor_profile_screen.dart';

class VendorHome extends StatefulWidget {
  final dynamic vendorId;

  const VendorHome({super.key, required this.vendorId});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      VendorProductsServices(vendorId: widget.vendorId),
      VendorProfileScreen(vendorId: widget.vendorId),
    ];
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
