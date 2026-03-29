import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/individual_report_item.dart';

class IndividualReportCard extends StatefulWidget {
  final IndividualReportItem item;

  const IndividualReportCard({super.key, required this.item});

  @override
  State<IndividualReportCard> createState() => _IndividualReportCardState();
}

class _IndividualReportCardState extends State<IndividualReportCard> {
  bool showArabic = false;
  bool isLoading = false;

  String? translatedText;

  final TextStyle unifiedStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // دالة ترجمة اسم المرض
  Future<String> translateDisease(String disease) async {
    final response = await http.post(
      Uri.parse("http://172.237.116.141:8003/translate_disease/"),
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

  // دالة شرح المرض
  Future<String> explainDisease(String disease) async {
    final response = await http.post(
      Uri.parse("http://172.237.116.141:8003/explain_disease/"),
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

  void _showMenu() async {
    final value = await showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.translate),
              title: const Text('Translate to Arabic'),
              onTap: () => Navigator.pop(context, 'translate'),
            ),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('Explain'),
              onTap: () => Navigator.pop(context, 'explain'),
            ),
          ],
        ),
      ),
    );

    final item = widget.item;

    // زر الترجمة
    if (value == 'translate') {
      setState(() => isLoading = true);

      try {
        final result = await translateDisease(item.disease);

        setState(() {
          translatedText = result;
          showArabic = true;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Translation failed: $e")));
      }
    }

    // زر الشرح
    if (value == 'explain') {
      setState(() => isLoading = true);

      try {
        final result = await explainDisease(item.disease);

        setState(() => isLoading = false);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Text(result, style: unifiedStyle),
            ),
          ),
        );
      } catch (e) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Explanation failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFFA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // المنيو
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: _showMenu,
              icon: const Icon(Icons.more_horiz),
            ),
          ),

          _infoRow('Gene:', item.gene),
          _infoRow('Disease:', item.disease),

          // لودينق أثناء الترجمة أو الشرح
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(),
            ),

          // عرض الترجمة
          if (showArabic && translatedText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                translatedText!,
                textDirection: TextDirection.rtl,
                style: unifiedStyle,
              ),
            ),

          _infoRow('Clinical significance:', item.clinicalSignificance),
          _infoRow('Inheritance:', item.inheritance),
          _infoRow('Confidence level:', item.confidenceLevel),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(title, style: unifiedStyle)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: unifiedStyle)),
        ],
      ),
    );
  }
}
