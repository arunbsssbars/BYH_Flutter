import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_stop_house_builder/models/vendor.dart';
import 'package:one_stop_house_builder/providers/vendor_provider.dart'; // adjust import as needed

class VendorProfileUpdateScreen extends ConsumerStatefulWidget {
  final String vendorId;
  const VendorProfileUpdateScreen({super.key, required this.vendorId});

  @override
  ConsumerState<VendorProfileUpdateScreen> createState() => _VendorProfileUpdateScreenState();
}

class _VendorProfileUpdateScreenState extends ConsumerState<VendorProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _categoryController;
  late TextEditingController _addressController;

  Vendor? _vendor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVendor();
  }

  void _fetchVendor() {
    final state = ref.read(vendorProvider);
    final vendor = state.vendors.firstWhere(
      (v) => v.id == widget.vendorId,
      orElse: () => const Vendor(
        id: '',
        name: '',
        email: '',
        phone: '',
        category: '',
        address: '',
        isVerified: false,
        rating: 0.0,
      ),
    );
    setState(() {
      _vendor = vendor.id.isEmpty ? null : vendor;
      _isLoading = false;
      _nameController = TextEditingController(text: vendor.name);
      _emailController = TextEditingController(text: vendor.email);
      _phoneController = TextEditingController(text: vendor.phone);
      _categoryController = TextEditingController(text: vendor.category);
      _addressController = TextEditingController(text: vendor.address);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _categoryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedVendor = _vendor!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        category: _categoryController.text,
        address: _addressController.text,
      );
      await ref.read(vendorProvider.notifier).updateVendor(updatedVendor);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vendor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

