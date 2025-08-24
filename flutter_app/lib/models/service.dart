class Service {
  final String id;
  final String vendorId;
  final String name;
  final String category; // e.g. Plumbing, Architecture, Electrical
  final String description;
  final double price; // optional, per visit/hour/project
  final String unit; // e.g. per hour, per project
  final String imageUrl;

  Service({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.unit,
    required this.imageUrl,
  });

  Service copyWith({
    String? id,
    String? vendorId,
    String? name,
    String? category,
    String? description,
    double? price,
    String? unit,
    String? imageUrl,
  }) {
    return Service(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
