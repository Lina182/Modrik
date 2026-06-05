import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthService {
  static Future<void> registerUser({
    required String uid,
    required String name,
    required String email,
    required String token,
  }) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": uid,
        "name": name,
        "email": email,
        "role": "user",
        "token": token,
      }),
    );
  }

  static Future<void> saveFcmToken({
    required String uid,
    required String? fcmToken,
  }) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/save-fcm-token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"uid": uid, "fcm_token": fcmToken}),
    );
  }

  static Future<http.Response> verifyToken(String token) async {
    return await http.post(
      Uri.parse("${ApiConfig.baseUrl}/verify-token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );
  }

  static Future<http.Response> createLoginLog(String token) async {
    return await http.post(
      Uri.parse("${ApiConfig.baseUrl}/login-log"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );
  }

  static Future<void> deleteUser(String token) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/delete-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );
  }

  static Future<void> updateLanguage({
    required String uid,
    required String language,
  }) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/update-language"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"uid": uid, "language": language}),
    );
  }

  static Future<void> updateProfile({
  required String token,
  required String name,
  required String email,
}) async {
  await http.post(
    Uri.parse("${ApiConfig.baseUrl}/update-profile"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "token": token,
      "name": name,
      "email": email,
    }),
  );
}
}
