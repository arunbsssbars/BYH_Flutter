import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../repositories/order_firestore_repository.dart';

final _orderRepoProvider = Provider<OrderRepository>((ref) {
  return FirestoreOrderRepository();
});

// commands
class OrderCommandNotifier extends StateNotifier<bool> {
  // loading flag
  OrderCommandNotifier(this._repo) : super(false);
  final OrderRepository _repo;
  final _uuid = const Uuid();

  Future<String> placeOrder({
    required String customerId,
    required String vendorId,
    required List<ProductOrderItem> products,
    required List<ServiceOrderItem> services,
    required double total,
  }) async {
    state = true;
    final id = _uuid.v4();
    final order = Order(
      id: id,
      customerId: customerId,
      vendorId: vendorId,
      date: DateTime.now(),
      products: products,
      services: services,
      total: total,
      status: OrderStatus.pending,
    );
    await _repo.createOrder(order);
    state = false;
    return id;
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    state = true;
    await _repo.updateStatus(orderId, status);
    state = false;
  }
}

final orderCommandProvider =
    StateNotifierProvider<OrderCommandNotifier, bool>((ref) {
  return OrderCommandNotifier(ref.read(_orderRepoProvider));
});

// streams
final adminOrdersProvider = StreamProvider<List<Order>>((ref) {
  return ref.read(_orderRepoProvider).adminOrdersStream();
});

final vendorOrdersProvider =
    StreamProvider.family<List<Order>, String>((ref, vendorId) {
  return ref.read(_orderRepoProvider).vendorOrdersStream(vendorId);
});

final customerOrdersProvider =
    StreamProvider.family<List<Order>, String>((ref, customerId) {
  return ref.read(_orderRepoProvider).customerOrdersStream(customerId);
});
