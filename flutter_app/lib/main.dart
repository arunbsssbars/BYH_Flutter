import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_login_screen.dart';
import 'screens/vendor/vendor_registration_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: OneStopApp()));
}

class OneStopApp extends StatelessWidget {
  const OneStopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF006E5B),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );

    return MaterialApp(
      title: 'One Stop House Builder',
      theme: theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const VendorLoginScreen(),
        '/vendorRegistration': (_) => const VendorRegistrationScreen(),
      },
      initialRoute: '/',
    );
  }
}
