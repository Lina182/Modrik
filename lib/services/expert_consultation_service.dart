import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpertConsultationService {
  static const String baseUrl = 'http://172.237.116.141:8003';

  /// WAITING CONSULTATIONS
  static Future<List> getWaitingConsultations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/consultations/waiting'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }

  /// ACTIVE CONSULTATIONS
  static Future<List> getActiveConsultations(int expertId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/consultations/active/$expertId'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }

  /// COMPLETED CONSULTATIONS
  static Future<List> getCompletedConsultations(int expertId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/consultations/completed/$expertId'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }
}
