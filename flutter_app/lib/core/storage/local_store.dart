import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static const _vendorsKey = 'vendors_json';

  LocalStore._();
  static final LocalStore instance = LocalStore._();

  Future<List<Map<String, dynamic>>> getVendors() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_vendorsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveVendors(List<Map<String, dynamic>> list) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_vendorsKey, jsonEncode(list));
  }

  Future<void> clearVendors() async {
   /*  final sp = await SharedPreferences.getInstance();
    await sp.remove(_vendorsKey); */
  }
}
