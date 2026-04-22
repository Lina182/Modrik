import 'package:flutter/material.dart';
import '../models/cross_report_item.dart';
import '../widgets/cross_report_card.dart';
import '../widgets/report_action_buttons.dart';

const Color mainPurple = Color(0xFF9DA3D9);

class CrossReportScreen extends StatelessWidget {
  final List<CrossReportItem> reports;

  const CrossReportScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurple,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Expanded(
                  child: Text(
                    "Couple Genetic Risk Report",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.ios_share_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...reports.map((item) => CrossReportCard(item: item)),

            const SizedBox(height: 10),

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
    );
  }
}
