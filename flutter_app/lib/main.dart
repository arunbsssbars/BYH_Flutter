import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/customer/customer_main_screen.dart';
import 'screens/vendor/vendor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartProvider = CartProvider();
  await cartProvider.loadCart();
  runApp(MyApp(cartProvider: cartProvider));
}

class MyApp extends StatelessWidget {
  final CartProvider cartProvider;
  const MyApp({super.key, required this.cartProvider});

  @override Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: cartProvider)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'One Stop House Builder',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const CustomerMainScreen(),
        routes: {
          '/vendor': (ctx) => const VendorDashboard(),
        },
      ),
    );
  }
}
