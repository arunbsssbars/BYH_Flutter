import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<dynamic>> getProducts({String? vendorId}) async {
    final url = Uri.parse('$baseUrl/products${vendorId!=null? '?vendorId=$vendorId':''}');
    final res = await http.get(url);
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String,dynamic>> createOrder(Map<String,dynamic> payload) async {
    final url = Uri.parse('$baseUrl/orders');
    final res = await http.post(url, body: jsonEncode(payload), headers: {'Content-Type': 'application/json'});
    return jsonDecode(res.body) as Map<String,dynamic>;
  }

  Future<List<dynamic>> getOrders({String? vendorId}) async {
    final url = Uri.parse('$baseUrl/orders${vendorId!=null? '?vendorId=$vendorId':''}');
    final res = await http.get(url);
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String,dynamic>> updateOrderStatus(String orderId, String status) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/status');
    final res = await http.put(url, body: jsonEncode({'status': status}), headers: {'Content-Type': 'application/json'});
    return jsonDecode(res.body) as Map<String,dynamic>;
  }

  Future<Map<String,dynamic>> createProduct(Map<String,dynamic> payload) async {
    final url = Uri.parse('$baseUrl/products');
    final res = await http.post(url, body: jsonEncode(payload), headers: {'Content-Type': 'application/json'});
    return jsonDecode(res.body) as Map<String,dynamic>;
  }

  Future<Map<String,dynamic>> updateProduct(String productId, Map<String,dynamic> payload) async {
    final url = Uri.parse('$baseUrl/products/$productId');
    final res = await http.put(url, body: jsonEncode(payload), headers: {'Content-Type': 'application/json'});
    return jsonDecode(res.body) as Map<String,dynamic>;
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse('$baseUrl/products/$productId');
    await http.delete(url);
  }
}
