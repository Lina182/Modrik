import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../config/api_config.dart';
import '../models/individual_report_item.dart';
import '../models/cross_report_item.dart';

class AnalysisService {
  static Future<List<IndividualReportItem>> analyzeIndividual(
    String filePath,
  ) async {
    var uri = Uri.parse("${ApiConfig.baseUrl}/analyze_vcf/");

    var request = http.MultipartRequest('POST', uri);

    request.fields['uid'] = FirebaseAuth.instance.currentUser!.uid;

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Upload failed: ${response.statusCode}");
    }

    var responseBody = await response.stream.bytesToString();

    final decodedData = jsonDecode(responseBody);

    final List<dynamic> resultsList = decodedData['results'] ?? [];

    final Map<String, dynamic> panelResponses =
        decodedData['panelapp_responses'] ?? {};

    return resultsList.map((item) {
      final String gene = item['base__hugo']?.toString() ?? '';

      final panelInfo = panelResponses[gene] as Map<String, dynamic>?;

      return IndividualReportItem.fromJson(item, panelInfo);
    }).toList();
  }

  static Future<List<CrossReportItem>> analyzeCross({
    required List<int> maleBytes,
    required String maleName,
    required List<int> femaleBytes,
    required String femaleName,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiConfig.baseUrl}/analyze_cross/"),
    );

    request.fields['uid'] = FirebaseAuth.instance.currentUser!.uid;

    request.files.add(
      http.MultipartFile.fromBytes('male_file', maleBytes, filename: maleName),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'female_file',
        femaleBytes,
        filename: femaleName,
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Failed to analyze files");
    }

    final data = jsonDecode(response.body);

    final crossResults = data['cross_results'];

    List<CrossReportItem> reports = [];

    for (var item in crossResults['autosomal_dominant']) {
      reports.add(CrossReportItem.fromJson(item, "Autosomal Dominant Risks"));
    }

    for (var item in crossResults['autosomal_recessive']) {
      reports.add(CrossReportItem.fromJson(item, "Autosomal Recessive Risks"));
    }

    for (var item in crossResults['x_linked_recessive']) {
      reports.add(CrossReportItem.fromJson(item, "X-Linked Recessive Risks"));
    }

    for (var item in crossResults['x_linked_dominant']) {
      reports.add(CrossReportItem.fromJson(item, "X-Linked Dominant Risks"));
    }

    for (var item in crossResults['both_uncertain']) {
      reports.add(
        CrossReportItem.fromJson(item, "Uncertain / Both Pattern Risks"),
      );
    }

    return reports;
  }
}
