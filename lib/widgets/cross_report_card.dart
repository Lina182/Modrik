import 'package:flutter/material.dart';

import '../models/cross_report_item.dart';
import '../services/disease_service.dart';

const Color mainPurple = Color(0xFF6C63FF);

class CrossReportCard extends StatefulWidget {
  final CrossReportItem item;
  final bool isExpertView;

  const CrossReportCard({
    super.key,
    required this.item,
    this.isExpertView = false,
  });
  @override
  State<CrossReportCard> createState() => _CrossReportCardState();
}

class _CrossReportCardState extends State<CrossReportCard> {
  bool showArabic = false;
  bool isLoading = false;
  bool showExpertDetails = false;
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

  Color _statusColor(String value) {
    final lower = value.toLowerCase();

    if (lower.contains('pathogenic')) {
      return const Color(0xFFE83F6F);
    }

    if (lower.contains('uncertain')) {
      return const Color(0xFFFFA726);
    }

    if (lower.contains('benign') ||
        lower.contains('healthy') ||
        lower.contains('normal')) {
      return const Color(0xFF2EAF61);
    }

    return mainPurple;
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
              leading: const Icon(Icons.translate, color: mainPurple),

              title: const Text('Translate to Arabic'),

              onTap: () => Navigator.pop(context, 'translate'),
            ),

            ListTile(
              leading: const Icon(Icons.psychology, color: mainPurple),

              title: const Text('Explain'),

              onTap: () => Navigator.pop(context, 'explain'),
            ),
          ],
        ),
      ),
    );

    final item = widget.item;

    // TRANSLATE
    if (value == 'translate') {
      setState(() => isLoading = true);

      try {
        final result = await DiseaseService.translateDisease(item.disease);

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

    // EXPLAIN
    if (value == 'explain') {
      setState(() => isLoading = true);

      try {
        final result = await DiseaseService.explainDisease(item.disease);

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
                    // ⋯ الثلاث نقاط فقط
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: _showMenu,

              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF171733),
              ),

              style: IconButton.styleFrom(
                backgroundColor:
                    const Color(0xFFF3F0FF),

                minimumSize:
                    const Size(34, 34),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text("Genetic Condition", style: titleStyle.copyWith(fontSize: 17)),

          const SizedBox(height: 14),

          // DISEASE
          _infoRow(
            "Disease:",
            item.disease,

            icon: Icons.medical_information_outlined,
          ),

          // TRANSLATION
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

                style: valueStyle.copyWith(
                  color: mainPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          // GENE
          _infoRow("Gene:", item.gene, icon: Icons.biotech_outlined),

          // INHERITANCE
          _infoRow(
            "Inheritance:",
            item.inheritance,
            icon: Icons.groups_2_outlined,
          ),

          const Divider(height: 28),

          // CHILD RISK
          Text("Child Risk", style: titleStyle.copyWith(fontSize: 17)),

          const SizedBox(height: 12),

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

          // CLINICAL SIGNIFICANCE
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            decoration: BoxDecoration(
              color: const Color(0xFFF4EFFA),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Clinical significance",

                  style: labelStyle.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 6),

                Text(
                  item.clinicalSignificance,

                  style: valueStyle.copyWith(
                    color: _statusColor(item.clinicalSignificance),

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // EXPLAIN RISK
          Align(
            alignment: Alignment.centerRight,

            child: GestureDetector(
              onTap: _showRiskExplanationDialog,

              child: const Text(
                "Explain this risk >",

                style: TextStyle(
                  color: mainPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          /// ===== EXPERT DETAILS BUTTON =====
          if (widget.isExpertView && item.parents != null) ...[
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                setState(() {
                  showExpertDetails = !showExpertDetails;
                });
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Text(
                    showExpertDetails
                        ? "Hide Details"
                        : "Show Details",

                    style: const TextStyle(
                      color: mainPurple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Icon(
                    showExpertDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,

                    color: mainPurple,
                  ),
                ],
              ),
            ),

            if (showExpertDetails) ...[
              const SizedBox(height: 18),

              Text(
                "Expert Variant Details",
                style: titleStyle.copyWith(fontSize: 17),
              ),

              const SizedBox(height: 14),

              _expertParentCard(title: "Father", data: item.parents!["father"]),

              const SizedBox(height: 12),

              _expertParentCard(title: "Mother", data: item.parents!["mother"]),
            ],
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ICON BOX
          if (icon != null)
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon, color: mainPurple, size: 24),
            ),

          const SizedBox(width: 16),

          // TITLE
          SizedBox(
            width: 110,

            child: Padding(
              padding: const EdgeInsets.only(top: 12),

              child: Text(title, style: labelStyle),
            ),
          ),

          // VALUE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),

              child: Text(value, style: valueStyle),
            ),
          ),
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

  Widget _expertParentCard({required String title, required dynamic data}) {
    if (data == null) {
      return const SizedBox();
    }

    final variants = data["variants"] as List?;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "$title Variant Data",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          const SizedBox(height: 10),

          Text("State: ${data["state"]}"),

          const SizedBox(height: 10),

          if (variants != null)
            ...variants.map((v) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),

                child: Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Chromosome: ${v["chrom"]}"),

                      Text("Position: ${v["position"]}"),

                      Text("Ref: ${v["ref"]}"),

                      Text("Alt: ${v["alt"]}"),

                      Text("Zygosity: ${v["zygosity"]}"),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
