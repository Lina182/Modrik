import 'package:flutter/material.dart';
import '../models/individual_report_item.dart';

class IndividualReportCard extends StatefulWidget {
  final IndividualReportItem item;

  IndividualReportCard({required this.item});

  @override
  State<IndividualReportCard> createState() => _IndividualReportCardState();
}

class _IndividualReportCardState extends State<IndividualReportCard> {
  bool showArabic = false;

  final TextStyle unifiedStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

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

    if (value == 'translate') {
      setState(() => showArabic = true);
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
          /// 🔥 المنيو لحاله فوق
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: _showMenu,
              icon: const Icon(Icons.more_horiz),
            ),
          ),

          /// 🔹 Gene (صار طبيعي)
          _infoRow('Gene:', item.gene),

          /// 🔹 Disease
          _infoRow('Disease:', item.disease),

          /// 🔹 ترجمة
          if (showArabic)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                item.arabicDisease,
                textDirection: TextDirection.rtl,
                style: unifiedStyle,
              ),
            ),

          /// 🔹 باقي البيانات
          _infoRow('Clinical significance:', item.clinicalSignificance),
          _infoRow('Inheritance:', item.inheritance),
          _infoRow('Confidence level:', item.confidenceLevel),
        ],
      ),
    );
  }

  /// 🔥 سطر موحد
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
