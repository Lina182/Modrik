import 'dart:convert';
import 'package:http/http.dart' as http;

class DiseaseService {
  static const String baseUrl = "http://172.237.116.141:8003";

  static Future<String> translateDisease(String disease) async {
    final response = await http.post(
      Uri.parse("$baseUrl/translate_disease/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"disease": disease}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["translation"];
    } else {
      throw Exception("Translation failed");
    }
  }

  static Future<String> explainDisease(String disease) async {
    final response = await http.post(
      Uri.parse("$baseUrl/explain_disease/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"disease": disease}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["explanation"];
    } else {
      throw Exception("Explanation failed");
    }
  }
}