import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/service.dart';

class ServiceNotifier extends StateNotifier<List<Service>> {
  ServiceNotifier() : super([]);

  final _uuid = const Uuid();

  Future<bool> addService({
    required String vendorId,
    required String name,
    required String category,
    required String description,
    required double price,
    required String unit,
    required String imageUrl,
  }) async {
    final service = Service(
      id: _uuid.v4(),
      vendorId: vendorId,
      name: name,
      category: category,
      description: description,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
    );
    state = [...state, service];
    return true;
  }

  Future<void> updateService(Service updated) async {
    state = state.map((s) => s.id == updated.id ? updated : s).toList();
  }

  Future<void> deleteService(String serviceId, String vendorId) async {
    state = state.where((s) => s.id != serviceId).toList();
  }
}

final serviceProvider =
    StateNotifierProvider<ServiceNotifier, List<Service>>((ref) => ServiceNotifier());
