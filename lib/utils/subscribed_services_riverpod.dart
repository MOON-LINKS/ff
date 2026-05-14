import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final subServicesProvider =
    StateNotifierProvider<SubServicesNotifier, List<Map<String, dynamic>>>(
        (_) => SubServicesNotifier());

class SubServicesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  SubServicesNotifier() : super([]) {
    _loadSubServices();
  }
  late Box _box;
  Future<void> _loadSubServices() async {
    _box = Hive.box('subscribedServices');
    final stored = _box.get('list', defaultValue: []) as List<dynamic>;
    state = stored.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _saveStateToHive() {
    _box.put('list', state);
  }

  void addToSubServices(Map<String, dynamic> plan) {
    state = [...state, plan];
    _saveStateToHive();
  }

  void updateSubService(String id, Map<String, dynamic> plan) {
    final index = state.indexWhere((e) => e['subscribedserviceId'] == id);
    if (index != -1) {
      state[index] = plan;
      state = [...state];
      _saveStateToHive();
    }
  }

  void removeSubService(String id) {
    state = state.where((e) => e['subscribedserviceId'] != id).toList();
    _saveStateToHive();
  }

  void removeAll() {
    state = [];
    _saveStateToHive();
  }

  bool isSubscribed(String serviceCode) {
    return state
        .any((s) => s['service_code'] == serviceCode && s['is_active'] == 1);
  }

  List<Map<String, dynamic>> getSubServices() => state;
}
