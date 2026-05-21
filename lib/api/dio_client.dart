import 'package:dio/dio.dart';
import 'package:moonlinks/functions/secure_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$link/api",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {"Accept": "application/json"},
    ),
  );
}
