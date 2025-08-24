import 'dart:async';
import '../core/storage/local_store.dart';
import '../models/vendor.dart';

abstract class VendorRepository {
  Future<List<Vendor>> fetchVendors();
  Future<Vendor> createVendor(Vendor vendor);
}

class LocalVendorRepository implements VendorRepository {
  final LocalStore _store = LocalStore.instance;

  @override
  Future<List<Vendor>> fetchVendors() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    final list = await _store.getVendors();
    return list.map(Vendor.fromJson).toList();
  }

  @override
  Future<Vendor> createVendor(Vendor vendor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = await _store.getVendors();
    final vendors = list.map(Vendor.fromJson).toList();
    vendors.add(vendor);
    await _store.saveVendors(vendors.map((e) => e.toJson()).toList());
    return vendor;
  }
}
