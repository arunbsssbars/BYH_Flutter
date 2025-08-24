import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/vendor.dart';
import '../repositories/vendor_repository.dart';

final _repoProvider = Provider<VendorRepository>((ref) {
  return LocalVendorRepository();
});

class VendorState {
  final List<Vendor> vendors;
  final bool loading;
  final String? error;

  const VendorState({
    this.vendors = const [],
    this.loading = false,
    this.error,
  });

  VendorState copyWith({
    List<Vendor>? vendors,
    bool? loading,
    String? error,
  }) =>
      VendorState(
        vendors: vendors ?? this.vendors,
        loading: loading ?? this.loading,
        error: error,
      );
}

class VendorNotifier extends StateNotifier<VendorState> {
  VendorNotifier(this._repo) : super(const VendorState());

  final VendorRepository _repo;
  final _uuid = const Uuid();

  Future<void> load() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final data = await _repo.fetchVendors();
      state = state.copyWith(vendors: data, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> registerVendor({
    required String name,
    required String category,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);
      final vendor = Vendor(
        id: _uuid.v4(),
        name: name.trim(),
        category: category.trim(),
        phone: phone.trim(),
        email: email.trim(),
        address: address.trim(),
        isVerified: false,
        rating: 0.0,
      );
      await _repo.createVendor(vendor);
      final updated = [...state.vendors, vendor];
      state = state.copyWith(vendors: updated, loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }
}

final vendorProvider =
    StateNotifierProvider<VendorNotifier, VendorState>((ref) {
  return VendorNotifier(ref.read(_repoProvider));
});
