import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:moonlinks/api/dio_client.dart';
import 'package:moonlinks/functions/secure_storage.dart';

class CatalogueApi {
  final dio = DioClient.dio;

  Future<dynamic> getCatalogueSnapshot(int subscribedServiceId) async {
    try {
      final token = await readToken();
      final response = await dio.get('/catalogue/snapshot',
          queryParameters: {"subscribedServiceId": subscribedServiceId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      throw Exception("Snapshot failed: $e");
    }
  }

  Future<dynamic> setName(String name) async {
    try {
      final token = await readToken();
      final response = await dio.post(
        '/catalogue/set-name',
        data: {"name": name},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Error Setting Name: $e');
    }
  }

  Future<dynamic> publish(int subscribedServiceId, dynamic payload) async {
    try {
      final token = await readToken();
      final response = await dio.post('/catalogue/publish',
          data: {"payload": payload},
          queryParameters: {"subscribedServiceId": subscribedServiceId},
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data;
    } catch (e) {
      throw Exception('Error publishing: $e');
    }
  }

  Future<dynamic> getAddOns() async {
    try {
      final token = await readToken();
      final response = await dio.get('/catalogue/add-ons',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<dynamic> getAnalytics() async {
    try {
      final token = await readToken();
      final response = await dio.get('/catalogue/analytics',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      throw Exception("error getting analytics: $e");
    }
  }

  Future<String> uploadImage(Uint8List fileBytes, String fileName) async {
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      ),
    });
    final token = await readToken();
    final response = await dio.post('/catalogue/upload-image',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: formData);
    return response.data['url'];
  }

  Future<Map<String, List<String>>> getAssets() async {
    final response = await dio.get('/catalogue/assets');

    final List<String> media = [];
    final List<String> category = [];

    for (final el in response.data['assets']) {
      final type = el['type'];
      final url = el['url'];

      if (type == 'media') {
        media.add(url);
      } else if (type == 'category') {
        category.add(url);
      }
    }

    return {
      'media': media,
      'category': category,
    };
  }

  Future<dynamic> addDomain(String domain) async {
    try {
      final token = await readToken();
      final response = await dio.post('/catalogue/add-domain',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            "domain": domain,
          });
      return response.data;
    } catch (e) {
      throw Exception("error adding domain: $e");
    }
  }

  Future<dynamic> checkDomain(String domain) async {
    try {
      final token = await readToken();
      final response = await dio.post('/catalogue/check-domain',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            "domain": domain,
          });
      return response.data;
    } catch (e) {
      throw Exception("error checking domain: $e");
    }
  }

  Future<dynamic> removeDomain(String domain) async {
    try {
      final token = await readToken();
      final response = await dio.post('/catalogue/remove-domain',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            "domain": domain,
          });
      return response.data;
    } catch (e) {
      throw Exception("error removing domain: $e");
    }
  }

  Future<dynamic> getDomain() async {
    try {
      final token = await readToken();
      final response = await dio.get(
        '/catalogue/list-domain',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } catch (e) {
      throw Exception("error getting domain: $e");
    }
  }
}
