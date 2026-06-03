import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ExpertConsultationService {
  /// WAITING CONSULTATIONS
  static Future<List> getWaitingConsultations() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/consultations/waiting'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }

  /// ACTIVE CONSULTATIONS
  static Future<List> getActiveConsultations(int expertId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/consultations/active/$expertId'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }

  ///LIST COMPLETED CONSULTATIONS
  static Future<List> getCompletedConsultations(int expertId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/consultations/completed/$expertId'),
    );

    final data = jsonDecode(response.body);

    return data['consultations'];
  }

  /// COMPLETE CONSULTATION
  static Future<bool> completeConsultation({
    required int consultationId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/consultations/$consultationId/mark-complete',
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);

      return false;
    }
  }

  static Future<bool> acceptConsultation({
    required int consultationId,
    required int expertId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/consultations/$consultationId/accept'),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({"expert_id": expertId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);

      return false;
    }
  }
}
