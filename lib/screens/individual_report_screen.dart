import 'package:flutter/material.dart';
import 'package:modik_pages/screens/individual_upload.dart';
import '../data/dummy_report_data.dart';
import '../widgets/individual_report_card.dart';
import '../widgets/report_action_buttons.dart';

const Color mainPurple = Color(0xFF9DA3D9);

class IndividualReportScreen extends StatelessWidget {
  const IndividualReportScreen({super.key});

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
                      MaterialPageRoute(
                        builder: (_) => IndividualUploadScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const Expanded(
                  child: Text(
                    "Genetic Disease Analysis Report",
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
            ...dummyIndividualReports.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IndividualReportCard(item: item),
              ),
            ),
            const SizedBox(height: 20),

            ReportActionButtons(
              onDownloadPdf: () {},
              onAskAi: () {},
              onConsultExpert: () {},
              pdfLabel: 'Download Full Report (PDF)',
              aiLabel: 'Ask AI about results',
            ),
          ],
        ),
      ),
    );
  }
}
