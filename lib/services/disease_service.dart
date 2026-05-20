import 'dart:convert';
import 'package:http/http.dart' as http;
import 'db_service.dart';

class DiseaseService {
  static const String baseUrl = "http://172.237.116.141:8003";
  // TRANSLATE DISEASES
  static Future<Map<String, String>> translateDiseases(
    List<String> diseases,
  ) async {
    Map<String, String> translations = {};
    List<String> diseasesToTranslate = [];
    // CHECK SQLITE FIRST
    for (String disease in diseases) {
      final cachedTranslation = await DBService.getDiseaseTranslation(disease);
      // اذا موجود بالكاش
      if (cachedTranslation != null) {
        print("FROM SQLITE: $disease");
        translations[disease] = cachedTranslation;
      } else {
        // اذا مو موجود ضيفه للترجمة
        diseasesToTranslate.add(disease);
      }
    }
    // اذا كلها موجودة خلاص
    if (diseasesToTranslate.isEmpty) {
      return translations;
    }
    // API REQUEST
    final response = await http.post(
      Uri.parse("$baseUrl/translate_diseases/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"diseases": diseasesToTranslate}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final apiTranslations = Map<String, String>.from(data["translations"]);
      // SAVE TO SQLITE
      for (final entry in apiTranslations.entries) {
        final englishName = entry.key;
        final arabicTranslation = entry.value;
        print("FROM API: $englishName");
        // خزنه فقط اذا فيه ترجمة
        if (arabicTranslation.trim().isNotEmpty &&
            arabicTranslation != englishName) {
          await DBService.saveDiseaseTranslation(
            englishName: englishName,
            arabicTranslation: arabicTranslation,
          );
        }
        translations[englishName] = arabicTranslation;
      }
      return translations;
    } else {
      throw Exception("Translations failed");
    }
  }

  // EXPLAIN DISEASE
  static Future<String> explainDisease(String disease, String language) async {
    final response = await http.post(
      Uri.parse("$baseUrl/explain_disease/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"disease": disease,"language": language},),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["explanation"];
    } else {
      throw Exception("Explanation failed");
    }
  }
}
