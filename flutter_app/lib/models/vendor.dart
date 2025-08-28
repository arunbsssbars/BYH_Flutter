class Vendor {
  final String id;
  final String name;
  final String category; // Cement Supplier, Plumber, Architect, etc.
  final String phone;
  final String email;
  final String address;
  final bool isVerified;
  final double rating;

  const Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.email,
    required this.address,
    this.isVerified = false,
    this.rating = 0.0,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      isVerified: (json['isVerified'] as bool?) ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  get vendorId => null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'phone': phone,
        'email': email,
        'address': address,
        'isVerified': isVerified,
        'rating': rating,
      };

  Vendor copyWith({
    String? id,
    String? name,
    String? category,
    String? phone,
    String? email,
    String? address,
    bool? isVerified,
    double? rating,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
    );
  }
}
