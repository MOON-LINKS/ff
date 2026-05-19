import 'package:dio/dio.dart';
import 'package:moonlinks/functions/secure_storage.dart';

import './dio_client.dart';

class Pay {
  final dio = DioClient.dio;
  Future<dynamic> createCheckout(List<String> items) async {
    try {
      final token = await readToken();
      final response = dio.post('/payment/create-checkout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          data: {'items': items});
      return response;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> toggleCheckoutRenewal(int subscribedserviceId,
      String stripeSubscriptionItemId, String userCred, bool autoRenew) async {
    try {
      await dio.post('/payment/toggle-renewal', data: {
        'subscribedserviceId': subscribedserviceId,
        'stripe_subscription_item_id': stripeSubscriptionItemId,
        'user_cred': userCred,
        'autoRenew': autoRenew
      });
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> upgradePlan(
      int subscribedserviceId,
      int servicePlanId,
      String oldStripeSubscriptionItemId,
      String newStripePriceId,
      double priceToPay) async {
    try {
      final response = await dio.post('/payment/upgrade-plan', data: {
        'subscribedserviceId': subscribedserviceId,
        'servicePlanId': servicePlanId,
        'oldStripeSubscriptionItemId': oldStripeSubscriptionItemId,
        'newStripePriceId': newStripePriceId,
        'priceToPay': priceToPay
      });
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> rechargeService(int subscribedserviceId) async {
    try {
      final token = await readToken();

      final response = await dio.post('/payment/recharge-service',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          data: {
            'subscribedServiceId': subscribedserviceId,
          });
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> deleteAccount() async {
    try {
      final token = await readToken();
      final response = await dio.delete('/payment/delete-account',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }
}
