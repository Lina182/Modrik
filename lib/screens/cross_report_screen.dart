import 'package:flutter/material.dart';
import '../data/dummy_report_data.dart';
import '../widgets/cross_report_card.dart';
import '../widgets/report_action_buttons.dart';

class CrossReportScreen extends StatelessWidget {
  const CrossReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<dynamic>> grouped = {};

    for (final item in dummyCrossReports) {
      grouped.putIfAbsent(item.sectionTitle, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2FB),
        elevation: 0,
        title: const Text('Cross Genetic Risk Report'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              ...grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...entry.value.map(
                      (item) =>
                          CrossReportCard(item: item, onExplainPressed: () {}),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const SizedBox(height: 12),
              ReportActionButtons(
                onDownloadPdf: () {},
                onAskAi: () {},
                onConsultExpert: () {},
                pdfLabel: 'Download Full Couple Report (PDF)',
                aiLabel: 'Chat with AI',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
