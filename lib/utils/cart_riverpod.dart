import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>(
  (ref) => CartNotifier(ref),
);

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier(this.ref) : super([]) {
    _loadCart();
  }
  final Ref ref;
  late Box _box;

  Future<void> _loadCart() async {
    _box = await Hive.openBox('cartBox');

    final stored =
        _box.values.map((e) => Map<String, dynamic>.from(e)).toList();
    final subscribedServices =
        ref.read(subServicesProvider.notifier).getSubServices();
    final cleanedCart = stored.where((cartItem) {
      return !subscribedServices.any((sub) => sub['name']
          .toString()
          .toLowerCase()
          .contains(cartItem['service_name'].toString().toLowerCase()));
    }).toList();
    await _box.clear();
    for (var item in cleanedCart) {
      _box.add(item);
    }
    state = cleanedCart;
  }

  void addToCart(Map<String, dynamic> plan) {
    if (!state.any((p) =>
        p['service_code'] == plan['service_code'] &&
        p['plan_id'] == plan['plan_id'])) {
      state = [...state, plan];
      _box.add(plan);
    }
  }

  void removeFromCart(String serviceCode, int planId) {
    state = state
        .where((p) =>
            !(p['service_code'] == serviceCode && p['plan_id'] == planId))
        .toList();
    final keyToDelete = _box.keys.firstWhere((key) {
      final p = _box.get(key);
      return p['service_code'] == serviceCode && p['plan_id'] == planId;
    }, orElse: () => null);
    if (keyToDelete != null) _box.delete(keyToDelete);
  }

  void removeSubscribedServices(List<Map<String, dynamic>> subscribedServices) {
    state = state.where((cartItem) {
      return !subscribedServices.any((sub) => sub['name']
          .toString()
          .toLowerCase()
          .contains(cartItem['service_name'].toString().toLowerCase()));
    }).toList();

    _box.clear();
    for (final item in state) {
      _box.add(item);
    }
  }

  Future<void> removeAll() async {
    state = [];
    if (_box.isOpen) await _box.clear();
  }

  List<Map<String, dynamic>> getCartItems() => state;
}
