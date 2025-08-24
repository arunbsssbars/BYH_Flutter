import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';

abstract class OrderRepository {
  Future<void> createOrder(Order order);
  Future<void> updateStatus(String orderId, OrderStatus status);
  Stream<List<Order>> adminOrdersStream();
  Stream<List<Order>> vendorOrdersStream(String vendorId);
  Stream<List<Order>> customerOrdersStream(String customerId);
}

class FirestoreOrderRepository implements OrderRepository {
  final _orders = FirebaseFirestore.instance.collection('orders');

  @override
  Future<void> createOrder(Order order) async {
    await _orders.doc(order.id).set(order.toMap(), SetOptions(merge: false));
  }

  @override
  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _orders.doc(orderId).update({'status': status.name});
  }

  List<Order> _fromQuery(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((d) => Order.fromMap(d.data())).toList();
  }

  @override
  Stream<List<Order>> adminOrdersStream() {
    return _orders
        .orderBy('date', descending: true)
        .snapshots()
        .map(_fromQuery);
  }

  @override
  Stream<List<Order>> vendorOrdersStream(String vendorId) {
    return _orders
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(_fromQuery);
  }

  @override
  Stream<List<Order>> customerOrdersStream(String customerId) {
    return _orders
        .where('customerId', isEqualTo: customerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(_fromQuery);
  }
}
