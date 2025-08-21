import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/socket_service.dart';

class VendorOrders extends StatefulWidget { const VendorOrders({super.key}); @override State<VendorOrders> createState()=>_VendorOrdersState(); }

class _VendorOrdersState extends State<VendorOrders> {
  List<dynamic> orders = [];
  final api = ApiService('http://10.0.2.2:3000');
  late SocketService socketService;

  @override void initState(){ super.initState(); _load(); socketService = SocketService('http://10.0.2.2:3000'); socketService.connect(vendorId: 'v1', onNewOrder: (data){ setState(()=>orders.insert(0,data)); }, onOrderUpdated: (data){ final idx = orders.indexWhere((o)=>o['id']==data['id']); if(idx>=0) setState(()=>orders[idx]=data); }); }
  @override void dispose(){ socketService.disconnect(); super.dispose(); }

  Future<void> _load() async { final o = await api.getOrders(vendorId: 'v1'); setState(()=>orders=o); }
  Future<void> _nextStatus(String id) async { final idx = orders.indexWhere((o)=>o['id']==id); if(idx==-1) return; final current = orders[idx]['status']; String next = current=='Pending'?'Confirmed': current=='Confirmed'?'In Progress':'Completed'; await api.updateOrderStatus(id, next); await _load(); }

  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Vendor Orders')), body: orders.isEmpty? const Center(child: Text('No orders')): ListView.builder(itemCount: orders.length,itemBuilder:(ctx,i){ final o=orders[i]; return ListTile(title: Text('Order ${o['id']} - ${o['customerName']}'), subtitle: Text('Total: ₹${o['total']} • Status: ${o['status']}'), trailing: ElevatedButton(child: const Text('Next'), onPressed: ()=>_nextStatus(o['id'])),); }), );
  }
}
