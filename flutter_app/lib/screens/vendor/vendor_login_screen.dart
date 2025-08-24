import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/screens/vendor/vendor_registration_screen.dart';
import 'vendor_home.dart';
import 'package:one_stop_house_builder/providers/vendor_provider.dart';

class VendorLoginScreen extends ConsumerStatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  ConsumerState<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends ConsumerState<VendorLoginScreen> {
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(vendorProvider.notifier).load());
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final vendors = ref.read(vendorProvider).vendors;
    final vendor = vendors.firstWhereOrNull((v) => v.name == username);

    if (vendor != null && password == "123") {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VendorHome()),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid credentials";
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToRegister() async {
    final newUserid = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const VendorRegistrationScreen()),
    );
    if (newUserid != null) {
      setState(() {
        _usernameController.text = newUserid;
        _passwordController.text = "123";
        _errorMessage = "Registered successfully! Please login.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _LoginCard(
            usernameController: _usernameController,
            passwordController: _passwordController,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            onLogin: _login,
            onRegister: _navigateToRegister,
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _LoginCard({
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.errorMessage,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Vendor Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "User Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : onLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRegister,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension method for firstWhereOrNull
extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
