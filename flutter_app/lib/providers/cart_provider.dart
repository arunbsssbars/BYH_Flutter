import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
  CartItem({required this.id, required this.name, required this.price, this.quantity=1, required this.imageUrl});
  Map<String, dynamic> toMap()=>{"id":id,"name":name,"price":price,"quantity":quantity,"imageUrl":imageUrl};
  factory CartItem.fromMap(Map<String,dynamic> map)=>CartItem(id: map['id'],name: map['name'],price: (map['price'] as num).toDouble(),quantity: map['quantity'],imageUrl: map['imageUrl']);
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items=[];
  List<CartItem> get items=>_items;
  double get totalAmount=>_items.fold(0,(sum,item)=>sum+(item.price*item.quantity));

  Future<void> loadCart() async{
    final prefs=await SharedPreferences.getInstance();
    final data=prefs.getString("cartItems");
    if(data!=null){
      try{
        final decoded=jsonDecode(data) as List;
        _items=decoded.map((e)=>CartItem.fromMap(e)).toList();
        notifyListeners();
      }catch(e){}
    }
  }
  Future<void> saveCart() async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString("cartItems",jsonEncode(_items.map((e)=>e.toMap()).toList()));
  }
  void addItem(CartItem item){ final index=_items.indexWhere((i)=>i.id==item.id); if(index>=0)_items[index].quantity++; else _items.add(item); saveCart(); notifyListeners(); }
  void removeItem(String id){ _items.removeWhere((i)=>i.id==id); saveCart(); notifyListeners(); }
  void increaseQty(String id){ final item=_items.firstWhere((i)=>i.id==id); item.quantity++; saveCart(); notifyListeners(); }
  void decreaseQty(String id){ final item=_items.firstWhere((i)=>i.id==id); if(item.quantity>1)item.quantity--; else removeItem(id); saveCart(); notifyListeners(); }
}
