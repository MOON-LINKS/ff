import 'package:dio/dio.dart';

import './dio_client.dart';

class User {
  final dio = DioClient.dio;
  Future<dynamic> getSubscribedServices(String token) async {
    try {
      final response = await dio.get(
        '/user/my-services',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );
      if (response.statusCode == 404) {
        return [];
      }
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }
}
