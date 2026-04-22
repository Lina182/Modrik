import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cross_report_item.dart';

class CrossReportCard extends StatefulWidget {
  final CrossReportItem item;

  const CrossReportCard({super.key, required this.item});

  @override
  State<CrossReportCard> createState() => _CrossReportCardState();
}

class _CrossReportCardState extends State<CrossReportCard> {
  bool showArabic = false;
  bool isLoading = false;

  String? translatedText;

  final TextStyle titleStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  final TextStyle labelStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  final TextStyle valueStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  // =========================
  // ترجمة اسم المرض
  // =========================
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

  // =========================
  // شرح المرض
  // =========================
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

  // =========================
  // المنيو
  // =========================
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

    // =========================
    // زر الترجمة
    // =========================
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

    // =========================
    // زر شرح المرض
    // =========================
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
              child: Text(result, style: valueStyle),
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

  // =========================
  // شرح الريسك من الباك
  // =========================
  void _showRiskExplanationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Risk Explanation"),
        content: Text(widget.item.explainRisk),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// الثلاث نقاط
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: _showMenu,
              icon: const Icon(Icons.more_horiz),
            ),
          ),

          Text("Genetic Condition", style: titleStyle.copyWith(fontSize: 17)),

          const SizedBox(height: 14),

          _infoRow("Disease:", item.disease),

          // 🔥 الترجمة تحت اسم المرض مباشرة
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: CircularProgressIndicator(),
            ),

          if (showArabic && translatedText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(
                translatedText!,
                textDirection: TextDirection.rtl,
                style: valueStyle,
              ),
            ),

          _infoRow("Gene:", item.gene),
          _infoRow("Inheritance:", item.inheritance),

          const Divider(height: 28),

          Text("Child Risk", style: titleStyle.copyWith(fontSize: 17)),

          const SizedBox(height: 12),

          /// مربعات النسب
          Row(
            children: [
              Expanded(
                child: _riskBox(
                  label: "Affected",
                  value: item.affectedRisk,
                  color: const Color(0xFFF36C8C),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _riskBox(
                  label: "Carrier",
                  value: item.carrierRisk,
                  color: const Color(0xFFF3C84D),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _riskBox(
                  label: "Healthy",
                  value: item.healthyRisk,
                  color: const Color(0xFF7ED6A7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFFA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Clinical significance: ${item.clinicalSignificance}",
              style: valueStyle,
            ),
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _showRiskExplanationDialog,
              child: Text(
                "Explain this risk >",
                style: labelStyle.copyWith(color: const Color(0xFF8A6BD6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 95, child: Text(title, style: labelStyle)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }

  Widget _riskBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
