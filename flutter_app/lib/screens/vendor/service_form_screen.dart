import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/service.dart';
import '../../providers/service_provider.dart';

class ServiceFormScreen extends ConsumerStatefulWidget {
  final String vendorId;
  final Service? existing;

  const ServiceFormScreen({super.key, required this.vendorId, this.existing});

  @override
  ConsumerState<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends ConsumerState<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _desc;
  late final TextEditingController _price;
  late final TextEditingController _unit;
  late final TextEditingController _image;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _category = TextEditingController(text: e?.category ?? '');
    _desc = TextEditingController(text: e?.description ?? '');
    _price = TextEditingController(text: e != null ? e.price.toString() : '');
    _unit = TextEditingController(text: e?.unit ?? '');
    _image = TextEditingController(text: e?.imageUrl ?? '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.existing == null) {
      await ref.read(serviceProvider.notifier).addService(
            vendorId: widget.vendorId,
            name: _name.text,
            category: _category.text,
            description: _desc.text,
            price: double.tryParse(_price.text) ?? 0,
            unit: _unit.text,
            imageUrl: _image.text.isNotEmpty ? _image.text : 'https://via.placeholder.com/150',
          );
    } else {
      final updated = widget.existing!.copyWith(
        name: _name.text,
        category: _category.text,
        description: _desc.text,
        price: double.tryParse(_price.text) ?? 0,
        unit: _unit.text,
        imageUrl: _image.text,
      );
      await ref.read(serviceProvider.notifier).updateService(updated);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Service' : 'Add Service')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _unit,
                decoration: const InputDecoration(labelText: 'Unit (per hour/project)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: _save,
                label: Text(isEditing ? 'Update Service' : 'Save Service'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
