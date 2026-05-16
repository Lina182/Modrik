import 'package:flutter/material.dart';
import 'package:modik_pages/screens/users/home_screen.dart';
import '../../models/individual_report_item.dart';
import '../../widgets/individual_report_card.dart';
import '../../widgets/report_action_buttons.dart';
import '../../services/db_service.dart';
import '../../services/consultation_service.dart';
import 'AI_chat_screen.dart';

const Color mainPurple = Color(0xFF6C63FF);
const Color screenBackground = Color(0xFFF7F8FF);

class IndividualReportScreen extends StatelessWidget {
  final List<IndividualReportItem> reportItems;
  final String fileName;
  final bool showDownload;
  final bool isExpertView;

  const IndividualReportScreen({
    super.key,
    required this.reportItems,
    required this.fileName,
    this.showDownload = true,
    this.isExpertView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,

      body: SafeArea(
        child: Column(
          children: [
            _ReportHeader(title: fileName, isExpertView: isExpertView),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                children: [
                  ...reportItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: IndividualReportCard(
                        item: item,
                        isExpertView: isExpertView,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ReportActionButtons(
                    isExpertView: isExpertView,
                    onDownloadPdf: showDownload
                        ? () async {
                            await DBService.saveReport(
                              items: reportItems
                                  .map((item) => item.toJson())
                                  .toList(),
                              title: fileName,
                              type: 'individual',
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Report saved locally'),
                              ),
                            );
                          }
                        : null,
                    onAskAi: () {
                      final reportData = {
                        "title": fileName,
                        "data": reportItems.map((e) => e.toJson()).toList(),
                        "type": "individual",
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

                      final success =
                          await ConsultationService.createConsultation(
                            userId: userId,
                            type: 'individual',
                            reportName: fileName,
                            data: reportItems.map((e) => e.toJson()).toList(),
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
                    pdfLabel: 'Download Full Report',
                    aiLabel: 'Ask AI about results',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String title;
  final bool isExpertView;

  const _ReportHeader({required this.title, required this.isExpertView});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(color: screenBackground),
      child: Row(
        children: [
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
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: mainPurple,
              size: 22,
            ),
          ),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: mainPurple,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
