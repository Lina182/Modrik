import 'package:flutter/material.dart';
import '../../models/cross_report_item.dart';
import '../../widgets/cross_report_card.dart';
import '../../widgets/report_action_buttons.dart';
import '../../services/db_service.dart';
import 'AI_chat_screen.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/consultation_service.dart';

const Color mainPurple = Color(0xFF9DA3D9);

class CrossReportScreen extends StatelessWidget {
  final List<CrossReportItem> reports;
  final String fileName;
  final bool showDownload;

  const CrossReportScreen({
    super.key,
    required this.reports,
    required this.fileName,
    this.showDownload = true,
  });

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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                Expanded(
                  child: Text(
                    fileName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Icon(Icons.ios_share_outlined, color: Colors.white),
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
              onDownloadPdf: showDownload
                  ? () async {
                      await DBService.saveReport(
                        items: reports.map((item) => item.toJson()).toList(),
                        title: fileName,
                        type: 'cross',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report saved locally')),
                      );
                    }
                  : null,

              onAskAi: () {
                final reportData = {
                  "title": fileName,
                  "data": reports.map((e) => e.toJson()).toList(),
                  "type": "cross",
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AIChatScreen(reportData: reportData),
                  ),
                );
              },
              onConsultExpert: (question) async {
                final userId = await getUserId();

                if (userId == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not logged in')),
                  );
                  return;
                }

                final success = await ConsultationService.createConsultation(
                  userId: userId,
                  type: 'cross',
                  reportName: fileName,
                  data: reports.map((e) => e.toJson()).toList(),
                  userQuestion: question,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consultation sent successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to send consultation'),
                    ),
                  );
                }
              },

              pdfLabel: 'Download Full Couple Report',
              aiLabel: 'Chat with AI',
            ),
          ],
        ),
      ),
    );
  }
}
