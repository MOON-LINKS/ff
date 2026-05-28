import 'package:dio/dio.dart';

import './dio_client.dart';

class AuthService {
  final dio = DioClient.dio;

  Future<dynamic> register(
      bool isEmail, String name, String email, String password) async {
    try {
      final response = await dio.post(
        "/auth/register",
        data: {
          "isEmail": isEmail,
          "name": name,
          "cred": email,
          "password": password
        },
      );
      return response.data;
    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }

  Future<dynamic> verifyOTP(
      String otp, String deviceName, String verificationId,
      {required String clientType}) async {
    try {
      final response = await dio.post("/auth/verify-otp",
          data: {
            'otp': otp,
            'deviceName': deviceName,
            'verificationId': verificationId,
          },
          options: Options(headers: {
            'x-client-type': clientType,
            'Content-Type': 'application/json',
          }, extra: {
            "withCredentials": clientType != 'app'
          }));
      return response.data;
    } catch (e) {
      throw Exception("Otp error: $e");
    }
  }

  Future<dynamic> resetPass1(int isEmail, String cred) async {
    try {
      final response =
          await dio.post('/auth/reset-pass-1', data: {isEmail, cred});
      return response.data;
    } catch (e) {
      throw Exception('Credential error: $e');
    }
  }

  Future<dynamic> resetPass2(String resetId, String otp) async {
    try {
      final response =
          await dio.post('/auth/reset-pass-2', data: {resetId, otp});
      return response.data;
    } catch (e) {
      throw Exception('Credential error: $e');
    }
  }

  Future<dynamic> resetPass3(String newPass, String token) async {
    try {
      final response =
          await dio.post('/auth/reset-pass-3', data: {newPass, token});
      return response.data;
    } catch (e) {
      throw Exception('Credential error: $e');
    }
  }

  Future<dynamic> logout(String token) async {
    try {
      final response = await dio.post('/auth/logout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data;
    } catch (e) {
      throw Exception('Logout issue: $e');
    }
  }

  Future<dynamic> login(String cred, String password, String deviceName) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {"cred": cred, "password": password, "deviceName": deviceName},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }
    } catch (e) {
      throw Exception('Login issue: $e');
    }
  }

  Future<dynamic> logoutFromAll(String password) async {
    try {
      final response = await dio.post('/auth/logout-all', data: {password});
      return response.data;
    } catch (e) {
      throw Exception('Logout issue: $e');
    }
  }

  Future<dynamic> getUserInfo(String token) async {
    try {
      final response = await dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('user info error: $e');
    }
  }
}
