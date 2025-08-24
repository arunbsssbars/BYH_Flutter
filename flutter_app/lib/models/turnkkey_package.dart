class TurnkeyPackage {
  final String id;
  final String name; // e.g., Economy 2BHK, Luxury Villa
  final double estimatedCost;
  final double areaSqFt;
  final String description;
  final List<String> includedServices; // IDs of Service
  final List<String> includedProducts; // IDs of Product
  final int estimatedDays;

  TurnkeyPackage({
    required this.id,
    required this.name,
    required this.estimatedCost,
    required this.areaSqFt,
    required this.description,
    required this.includedServices,
    required this.includedProducts,
    required this.estimatedDays,
  });

  factory TurnkeyPackage.fromJson(Map<String, dynamic> json) {
    return TurnkeyPackage(
      id: json['id'],
      name: json['name'],
      estimatedCost: (json['estimatedCost'] ?? 0).toDouble(),
      areaSqFt: (json['areaSqFt'] ?? 0).toDouble(),
      description: json['description'],
      includedServices: List<String>.from(json['includedServices'] ?? []),
      includedProducts: List<String>.from(json['includedProducts'] ?? []),
      estimatedDays: json['estimatedDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'estimatedCost': estimatedCost,
      'areaSqFt': areaSqFt,
      'description': description,
      'includedServices': includedServices,
      'includedProducts': includedProducts,
      'estimatedDays': estimatedDays,
    };
  }
}
