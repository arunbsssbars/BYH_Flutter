import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

final _productRepoProvider = Provider<ProductRepository>((ref) {
  return LocalProductRepository();
});

class ProductState {
  final List<Product> products;
  final bool loading;
  final String? error;

  const ProductState({
    this.products = const [],
    this.loading = false,
    this.error,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? loading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier(this._repo) : super(const ProductState());

  final ProductRepository _repo;
  final _uuid = const Uuid();

  Future<void> load(String vendorId) async {
    try {
      state = state.copyWith(loading: true, error: null);
      final list = await _repo.fetchProducts(vendorId);
      state = state.copyWith(products: list, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> addProduct({
    required String vendorId,
    required String name,
    required String category,
    required String description,
    required double price,
    required String unit,
    required String imageUrl,
  }) async {
    try {
      final product = Product(
        id: _uuid.v4(),
        vendorId: vendorId,
        name: name,
        category: category,
        description: description,
        price: price,
        unit: unit,
        imageUrl: imageUrl,
        inStock: true,
      );
      await _repo.createProduct(product);
      final updated = [...state.products, product];
      state = state.copyWith(products: updated);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> updateProduct(Product product) async {
    await _repo.updateProduct(product);
    final updated = state.products.map((p) => p.id == product.id ? product : p).toList();
    state = state.copyWith(products: updated);
  }

  Future<void> deleteProduct(String id, String vendorId) async {
    await _repo.deleteProduct(id, vendorId);
    final updated = state.products.where((p) => p.id != id).toList();
    state = state.copyWith(products: updated);
  }
}

final productProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(ref.read(_productRepoProvider));
});
