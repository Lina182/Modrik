import 'package:flutter/material.dart';

import '../../models/cross_report_item.dart';

import '../../widgets/cross_report_card.dart';
import '../../widgets/report_action_buttons.dart';

import '../../services/db_service.dart';
import '../../services/consultation_service.dart';

import 'AI_chat_screen.dart';
import 'home_screen.dart';

const Color mainPurple = Color(0xFF6C63FF);

class CrossReportScreen extends StatelessWidget {
  final List<CrossReportItem> reports;
  final String fileName;
  final bool showDownload;
  final bool isExpertView;

  const CrossReportScreen({
    super.key,
    required this.reports,
    required this.fileName,
    this.showDownload = true,
    this.isExpertView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Row(
              children: [
                // BACK
                IconButton(
                  onPressed: () {
                    if (isExpertView) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,

                        MaterialPageRoute(builder: (_) => const HomeScreen()),

                        (route) => false,
                      );
                    }
                  },

                  icon: const Icon(Icons.arrow_back, color: mainPurple),
                ),

                // TITLE
                Expanded(
                  child: Text(
                    fileName,

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: mainPurple,
                    ),
                  ),
                ),

                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            // REPORTS
           ...reports.map((item) => CrossReportCard(item: item,isExpertView: isExpertView,),),

            const SizedBox(height: 10),

            // ACTION BUTTONS
            ReportActionButtons(
              isExpertView: isExpertView,

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

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Consultation sent successfully'
                          : 'Failed to send consultation',
                    ),
                  ),
                );
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
