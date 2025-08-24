import 'service.dart';

class ServiceBooking {
  final Service service;
  int quantity; // e.g. number of hours/sessions/projects

  ServiceBooking({required this.service, this.quantity = 1});

  double get totalPrice => service.price * quantity;
}
