import 'package:flutter/material.dart';
import 'customer_cart_screen.dart';
import 'customer_home_screen.dart';
import 'customer_profile_screen.dart';

class CustomerMainScreen extends StatefulWidget { const CustomerMainScreen({super.key}); @override State<CustomerMainScreen> createState() => _CustomerMainScreenState(); }

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [CustomerHomeScreen(), CustomerCartScreen(), CustomerProfileScreen()];
  void _onItemTapped(int index) => setState(()=>_selectedIndex=index);

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
