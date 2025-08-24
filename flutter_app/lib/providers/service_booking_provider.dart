import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service.dart';
import '../models/service_booking.dart';

class ServiceBookingNotifier extends StateNotifier<List<ServiceBooking>> {
  ServiceBookingNotifier() : super([]);

  void addService(Service service) {
    final index = state.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      final updated = [...state];
      updated[index].quantity++;
      state = updated;
    } else {
      state = [...state, ServiceBooking(service: service)];
    }
  }

  void removeService(String serviceId) {
    state = state.where((item) => item.service.id != serviceId).toList();
  }

  void updateQuantity(String serviceId, int quantity) {
    final updated = [...state];
    final index = updated.indexWhere((item) => item.service.id == serviceId);
    if (index >= 0) {
      updated[index].quantity = quantity;
      state = updated;
    }
  }

  double get total =>
      state.fold(0, (sum, item) => sum + item.totalPrice);

  void clear() => state = [];
}

final serviceBookingProvider =
    StateNotifierProvider<ServiceBookingNotifier, List<ServiceBooking>>(
        (ref) => ServiceBookingNotifier());
