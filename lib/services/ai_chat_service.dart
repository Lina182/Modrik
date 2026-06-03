import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AIChatService {
  static Future<String> sendMessage({
    required List<Map<String, String>> messages,
    Map<String, dynamic>? reportData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/chat/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"messages": messages, "analysis_data": reportData}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"] ?? "No response";
      }

      return "Server error";
    } catch (e) {
      return "Connection error";
    }
  }
}
