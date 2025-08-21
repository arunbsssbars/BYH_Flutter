import 'package:flutter/material.dart';
import 'vendor_products.dart';
import 'vendor_orders.dart';

class VendorDashboard extends StatelessWidget { const VendorDashboard({super.key}); @override Widget build(BuildContext context){
  return Scaffold(appBar: AppBar(title: const Text('Vendor Dashboard')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children:[ ElevatedButton(child: const Text('Products'), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const VendorProducts()))), const SizedBox(height:8), ElevatedButton(child: const Text('Orders'), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const VendorOrders()))), ]),),);
} }
