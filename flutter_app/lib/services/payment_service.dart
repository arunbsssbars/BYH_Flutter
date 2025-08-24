import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  Future<String?> createOrder(double amount) async {
    final response = await http.post(
      Uri.parse("http://localhost:5000/create-order"), // 🔴 replace with your backend URL
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "amount": amount,
        "currency": "INR",
        "receipt": "rcpt_${DateTime.now().millisecondsSinceEpoch}",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['orderId'];
    }
    return null;
  }

  void openCheckout({
    required String orderId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) {
    var options = {
      'key': 'rzp_test_1234567890abcdef', // Razorpay Key
      'amount': (amount * 100).toInt(),
      'name': 'One Stop House Builder',
      'order_id': orderId, // 🔑 Important: Backend-generated Order ID
      'description': 'House Builder Order',
      'prefill': {
        'contact': customerPhone,
        'email': customerEmail,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    _razorpay.open(options);
  }

  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final response = await http.post(
      Uri.parse("http://localhost:5000/verify-payment"), // backend endpoint
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "orderId": orderId,
        "paymentId": paymentId,
        "signature": signature,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'];
    }
    return false;
  }

  void dispose() {
    _razorpay.clear();
  }
}
