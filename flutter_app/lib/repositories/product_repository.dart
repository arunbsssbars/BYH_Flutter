import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts(String vendorId);
  Future<Product> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id, String vendorId);
}

class LocalProductRepository implements ProductRepository {
  static const _key = 'products_json';

  Future<List<Map<String, dynamic>>> _loadRaw() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> _saveRaw(List<Map<String, dynamic>> list) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(list));
  }

  @override
  Future<List<Product>> fetchProducts(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = await _loadRaw();
    return list.map(Product.fromJson).where((p) => p.vendorId == vendorId).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final list = await _loadRaw();
    list.add(product.toJson());
    await _saveRaw(list);
    return product;
  }

  @override
  Future<void> updateProduct(Product product) async {
    final list = await _loadRaw();
    final idx = list.indexWhere((e) => e['id'] == product.id);
    if (idx != -1) {
      list[idx] = product.toJson();
      await _saveRaw(list);
    }
  }

  @override
  Future<void> deleteProduct(String id, String vendorId) async {
    final list = await _loadRaw();
    list.removeWhere((e) => e['id'] == id && e['vendorId'] == vendorId);
    await _saveRaw(list);
  }
}
