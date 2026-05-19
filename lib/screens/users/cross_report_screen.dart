import 'package:flutter/material.dart';
import 'package:modik_pages/screens/users/home_screen.dart';

import '../../models/cross_report_item.dart';

import '../../widgets/cross_report_card.dart';
import '../../widgets/report_action_buttons.dart';

import '../../services/db_service.dart';
import '../../services/consultation_service.dart';
import '../../services/disease_service.dart';

import '../../l10n/app_localizations.dart';

import 'AI_chat_screen.dart';

const Color mainPurple = Color(0xFF6C63FF);
const Color screenBackground = Color(0xFFF7F8FF);

class CrossReportScreen extends StatefulWidget {
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
  State<CrossReportScreen> createState() =>
      _CrossReportScreenState();
}

class _CrossReportScreenState
    extends State<CrossReportScreen> {

  Map<String, String> translatedDiseases = {};

  bool isTranslating = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _translateDiseases();
    });
  }

  Future<void> _translateDiseases() async {

    final locale =
        Localizations.localeOf(context).languageCode;

    // اذا اللغة مو عربي لا تترجم
    if (locale != 'ar') {

      setState(() {
        isTranslating = false;
      });

      return;
    }

    try {

      final uniqueDiseases = widget.reports
          .map((e) => e.disease.trim())
          .toSet()
          .toList();

      final translatedMap =
          await DiseaseService.translateDiseases(
        uniqueDiseases,
      );

      if (mounted) {

        setState(() {
          translatedDiseases = translatedMap;

          isTranslating = false;
        });
      }

    } catch (e) {

      setState(() {
        isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final t =
        AppLocalizations.of(context)!;

    // لا تعرض الصفحة لين الترجمة تخلص
    if (isTranslating) {

      return const Scaffold(
        backgroundColor: screenBackground,

        body: Center(
          child: CircularProgressIndicator(
            color: mainPurple,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: screenBackground,

      body: SafeArea(
        child: Column(
          children: [

            _ReportHeader(
              title: widget.fileName,
              isExpertView: widget.isExpertView,
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  12,
                  18,
                  20,
                ),

                children: [

                  ...widget.reports.map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 18,
                      ),

                      child: CrossReportCard(
                        item: item,

                        translatedDisease:
                            translatedDiseases[
                                item.disease.trim()],

                        isExpertView:
                            widget.isExpertView,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ReportActionButtons(
                    isExpertView:
                        widget.isExpertView,

                    onDownloadPdf:
                        widget.showDownload
                            ? () async {

                                await DBService
                                    .saveReport(
                                  items: widget.reports
                                      .map(
                                        (item) =>
                                            item.toJson(),
                                      )
                                      .toList(),

                                  title:
                                      widget.fileName,

                                  type: 'cross',
                                );

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      t.savedReport,
                                    ),
                                  ),
                                );
                              }
                            : null,

                    onAskAi: () {

                      final reportData = {
                        "title":
                            widget.fileName,

                        "data": widget.reports
                            .map(
                              (e) => e.toJson(),
                            )
                            .toList(),

                        "type": "cross",
                      };

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              AIChatScreen(
                            reportData:
                                reportData,
                          ),
                        ),
                      );
                    },

                    onConsultExpert:
                        (question) async {

                      final userId =
                          await getUserId();

                      if (userId == 0) {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'User not logged in',
                            ),
                          ),
                        );

                        return;
                      }

                      final success =
                          await ConsultationService
                              .createConsultation(
                        userId: userId,

                        type: 'cross',

                        reportName:
                            widget.fileName,

                        data: widget.reports
                            .map(
                              (e) => e.toJson(),
                            )
                            .toList(),

                        userQuestion:
                            question,
                      );

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Consultation sent successfully'
                                : 'Failed to send consultation',
                          ),
                        ),
                      );
                    },

                    pdfLabel:
                        t.crossAnalysisReport,

                    aiLabel:
                        t.askAboutReport,
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

  const _ReportHeader({
    required this.title,
    required this.isExpertView,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 74,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration:
          const BoxDecoration(
        color: screenBackground,
      ),

      child: Row(
        children: [

          IconButton(
            onPressed: () {

              if (isExpertView) {

                Navigator.pop(context);

              } else {

                Navigator.pushAndRemoveUntil(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const HomeScreen(),
                  ),

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

              textAlign:
                  TextAlign.center,

              overflow:
                  TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 19,

                fontWeight:
                    FontWeight.w800,

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