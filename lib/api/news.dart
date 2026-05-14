import './dio_client.dart';

class NewsAPI {
  final dio = DioClient.dio;
  Future<dynamic> getNews() async {
    try {
      final response = await dio.get('/guests/home-news');
      return response.data;
    } catch (e) {
      throw Exception('error: $e');
    }
  }
}
