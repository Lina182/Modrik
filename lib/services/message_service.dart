import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class MessageService {
  static Future<Map<String, dynamic>> loadMessages({
    required int consultationId,
    required int currentUserId,
    required String currentUserRole,
  }) async {
    final res = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/messages/$consultationId"
        "?current_user_id=$currentUserId"
        "&current_user_role=$currentUserRole",
      ),
    );

    return jsonDecode(res.body);
  }

  static Future<void> sendMessage({
    required int consultationId,
    required int senderId,
    required String message,
  }) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/messages/send"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "consultation_id": consultationId,
        "sender_id": senderId,
        "message_text": message,
      }),
    );
  }
}
