import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

Future<int> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return int.parse(prefs.getString('user_id') ?? '0');
}

Future<String> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_role') ?? '';
}

class ConsultationService {
  final url = Uri.parse('${ApiConfig.baseUrl}/consultations');

  static Future<bool> createConsultation({
    required int userId,
    required String type,
    required String reportName,
    required dynamic data,
    required String userQuestion,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/consultations');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": userId,
        "type": type,
        "report_name": reportName,
        "data": data,
        "user_question": userQuestion,
      }),
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getUserConsultations({
    required int userId,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/$userId/consultations');

    final response = await http.get(url);

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return decoded["consultations"];
    } else {
      return [];
    }
  }
}
