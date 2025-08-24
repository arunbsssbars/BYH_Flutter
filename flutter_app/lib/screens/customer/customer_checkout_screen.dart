import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/service_booking_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';
import '../../services/payment_service.dart';

class CustomerCheckoutScreen extends ConsumerStatefulWidget {
  final String vendorId;
  final String customerId;

  const CustomerCheckoutScreen({
    super.key,
    required this.vendorId,
    required this.customerId,
  });

  @override
  ConsumerState<CustomerCheckoutScreen> createState() => _CustomerCheckoutScreenState();
}

class _CustomerCheckoutScreenState extends ConsumerState<CustomerCheckoutScreen> {
  late PaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService();
    _paymentService.init(
      onSuccess: _onPaymentSuccess,
      onError: _onPaymentError,
      onExternalWallet: _onExternalWallet,
    );
  }

  void _onPaymentSuccess(dynamic res) async {
    final verified = await _paymentService.verifyPayment(
      orderId: res.orderId!,
      paymentId: res.paymentId!,
      signature: res.signature!,
    );
    if (verified) {
      // _handleOrderPlacement();
      _createOrderInFirestore(); // Call to create order in Firestore
    } else {
      _showSnackBar("Payment verification failed");
    }
  }

  void _onPaymentError(dynamic res) {
    _showSnackBar("Payment Failed: ${res.message}");
  }

  void _onExternalWallet(dynamic res) {
    _showSnackBar("External Wallet: ${res.walletName}");
  }

void _createOrderInFirestore() async {
  final cartItems = ref.read(cartProvider);
  final serviceBookings = ref.read(serviceBookingProvider);

  final products = cartItems
      .map((c) => ProductOrderItem(product: c.product, quantity: c.quantity))
      .toList();
  final services = serviceBookings
      .map((s) => ServiceOrderItem(service: s.service, quantity: s.quantity))
      .toList();

  final total = cartItems.fold<double>(0, (sum, i) => sum + i.totalPrice) +
      serviceBookings.fold<double>(0, (sum, i) => sum + i.totalPrice);

  await ref.read(orderCommandProvider.notifier).placeOrder(
        customerId: widget.customerId,
        vendorId: widget.vendorId,
        products: products,
        services: services,
        total: total,
      );

  ref.read(cartProvider.notifier).clear();
  ref.read(serviceBookingProvider.notifier).clear();

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Success! Order Placed.')),
    );
    Navigator.pop(context);
  }
}


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onPayPressed(double total) async {
    final orderId = await _paymentService.createOrder(total);
    if (orderId != null) {
      _paymentService.openCheckout(
        orderId: orderId,
        amount: total,
        customerName: "Customer ${widget.customerId}",
        customerEmail: "customer@example.com",
        customerPhone: "9876543210",
      );
    } else {
      _showSnackBar("Failed to create order");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final serviceBookings = ref.watch(serviceBookingProvider);

    final total = cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice) +
        serviceBookings.fold<double>(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...cartItems.map((c) => ListTile(
                title: Text(c.product.name),
                subtitle: Text('${c.quantity} × ${c.product.price} ₹'),
              )),
          const SizedBox(height: 16),
          const Text('Services:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...serviceBookings.map((s) => ListTile(
                title: Text(s.service.name),
                subtitle: Text('${s.quantity} × ${s.service.price} ₹ / ${s.service.unit}'),
              )),
          const Divider(),
          Text('Total: ₹ $total', style: const TextStyle(fontSize: 20)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _onPayPressed(total),
          child: Text('Pay & Confirm (₹ $total)'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }
}
