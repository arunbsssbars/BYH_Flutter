import 'product.dart';
import 'service.dart';

enum OrderStatus { pending, confirmed, completed, cancelled }

class ProductOrderItem {
  final Product product;
  final int quantity;
  ProductOrderItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory ProductOrderItem.fromMap(Map<String, dynamic> map) {
    return ProductOrderItem(
      product: Product.fromJson(Map<String, dynamic>.from(map['product'])),
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}

class ServiceOrderItem {
  final Service service;
  final int quantity;
  ServiceOrderItem({required this.service, required this.quantity});

  double get totalPrice => service.price * quantity;

  Map<String, dynamic> toMap() => {
        'service': {
          'id': service.id,
          'vendorId': service.vendorId,
          'name': service.name,
          'category': service.category,
          'description': service.description,
          'price': service.price,
          'unit': service.unit,
          'imageUrl': service.imageUrl,
        },
        'quantity': quantity,
      };

  factory ServiceOrderItem.fromMap(Map<String, dynamic> map) {
    final s = Map<String, dynamic>.from(map['service']);
    return ServiceOrderItem(
      service: Service(
        id: s['id'],
        vendorId: s['vendorId'],
        name: s['name'],
        category: s['category'],
        description: s['description'],
        price: (s['price'] as num).toDouble(),
        unit: s['unit'],
        imageUrl: s['imageUrl'],
      ),
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}

class Order {
  final String id;
  final String customerId;
  final String vendorId;
  final DateTime date;
  final List<ProductOrderItem> products;
  final List<ServiceOrderItem> services;
  final OrderStatus status;
  final double total; // snapshot at time of payment

  Order({
    required this.id,
    required this.customerId,
    required this.vendorId,
    required this.date,
    this.products = const [],
    this.services = const [],
    this.status = OrderStatus.pending,
    required this.total,
  });

  Order copyWith({OrderStatus? status}) => Order(
        id: id,
        customerId: customerId,
        vendorId: vendorId,
        date: date,
        products: products,
        services: services,
        status: status ?? this.status,
        total: total,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'customerId': customerId,
        'vendorId': vendorId,
        'date': date.toUtc().millisecondsSinceEpoch,
        'status': status.name,
        'total': total,
        'products': products.map((e) => e.toMap()).toList(),
        'services': services.map((e) => e.toMap()).toList(),
      };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerId: map['customerId'],
      vendorId: map['vendorId'],
      date: DateTime.fromMillisecondsSinceEpoch((map['date'] as num).toInt(), isUtc: true).toLocal(),
      status: OrderStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => OrderStatus.pending),
      total: (map['total'] as num).toDouble(),
      products: (map['products'] as List<dynamic>).map((e) => ProductOrderItem.fromMap(Map<String, dynamic>.from(e))).toList(),
      services: (map['services'] as List<dynamic>).map((e) => ServiceOrderItem.fromMap(Map<String, dynamic>.from(e))).toList(),
    );
  }
}
