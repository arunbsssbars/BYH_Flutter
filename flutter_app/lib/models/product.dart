class Product {
  final String id;
  final String vendorId;
  final String name;
  final String category; // e.g., Cement, Tiles, Paint
  final String description;
  final double price;
  final String unit; // e.g., per bag, per sq.ft
  final String imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      vendorId: json['vendorId'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'],
      imageUrl: json['imageUrl'],
      inStock: json['inStock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'inStock': inStock,
    };
  }
}
