import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      //baseUrl: "http://localhost:3000/api",
      baseUrl: "https://api.moonlinks.me/api",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {"Accept": "application/json"},
    ),
  );
}
