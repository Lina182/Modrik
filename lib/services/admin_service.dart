import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../config/api_config.dart';

class AdminService {
  static Future<Map<String, dynamic>> getSystemHealth() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {
        "opencravat": "offline",
        "panelapp": "offline",
        "gemini": "offline",
        "total_users": 0,
      };
    }

    final token = await user.getIdToken();

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/system/health?token=$token"),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAnalysisCounts() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/analysis-count"),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAnalysisStats() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/analysis-stats"),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getExpertStatistics() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/expert-statistics"),
    );

    final data = jsonDecode(response.body);

    return data["experts"] ?? [];
  }
}
