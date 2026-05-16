import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<int> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return int.parse(prefs.getString('user_id') ?? '0');
}

Future<String> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_role') ?? '';
}

class ConsultationService {
  static const String baseUrl = 'http://172.237.116.141:8003';

  static Future<bool> createConsultation({
    required int userId,

    required String type,

    required String reportName,

    required dynamic data,

    required String userQuestion,
  }) async {
    final url = Uri.parse('$baseUrl/consultations');

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

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getUserConsultations({
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/users/$userId/consultations');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return decoded["consultations"];
    } else {
      return [];
    }
  }


}
