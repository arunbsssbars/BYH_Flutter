import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/socket_service.dart';

class VendorProducts extends StatefulWidget { const VendorProducts({super.key}); @override State<VendorProducts> createState()=>_VendorProductsState(); }

class _VendorProductsState extends State<VendorProducts> {
  List<dynamic> products = [];
  final api = ApiService('http://10.0.2.2:3000');
  late SocketService socketService;

  @override void initState(){ super.initState(); _load(); socketService = SocketService('http://10.0.2.2:3000'); socketService.connect(vendorId: 'v1', onProductUpdated: (data){ _load(); }); }
  @override void dispose(){ socketService.disconnect(); super.dispose(); }

  Future<void> _load() async { final p = await api.getProducts(vendorId: 'v1'); setState(()=>products=p); }
  Future<void> _add() async { final payload={'vendorId':'v1','name':'New Prod','description':'Desc','price':100,'imageUrl':'https://via.placeholder.com/150'}; await api.createProduct(payload); await _load(); }
  Future<void> _edit(String id) async { await api.updateProduct(id, {'name':'Edited ${DateTime.now().millisecondsSinceEpoch}'}); await _load(); }
  Future<void> _delete(String id) async { await api.deleteProduct(id); await _load(); }

  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Vendor Products'), actions: [ IconButton(icon: const Icon(Icons.add), onPressed: _add) ]), body: products.isEmpty? const Center(child: Text('No products')): ListView.builder(itemCount: products.length,itemBuilder:(ctx,i){ final p=products[i]; return ListTile(leading: Image.network(p['imageUrl'],width:50,height:50,fit:BoxFit.cover), title: Text(p['name']), subtitle: Text('₹${p['price']}'), trailing: Row(mainAxisSize: MainAxisSize.min, children:[ IconButton(icon: const Icon(Icons.edit), onPressed: ()=>_edit(p['id'])), IconButton(icon: const Icon(Icons.delete), onPressed: ()=>_delete(p['id'])), ]), ); }), );
  }
}
