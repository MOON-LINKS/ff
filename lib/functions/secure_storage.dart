import 'package:shared_preferences/shared_preferences.dart';

//final String link = 'http://localhost:3000';
final String link = 'https://api.moonlinks.me';

Future<void> addToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> readToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}
