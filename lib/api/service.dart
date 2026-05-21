import 'package:dio/dio.dart';
import 'package:moonlinks/functions/secure_storage.dart';

import './dio_client.dart';

class ServiceAPI {
  final dio = DioClient.dio;
  Future<dynamic> getServicePlan() async {
    try {
      final response = await dio.get("/guests/services");
      return response.data;
    } catch (e) {
      throw Exception('Error retrieving service: $e');
    }
  }

  Future<dynamic> getListUpgradables(int serviceId) async {
    try {
      final response = await dio.get("/payment/show-upgradable-plans",
          queryParameters: {'serviceId': serviceId});
      return response.data;
    } catch (e) {
      throw Exception('Error retrieving service: $e');
    }
  }

//menu add ons
  Future<dynamic> payMenuAddOns(int quantity) async {
    try {
      final token = await readToken();
      final response = await dio.post('/menu/add-ons-checkout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          data: {'quantity': quantity});
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> getMenuAddOns() async {
    try {
      final token = await readToken();
      final response = await dio.get('/menu/add-ons',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> upgradeMenuAddOn(String stripeItemId, int newQty) async {
    try {
      final token = await readToken();
      final response = await dio.post('/menu/add-ons-upgrade',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {"stripe_item_id": stripeItemId, "additionalQuantity": newQty});
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }
}
